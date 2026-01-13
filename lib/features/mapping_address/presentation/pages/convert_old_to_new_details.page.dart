import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart'; // Added import

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/legacy_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/convert_old_to_new_details/convert_old_to_new_details_cubit.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/legacy_locations/legacy_locations_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class ConvertOldToNewDetailsPage extends StatefulWidget {
  const ConvertOldToNewDetailsPage({super.key});

  @override
  State<ConvertOldToNewDetailsPage> createState() =>
      _ConvertOldToNewDetailsPageState();
}

class _ConvertOldToNewDetailsPageState
    extends State<ConvertOldToNewDetailsPage> {
  late ConvertOldToNewDetailsCubit _cubit; // Added

  @override
  void initState() {
    // Added
    super.initState();
    _cubit = sl<ConvertOldToNewDetailsCubit>();
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
        BlocProvider(create: (_) => sl<LegacyLocationsCubit>()..getProvinces()),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          // Changed AppBar to CustomAppBar
          title: AppLocalizations.of(context)!.convertOldToNewDetailsPageTitle,
          onBackPressed: () => Navigator.pop(context), // Added onBackPressed
        ),
        body: BlocConsumer<
          ConvertOldToNewDetailsCubit,
          ConvertOldToNewDetailsState
        >(
          listener: (context, state) {
            if (state.status == ConvertOldToNewDetailsStatus.failure) {
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
            return BlocBuilder<LegacyLocationsCubit, LegacyLocationsState>(
              builder: (context, legacyState) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDropdown<LegacyProvince>(
                        label:
                            AppLocalizations.of(context)!.legacyProvinceLabel,
                        hint:
                            AppLocalizations.of(
                              context,
                            )!.enterLegacyProvincePlaceholder,
                        value: legacyState.selectedProvince,
                        items: legacyState.provinces,
                        itemLabel: (item) => item.name,
                        onChanged: (value) {
                          context.read<LegacyLocationsCubit>().selectProvince(
                            value,
                          );
                        },
                      ),

                      SizedBox(height: 16.h),
                      _buildDropdown<LegacyDistrict>(
                        label:
                            AppLocalizations.of(context)!.legacyDistrictLabel,
                        hint:
                            AppLocalizations.of(
                              context,
                            )!.enterLegacyDistrictPlaceholder,
                        value: legacyState.selectedDistrict,
                        items: legacyState.districts,
                        itemLabel: (item) => item.name,
                        onChanged: (value) {
                          context.read<LegacyLocationsCubit>().selectDistrict(
                            value,
                          );
                        },
                      ),

                      SizedBox(height: 16.h),
                      _buildDropdown<LegacyWard>(
                        label: AppLocalizations.of(context)!.legacyWardLabel,
                        hint:
                            AppLocalizations.of(
                              context,
                            )!.enterLegacyWardPlaceholder,
                        value: legacyState.selectedWard,
                        items: legacyState.wards,
                        itemLabel: (item) => item.name,
                        onChanged: (value) {
                          context.read<LegacyLocationsCubit>().selectWard(
                            value,
                          );
                        },
                      ),

                      SizedBox(height: 24.h),
                      PrimaryButton(
                        title: AppLocalizations.of(context)!.convertButton,
                        isLoading:
                            convertState.status ==
                            ConvertOldToNewDetailsStatus.loading,
                        onPressed: () {
                          if (legacyState.selectedProvince != null &&
                              legacyState.selectedDistrict != null &&
                              legacyState.selectedWard != null) {
                            _cubit.convert(
                              province: legacyState.selectedProvince!.name,
                              district: legacyState.selectedDistrict!.name,
                              ward: legacyState.selectedWard!.name,
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
                              ConvertOldToNewDetailsStatus.success &&
                          convertState.result != null)
                        _buildResult(convertState.result!),
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

  Widget _buildResult(dynamic result) {
    // Should be properly typed
    final province = result.province;
    final commune = result.commune;

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
          Text(
            AppLocalizations.of(context)!.newAdminUnitLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildRow(AppLocalizations.of(context)!.provinceLabel, province.name),
          SizedBox(height: 8.h),
          _buildRow(AppLocalizations.of(context)!.communeLabel, commune.name),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
