import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common/widgets/loading/dialog_loading.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_rental_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/step_indicator.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/steps/vehicle_info_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/steps/documentation_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/steps/rental_info_step.page.dart';

class AddVehiclePage extends StatefulWidget {
  final int contractId;

  const AddVehiclePage({super.key, required this.contractId});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  int _currentStep = 0;

  // Step 1 data - Vehicle Information
  String _licensePlate = '';
  String _vehicleRegistration = '';
  String _vehicleType = 'car';
  String _vehicleBrand = '';
  String _vehicleModel = '';
  String _vehicleColor = '';

  // Step 2 data - Documentation
  String? _registrationFrontPhoto;
  String? _registrationBackPhoto;

  // Step 3 data - Rental Information
  String? _pricePerHour;
  String? _pricePerDay;
  String? _requirements;

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddVehicleCubit, AddVehicleState>(
      listener: (context, state) {
        if (state is AddVehicleLoading) {
          LoadingDialog.show(context);
        } else if (state is AddVehicleSuccess) {
          // Đóng loading dialog trước
          Navigator.of(context, rootNavigator: true).pop();
          // Delay nhỏ trước khi hiển thị success dialog
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _showSuccessDialog();
            }
          });
        } else if (state is AddVehicleFailure) {
          // Đóng loading dialog trước
          Navigator.of(context, rootNavigator: true).pop();
          // Delay nhỏ trước khi hiển thị error dialog
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _showErrorDialog(state.errorMessage);
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: "Add Vehicle",
          showBackButton: true,
          onBackPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        body: Column(
          children: [
            // Step Indicator
            Container(
              color: AppColors.primaryWhite,
              child: StepIndicator(
                currentStep: _currentStep,
                totalSteps: 3,
                stepTitles: const [
                  'Vehicle Information',
                  'Documentation\n',
                  'Rental Information',
                ],
              ),
            ),
            // Step Content
            Expanded(child: _buildStepContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return VehicleInfoStep(
          licensePlate: _licensePlate,
          vehicleRegistration: _vehicleRegistration,
          vehicleType: _vehicleType,
          vehicleBrand: _vehicleBrand,
          vehicleModel: _vehicleModel,
          vehicleColor: _vehicleColor,
          onNext: ({
            required String licensePlate,
            required String vehicleRegistration,
            required String vehicleType,
            required String vehicleBrand,
            required String vehicleModel,
            required String vehicleColor,
          }) {
            setState(() {
              _licensePlate = licensePlate;
              _vehicleRegistration = vehicleRegistration;
              _vehicleType = vehicleType;
              _vehicleBrand = vehicleBrand;
              _vehicleModel = vehicleModel;
              _vehicleColor = vehicleColor;
            });
            _nextStep();
          },
        );
      case 1:
        return DocumentationStep(
          registrationFrontPhoto: _registrationFrontPhoto,
          registrationBackPhoto: _registrationBackPhoto,
          onNext: ({
            String? registrationFrontPhoto,
            String? registrationBackPhoto,
          }) {
            setState(() {
              _registrationFrontPhoto = registrationFrontPhoto;
              _registrationBackPhoto = registrationBackPhoto;
            });
            _nextStep();
          },
          onBack: _previousStep,
        );
      case 2:
        return RentalInfoStep(
          pricePerHour: _pricePerHour,
          pricePerDay: _pricePerDay,
          requirements: _requirements,
          onSubmit: ({
            String? pricePerHour,
            String? pricePerDay,
            String? requirements,
          }) {
            setState(() {
              _pricePerHour = pricePerHour;
              _pricePerDay = pricePerDay;
              _requirements = requirements;
            });
            _handleSubmit();
          },
          onBack: _previousStep,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleSubmit() {
    final pricePerHourValue = double.tryParse(_pricePerHour ?? '') ?? 0;
    final pricePerDayValue = double.tryParse(_pricePerDay ?? '') ?? 0;

    final description = [
      if (_vehicleBrand.isNotEmpty) _vehicleBrand,
      if (_vehicleModel.isNotEmpty) _vehicleModel,
      if (_vehicleColor.isNotEmpty) 'Color: $_vehicleColor',
      if (_vehicleRegistration.isNotEmpty)
        'Registration: $_vehicleRegistration',
    ].where((value) => value.trim().isNotEmpty).join(' • ');

    final vehicle = VehicleRentalParams(
      licensePlate: _licensePlate,
      contractId: widget.contractId,
      pricePerHour: pricePerHourValue,
      pricePerDay: pricePerDayValue,
      requirements: _requirements,
      description: description.isNotEmpty ? description : null,
      status: RentalVehicleApprovalStatus.pending,
      availability: RentalVehicleAvailabilityStatus.available,
    );

    context.read<AddVehicleCubit>().addVehicle(vehicle);
  }

  void _showSuccessDialog() {
    showAppDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      iconWidget: _buildDialogIcon(
        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
        iconColor: AppColors.primaryBlue,
        icon: Icons.check_circle,
      ),
      titleWidget: Text(
        'Vehicle Added Successfully!',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      contentWidget: Text(
        'Your vehicle has been added successfully and is now available for rental.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSubtitle,
            ),
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              if (mounted) {
                Navigator.of(context, rootNavigator: true).pop(true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Done',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryWhite,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorDialog(String message) {
    showAppDialog<void>(
      context: context,
      useRootNavigator: true,
      iconWidget: _buildDialogIcon(
        backgroundColor: AppColors.primaryRed.withOpacity(0.1),
        iconColor: AppColors.primaryRed,
        icon: Icons.error_outline,
      ),
      titleWidget: Text(
        'Failed to Add Vehicle',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      contentWidget: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSubtitle,
            ),
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Try Again',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryWhite,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogIcon({
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 48.sp,
        color: iconColor,
      ),
    );
  }
}
