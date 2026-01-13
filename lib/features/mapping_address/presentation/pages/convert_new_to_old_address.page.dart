import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';

import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/convert_new_to_old_address/convert_new_to_old_address_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class ConvertNewToOldAddressPage extends StatefulWidget {
  const ConvertNewToOldAddressPage({super.key});

  @override
  State<ConvertNewToOldAddressPage> createState() =>
      _ConvertNewToOldAddressPageState();
}

class _ConvertNewToOldAddressPageState
    extends State<ConvertNewToOldAddressPage> {
  final _addressController = TextEditingController();
  late ConvertNewToOldAddressCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ConvertNewToOldAddressCubit>();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.convertNewToOldAddressPageTitle,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<
          ConvertNewToOldAddressCubit,
          ConvertNewToOldAddressState
        >(
          listener: (context, state) {
            if (state.status == ConvertNewToOldAddressStatus.failure) {
              CustomSnackbar.show(
                context,
                message:
                    (state.errorMessage != null &&
                            state.errorMessage!.contains('Address too short'))
                        ? AppLocalizations.of(context)!.addressTooShortNewToOld
                        : AppLocalizations.of(context)!.convertFailed,
                type: SnackbarType.error,
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _addressController,
                    placeholder:
                        AppLocalizations.of(
                          context,
                        )!.enterNewAddressPlaceholder,
                    label: AppLocalizations.of(context)!.newAddressLabel,
                  ),
                  SizedBox(height: 24.h),
                  PrimaryButton(
                    title: AppLocalizations.of(context)!.convertButton,
                    isLoading:
                        state.status == ConvertNewToOldAddressStatus.loading,
                    onPressed: () {
                      if (_addressController.text.isNotEmpty) {
                        _cubit.convert(_addressController.text);
                      } else {
                        CustomSnackbar.show(
                          context,
                          message:
                              AppLocalizations.of(
                                context,
                              )!.pleaseEnterAddressError,
                          type: SnackbarType.warning,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 24.h),
                  if (state.status == ConvertNewToOldAddressStatus.success &&
                      state.result != null)
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.result!.oldAddresses.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          return _buildResultItem(
                            state.result!.oldAddresses[index],
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultItem(String result) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.secondaryGrey.withOpacity(0.1),

        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
      ),
      child: Text(
        result,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
