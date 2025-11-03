import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/register_rental_vehicle/register_rental_vehicle_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/register_rental_vehicle/register_rental_vehicle_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/step_indicator.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/steps/identify_info_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/steps/tax_info_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/steps/banking_info_step.page.dart';

class VehicleRentalRegisterPage extends StatefulWidget {
  const VehicleRentalRegisterPage({super.key});

  @override
  State<VehicleRentalRegisterPage> createState() => _VehicleRentalRegisterPageState();
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is RegisterRentalVehicleSuccess) {
          Navigator.of(context).pop(); // Close loading dialog
          _showSuccessDialog();
        } else if (state is RegisterRentalVehicleFailure) {
          Navigator.of(context).pop(); // Close loading dialog
          _showErrorDialog(state.errorMessage);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: "Vehicle Rental Register",
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
                  'Identity Information',
                  'Tax\nInformation',
                  'Banking Information',
                ],
              ),
            ),
            // Step Content
            Expanded(
              child: _buildStepContent(),
            ),
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
      userId: 1,
      externalId: null,
      fullName: _fullName,
      email: _email,
      phone: _phone,
      identificationNumber: _identificationNumber,
      identificationPhoto: _identificationPhoto,
      businessType: _businessType,
      businessName: _businessName,
      businessProvince: null,
      businessCity: null,
      businessAddress: _businessAddress,
      taxCode: _taxCode,
      businessRegisterPhoto: _businessRegisterPhoto,
      citizenFrontPhoto: null,
      citizenBackPhoto: null,
      contractTerm: null,
      notes: null,
      bankName: _bankName,
      bankAccountNumber: _bankAccountNumber,
      bankAccountName: _bankAccountName,
      termsAccepted: _termsAccepted,
    );

    context.read<RegisterRentalVehicleCubit>().registerRentalVehicle(contractParams);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 48.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Registration Successful!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your vehicle rental registration has been submitted successfully. We will review your information and contact you soon.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop();
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
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: AppColors.primaryRed,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Registration Failed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
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
            ),
          ),
        );
      },
    );
  }
}
