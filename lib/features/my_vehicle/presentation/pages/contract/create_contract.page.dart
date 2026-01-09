import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common/widgets/loading/dialog_loading.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/create_contract/create_contract_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/create_contract/create_contract_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_banks/get_banks_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/get_provinces/get_province_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/step_indicator.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/steps/citizen_info_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/steps/business_info_step.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/steps/banking_info_step.page.dart';

class CreateContractPage extends StatefulWidget {
  const CreateContractPage({super.key});

  @override
  State<CreateContractPage> createState() => _CreateContractPageState();

  static Widget provider() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CreateContractCubit>()),
        BlocProvider(create: (_) => sl<GetMyProfileCubit>()),
        BlocProvider(create: (_) => sl<GetProvinceCubit>()),
        BlocProvider(create: (_) => sl<GetBanksCubit>()),
      ],
      child: const CreateContractPage(),
    );
  }
}

class _CreateContractPageState extends State<CreateContractPage> {
  int _currentStep = 0;

  // Step 1 data
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _citizenNumber = '';
  String? _citizenFrontPhoto;

  // Step 2 data
  String _businessType = 'personal';
  String? _businessName;
  String? _businessProvince;
  String? _businessAddress;
  String? _taxCode;
  String? _businessRegisterPhoto;
  String? _notes;

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

  @override
  void initState() {
    super.initState();
    context.read<GetMyProfileCubit>().getMyProfile();
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
    return BlocListener<CreateContractCubit, CreateContractState>(
      listener: (context, state) {
        if (state is CreateContractLoading) {
          LoadingDialog.show(context);
        } else if (state is CreateContractSuccess) {
          if (mounted) {
            eventBus.fire(ContractRegisteredEvent());
            Navigator.of(context).pop(); // Close loading dialog
            _showSuccessDialog();
          }
        } else if (state is CreateContractFailure) {
          if (mounted) {
            Navigator.of(context).pop(); // Close loading dialog
            _showErrorDialog(state.errorMessage);
          }
        }
      },
      child: BlocListener<GetMyProfileCubit, GetMyProfileState>(
        listener: (context, state) {
          if (state is GetMyProfileSuccess) {
            setState(() {
              _fullName = state.user.fullName ?? '';
              _email = state.user.email ?? '';
              _phone = state.user.phone ?? '';
              _citizenNumber = state.user.citizenId ?? '';
              _citizenFrontPhoto = state.user.citizenFrontImageUrl;
            });
            if (state.user.citizenId == null || state.user.citizenId!.isEmpty) {
              _showErrorDialog(
                AppLocalizations.of(context)!.youHaveNotVerifiedIdentity,
              );
            }
          } else if (state is GetMyProfileFailure) {
            _showErrorDialog(
              AppLocalizations.of(context)!.youHaveNotVerifiedIdentity,
            );
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!.contractInfo,
              showBackButton: true,
              onBackPressed: _handleBackPressed,
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
        ),
      ),
    );
  }

  void _handleBackPressed() {
    showAppDialog<void>(
      context: context,
      title: AppLocalizations.of(context)!.discardChangesTitle,
      content: AppLocalizations.of(context)!.discardChangesMessage,
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
                  AppLocalizations.of(context)!.cancel,
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
                  AppLocalizations.of(context)!.exit,
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

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return CitizenInfoStep(
          fullName: _fullName,
          email: _email,
          phone: _phone,
          citizenNumber: _citizenNumber,
          citizenFrontPhoto: _citizenFrontPhoto,
          onNext: ({
            required String fullName,
            required String email,
            required String phone,
            required String citizenNumber,
            String? citizenFrontPhoto,
          }) {
            setState(() {
              _fullName = fullName;
              _email = email;
              _phone = phone;
              _citizenNumber = citizenNumber;
              _citizenFrontPhoto = citizenFrontPhoto;
            });
            _nextStep();
          },
        );
      case 1:
        return BusinessInfoStep(
          businessType: _businessType,
          businessName: _businessName,
          businessProvince: _businessProvince,
          businessAddress: _businessAddress,
          taxCode: _taxCode,
          businessRegisterPhoto: _businessRegisterPhoto,
          notes: _notes,
          onNext: ({
            required String businessType,
            String? businessName,
            String? businessProvince,
            String? businessAddress,
            String? taxCode,
            String? businessRegisterPhoto,
            String? notes,
          }) {
            setState(() {
              _businessType = businessType;
              _businessName = businessName;
              _businessProvince = businessProvince;
              _businessAddress = businessAddress;
              _taxCode = taxCode;
              _businessRegisterPhoto = businessRegisterPhoto;
              _notes = notes;
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
      fullName: _fullName,
      email: _email,
      phoneNumber: _phone,
      citizenId: _citizenNumber,
      businessType: _businessType,
      businessName: _businessName ?? '',
      businessProvince: _businessProvince ?? '',
      businessAddress: _businessAddress ?? '',
      taxCode: _taxCode ?? '',
      businessRegisterPhoto: _businessRegisterPhoto,
      citizenFrontPhoto: _citizenFrontPhoto,
      bankName: _bankName ?? '',
      bankAccountNumber: _bankAccountNumber ?? '',
      bankAccountName: _bankAccountName ?? '',
      termsAccepted: _termsAccepted,
      notes: [
        if (_fullName.isNotEmpty)
          AppLocalizations.of(context)!.contractOwner(_fullName),
        if (_email.isNotEmpty)
          AppLocalizations.of(context)!.emailPrefix(_email),
        if (_phone.isNotEmpty)
          AppLocalizations.of(context)!.phonePrefix(_phone),
        if (_notes != null && _notes!.isNotEmpty) _notes!,
      ].where((value) => value.isNotEmpty).join(' • '),
    );

    context.read<CreateContractCubit>().createContract(contractParams);
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
