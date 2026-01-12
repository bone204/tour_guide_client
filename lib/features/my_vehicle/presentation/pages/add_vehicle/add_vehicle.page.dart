import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/step_indicator.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/steps/vehicle_info_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/steps/documentation_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/steps/pricing_step.page.dart';
import 'package:tour_guide_app/service_locator.dart';

class AddVehiclePage extends StatelessWidget {
  const AddVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddVehicleCubit>()..loadInitialData(),
      child: const _AddVehicleView(),
    );
  }
}

class _AddVehicleView extends StatefulWidget {
  const _AddVehicleView();

  @override
  State<_AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<_AddVehicleView> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: locale.addVehicle,
          showBackButton: true,
          onBackPressed: _handleBackPressed,
        ),
        body: BlocConsumer<AddVehicleCubit, AddVehicleState>(
          listener: (context, state) {
            if (state.status == AddVehicleStatus.success) {
              Navigator.pop(context);
              CustomSnackbar.show(
                context,
                message: locale.actionSuccess,
                type: SnackbarType.success,
              );
            } else if (state.status == AddVehicleStatus.failure) {
              CustomSnackbar.show(
                context,
                message: state.errorMessage ?? locale.errorOccurred,
                type: SnackbarType.error,
              );
            }
          },
          builder: (context, state) {
            if (state.status == AddVehicleStatus.loading &&
                state.approvedContracts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Container(
                  color: AppColors.primaryWhite,
                  child: StepIndicator(
                    currentStep: state.currentStep,
                    totalSteps: 3,
                    stepTitles: [
                      locale.vehicleInfo,
                      locale.document,
                      locale.totalPrice,
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _buildStepContent(context, state, locale),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleBackPressed() {
    final locale = AppLocalizations.of(context)!;
    showAppDialog<void>(
      context: context,
      title: locale.discardChangesTitle,
      content: locale.discardChangesMessage,
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  side: const BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  locale.cancel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  locale.exit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    AddVehicleState state,
    AppLocalizations locale,
  ) {
    final cubit = context.read<AddVehicleCubit>();

    switch (state.currentStep) {
      case 0:
        return VehicleInfoStep(
          approvedContracts: state.approvedContracts,
          vehicleCatalogs: state.vehicleCatalogs,
          selectedContract: state.selectedContract,
          selectedCatalog: state.selectedCatalog,
          licensePlate: state.licensePlate,
          onNext: ({
            required contract,
            required catalog,
            required licensePlate,
          }) {
            cubit.updateSelectedContract(contract);
            cubit.updateSelectedCatalog(catalog);
            cubit.updateLicensePlate(licensePlate);
            cubit.updateStep(1);
          },
        );
      case 1:
        return DocumentationStep(
          registrationFront: state.registrationFront,
          registrationBack: state.registrationBack,
          onNext: ({registrationFront, registrationBack}) {
            cubit.updateRegistrationFront(registrationFront);
            cubit.updateRegistrationBack(registrationBack);
            cubit.updateStep(2);
          },
          onBack: () => cubit.updateStep(0),
        );
      case 2:
        return PricingStep(
          pricePerHour: state.pricePerHour,
          pricePerDay: state.pricePerDay,
          priceFor4Hours: state.priceFor4Hours,
          priceFor8Hours: state.priceFor8Hours,
          priceFor12Hours: state.priceFor12Hours,
          priceFor2Days: state.priceFor2Days,
          priceFor3Days: state.priceFor3Days,
          priceFor5Days: state.priceFor5Days,
          priceFor7Days: state.priceFor7Days,
          requirements: state.requirements,
          description: state.description,
          isSubmitting: state.status == AddVehicleStatus.loading,
          onSubmit: ({
            pricePerHour,
            pricePerDay,
            priceFor4Hours,
            priceFor8Hours,
            priceFor12Hours,
            priceFor2Days,
            priceFor3Days,
            priceFor5Days,
            priceFor7Days,
            required requirements,
            required description,
          }) {
            if (pricePerHour != null) {
              cubit.updatePricePerHour(pricePerHour.toStringAsFixed(0));
            }
            if (pricePerDay != null) {
              cubit.updatePricePerDay(pricePerDay.toStringAsFixed(0));
            }
            if (priceFor4Hours != null)
              cubit.updatePriceFor4Hours(priceFor4Hours.toStringAsFixed(0));
            if (priceFor8Hours != null)
              cubit.updatePriceFor8Hours(priceFor8Hours.toStringAsFixed(0));
            if (priceFor12Hours != null)
              cubit.updatePriceFor12Hours(priceFor12Hours.toStringAsFixed(0));
            if (priceFor2Days != null)
              cubit.updatePriceFor2Days(priceFor2Days.toStringAsFixed(0));
            if (priceFor3Days != null)
              cubit.updatePriceFor3Days(priceFor3Days.toStringAsFixed(0));
            if (priceFor5Days != null)
              cubit.updatePriceFor5Days(priceFor5Days.toStringAsFixed(0));
            if (priceFor7Days != null)
              cubit.updatePriceFor7Days(priceFor7Days.toStringAsFixed(0));

            cubit.updateRequirements(requirements);
            cubit.updateDescription(description);
            cubit.submitVehicle();
          },
          onBack: () => cubit.updateStep(1),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
