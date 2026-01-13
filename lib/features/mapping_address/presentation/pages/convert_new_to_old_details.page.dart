import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_details_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/reform_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/convert_new_to_old_details/convert_new_to_old_details_cubit.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/reform_locations/reform_locations_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';

class ConvertNewToOldDetailsPage extends StatefulWidget {
  const ConvertNewToOldDetailsPage({super.key});

  @override
  State<ConvertNewToOldDetailsPage> createState() =>
      _ConvertNewToOldDetailsPageState();
}

class _ConvertNewToOldDetailsPageState
    extends State<ConvertNewToOldDetailsPage> {
  late ConvertNewToOldDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ConvertNewToOldDetailsCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _cubit),
        BlocProvider(create: (_) => sl<ReformLocationsCubit>()..getProvinces()),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.convertNewToOldDetailsPageTitle,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<
          ConvertNewToOldDetailsCubit,
          ConvertNewToOldDetailsState
        >(
          listener: (context, state) {
            if (state.status == ConvertNewToOldDetailsStatus.failure) {
              CustomSnackbar.show(
                context,
                message:
                    state.errorMessage ??
                    AppLocalizations.of(context)!.errorOccurred,
                type: SnackbarType.error,
              );
            }
          },
          builder: (context, convertState) {
            return BlocBuilder<ReformLocationsCubit, ReformLocationsState>(
              builder: (context, reformState) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDropdown<ReformProvince>(
                        label:
                            AppLocalizations.of(context)!.reformProvinceLabel,
                        hint:
                            AppLocalizations.of(
                              context,
                            )!.enterReformProvincePlaceholder,
                        value: reformState.selectedProvince,
                        items: reformState.provinces,
                        itemLabel: (item) => item.name,
                        onChanged: (value) {
                          context.read<ReformLocationsCubit>().selectProvince(
                            value,
                          );
                        },
                      ),

                      SizedBox(height: 16.h),
                      _buildDropdown<ReformCommune>(
                        label: AppLocalizations.of(context)!.reformCommuneLabel,
                        hint:
                            AppLocalizations.of(
                              context,
                            )!.enterReformCommunePlaceholder,
                        value: reformState.selectedCommune,
                        items: reformState.communes,
                        itemLabel: (item) => item.name,
                        onChanged: (value) {
                          context.read<ReformLocationsCubit>().selectCommune(
                            value,
                          );
                        },
                      ),

                      SizedBox(height: 24.h),
                      PrimaryButton(
                        title: AppLocalizations.of(context)!.convertButton,
                        isLoading:
                            convertState.status ==
                            ConvertNewToOldDetailsStatus.loading,
                        onPressed: () {
                          if (reformState.selectedProvince != null &&
                              reformState.selectedCommune != null) {
                            _cubit.convert(
                              province: reformState.selectedProvince!.name,
                              commune: reformState.selectedCommune!.name,
                            );
                          } else {
                            CustomSnackbar.show(
                              context,
                              message:
                                  AppLocalizations.of(
                                    context,
                                  )!.pleaseFillAllFieldsError,
                              type: SnackbarType.warning,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 24.h),
                      if (convertState.status ==
                              ConvertNewToOldDetailsStatus.success &&
                          convertState.result != null)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: convertState.result!.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            return _buildResultItem(
                              convertState.result![index],
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String label,
    required String hint,
    required Function(T?) onChanged,
    required String Function(T) itemLabel,
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 6.h),
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            hint:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(
                      hint,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            items:
                items
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          itemLabel(item),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
            value: value,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              padding: EdgeInsets.only(left: 12.w, right: 12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: const Icon(Icons.arrow_drop_down_sharp),
              iconSize: 24.w,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primaryWhite,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultItem(ConvertNewToOldDetailsItem item) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.secondaryGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            AppLocalizations.of(context)!.provinceLabel,
            item.province?.name ?? '',
          ),
          SizedBox(height: 4.h),
          _buildRow(
            AppLocalizations.of(context)!.districtLabel,
            item.district?.name ?? '',
          ),
          SizedBox(height: 4.h),
          _buildRow(
            AppLocalizations.of(context)!.wardLabel,
            item.ward?.name ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
