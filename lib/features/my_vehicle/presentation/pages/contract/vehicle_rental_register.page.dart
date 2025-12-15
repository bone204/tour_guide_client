import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common/widgets/loading/dialog_loading.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/register_rental_vehicle/register_rental_vehicle_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/register_rental_vehicle/register_rental_vehicle_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/step_indicator.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/steps/identify_info_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/steps/tax_info_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/steps/banking_info_step.page.dart';

class VehicleRentalRegisterPage extends StatefulWidget {
  const VehicleRentalRegisterPage({super.key});

  @override
  State<VehicleRentalRegisterPage> createState() =>
      _VehicleRentalRegisterPageState();
}

class _VehicleRentalRegisterPageState extends State<VehicleRentalRegisterPage> {
  int _currentStep = 0;

  // Step 1 data
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _identificationNumber = '';
  String? _identificationPhoto;

  // Step 2 data
  String _businessType = 'personal';
  String? _businessName;
  String? _businessAddress;
  String? _taxCode;
  String? _businessRegisterPhoto;

  // Step 3 data
  String? _bankName;
  String? _bankAccountNumber;
  String? _bankAccountName;
  bool _termsAccepted = false;

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
    return BlocListener<RegisterRentalVehicleCubit, RegisterRentalVehicleState>(
      listener: (context, state) {
        if (state is RegisterRentalVehicleLoading) {
          LoadingDialog.show(context);
        } else if (state is RegisterRentalVehicleSuccess) {
          if (mounted) {
            Navigator.of(context).pop(); // Close loading dialog
            _showSuccessDialog();
          }
        } else if (state is RegisterRentalVehicleFailure) {
          if (mounted) {
            Navigator.of(context).pop(); // Close loading dialog
            _showErrorDialog(state.errorMessage);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.vehicleRentalRegister,
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
                stepTitles: [
                  AppLocalizations.of(context)!.identityInformation,
                  AppLocalizations.of(context)!.taxInformation,
                  AppLocalizations.of(context)!.bankingInformation,
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
        return IdentifyInfoStep(
          fullName: _fullName,
          email: _email,
          phone: _phone,
          identificationNumber: _identificationNumber,
          identificationPhoto: _identificationPhoto,
          onNext: ({
            required String fullName,
            required String email,
            required String phone,
            required String identificationNumber,
            String? identificationPhoto,
          }) {
            setState(() {
              _fullName = fullName;
              _email = email;
              _phone = phone;
              _identificationNumber = identificationNumber;
              _identificationPhoto = identificationPhoto;
            });
            _nextStep();
          },
        );
      case 1:
        return TaxInfoStep(
          businessType: _businessType,
          businessName: _businessName,
          businessAddress: _businessAddress,
          taxCode: _taxCode,
          businessRegisterPhoto: _businessRegisterPhoto,
          onNext: ({
            required String businessType,
            String? businessName,
            String? businessAddress,
            String? taxCode,
            String? businessRegisterPhoto,
          }) {
            setState(() {
              _businessType = businessType;
              _businessName = businessName;
              _businessAddress = businessAddress;
              _taxCode = taxCode;
              _businessRegisterPhoto = businessRegisterPhoto;
            });
            _nextStep();
          },
          onBack: _previousStep,
        );
      case 2:
        return BankingInfoStep(
          bankName: _bankName,
          bankAccountNumber: _bankAccountNumber,
          bankAccountName: _bankAccountName,
          termsAccepted: _termsAccepted,
          onSubmit: ({
            String? bankName,
            String? bankAccountNumber,
            String? bankAccountName,
            required bool termsAccepted,
          }) {
            setState(() {
              _bankName = bankName;
              _bankAccountNumber = bankAccountNumber;
              _bankAccountName = bankAccountName;
              _termsAccepted = termsAccepted;
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
    final contractParams = ContractParams(
      citizenId: _identificationNumber,
      businessType: BusinessType.fromString(_businessType),
      businessName: _businessName,
      businessAddress: _businessAddress,
      taxCode: _taxCode,
      businessRegisterPhoto: _businessRegisterPhoto,
      citizenFrontPhoto: _identificationPhoto,
      bankName: _bankName,
      bankAccountNumber: _bankAccountNumber,
      bankAccountName: _bankAccountName,
      termsAccepted: _termsAccepted,
      notes: [
        if (_fullName.isNotEmpty)
          AppLocalizations.of(context)!.contractOwner(_fullName),
        if (_email.isNotEmpty)
          AppLocalizations.of(context)!.emailPrefix(_email),
        if (_phone.isNotEmpty)
          AppLocalizations.of(context)!.phonePrefix(_phone),
      ].where((value) => value.isNotEmpty).join(' • '),
    );

    context.read<RegisterRentalVehicleCubit>().registerRentalVehicle(
      contractParams,
    );
  }

  void _showSuccessDialog() {
    showAppDialog<void>(
      context: context,
      barrierDismissible: false,
      iconWidget: _buildDialogIcon(
        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
        iconColor: AppColors.primaryBlue,
        icon: Icons.check_circle,
      ),
      titleWidget: Text(
        AppLocalizations.of(context)!.registrationSuccessful,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      contentWidget: Text(
        AppLocalizations.of(context)!.registrationSuccessMessage,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
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
              AppLocalizations.of(context)!.done,
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
      iconWidget: _buildDialogIcon(
        backgroundColor: AppColors.primaryRed.withOpacity(0.1),
        iconColor: AppColors.primaryRed,
        icon: Icons.error_outline,
      ),
      titleWidget: Text(
        AppLocalizations.of(context)!.registrationFailed,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      contentWidget: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
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
              AppLocalizations.of(context)!.retry,
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
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, size: 48.sp, color: iconColor),
    );
  }
}
