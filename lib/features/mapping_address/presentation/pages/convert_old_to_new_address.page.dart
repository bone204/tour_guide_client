import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';

import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/convert_old_to_new_address/convert_old_to_new_address_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class ConvertOldToNewAddressPage extends StatefulWidget {
  const ConvertOldToNewAddressPage({super.key});

  @override
  State<ConvertOldToNewAddressPage> createState() =>
      _ConvertOldToNewAddressPageState();
}

class _ConvertOldToNewAddressPageState
    extends State<ConvertOldToNewAddressPage> {
  final _addressController = TextEditingController();
  late ConvertOldToNewAddressCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ConvertOldToNewAddressCubit>();
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
          title: AppLocalizations.of(context)!.convertOldToNewAddressPageTitle,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<
          ConvertOldToNewAddressCubit,
          ConvertOldToNewAddressState
        >(
          listener: (context, state) {
            if (state.status == ConvertOldToNewAddressStatus.failure) {
              CustomSnackbar.show(
                context,
                message:
                    state.errorMessage ??
                    AppLocalizations.of(context)!.errorOccurred,
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
                        )!.enterOldAddressPlaceholder,
                    label: AppLocalizations.of(context)!.oldAddressLabel,
                  ),

                  SizedBox(height: 24.h),
                  PrimaryButton(
                    title: AppLocalizations.of(context)!.convertButton,
                    isLoading:
                        state.status == ConvertOldToNewAddressStatus.loading,
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
                  if (state.status == ConvertOldToNewAddressStatus.success &&
                      state.result != null)
                    _buildResult(state.result!.newAddress),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResult(String result) {
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
            AppLocalizations.of(context)!.newAddressLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            result,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
