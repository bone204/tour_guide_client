import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
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
        appBar: CustomAppBar(title: locale.addVehicle, showBackButton: true, onBackPressed: () => Navigator.pop(context)),
        body: BlocConsumer<AddVehicleCubit, AddVehicleState>(
          listener: (context, state) {
            if (state.status == AddVehicleStatus.success) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(locale.actionSuccess)));
            } else if (state.status == AddVehicleStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? locale.errorOccurred),
                ),
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
          requirements: state.requirements,
          description: state.description,
          isSubmitting: state.status == AddVehicleStatus.loading,
          onSubmit: ({
            pricePerHour,
            pricePerDay,
            required requirements,
            required description,
          }) {
            if (pricePerHour != null)
              cubit.updatePricePerHour(pricePerHour.toString());
            if (pricePerDay != null)
              cubit.updatePricePerDay(pricePerDay.toString());
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
