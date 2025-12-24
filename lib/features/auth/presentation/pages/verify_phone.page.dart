import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/recaptcha/recaptcha_tool.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_phone/verify_phone_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_phone/verify_phone_state.dart';

class VerifyPhonePage extends StatelessWidget {
  final String phoneNumber;

  const VerifyPhonePage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VerifyPhoneCubit>(),
      child: _VerifyPhoneView(phoneNumber: phoneNumber),
    );
  }
}

class _VerifyPhoneView extends StatefulWidget {
  final String phoneNumber;

  const _VerifyPhoneView({required this.phoneNumber});

  @override
  State<_VerifyPhoneView> createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<_VerifyPhoneView> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.verifyPhoneTitle,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<VerifyPhoneCubit, VerifyPhoneState>(
        listener: (context, state) {
          if (state is VerifyPhoneFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is VerifyPhoneSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.phoneVerificationSuccess)),
            );
            Navigator.pop(context, true); // Return success
          } else if (state is VerifyPhoneCodeSent) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.codeSentSuccess)));
          }
        },
        builder: (context, state) {
          if (state is VerifyPhoneInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.recaptchaRequired,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  RecaptchaTool(
                    onTokenReceived: (token) {
                      context.read<VerifyPhoneCubit>().sendCode(
                        widget.phoneNumber,
                        token,
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is VerifyPhoneLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VerifyPhoneCodeSent ||
              state is VerifyPhoneVerifying) {
            return _buildVerificationForm(context, state, l10n);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildVerificationForm(
    BuildContext context,
    VerifyPhoneState state,
    AppLocalizations l10n,
  ) {
    final isLoading = state is VerifyPhoneVerifying;

    final defaultPinTheme = PinTheme(
      width: 64.w,
      height: 64.h,
      textStyle: Theme.of(
        context,
      ).textTheme.displayLarge?.copyWith(color: AppColors.primaryBlue),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryGrey),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryBlue),
      borderRadius: BorderRadius.circular(8.r),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.primaryBlue.withOpacity(0.2),
      ),
    );

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Text(
            l10n.verifyPhoneDescription(widget.phoneNumber),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 30.h),
          Pinput(
            controller: _otpController,
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            showCursor: true,
            onCompleted: (pin) {
              final currentState = context.read<VerifyPhoneCubit>().state;
              if (currentState is VerifyPhoneCodeSent) {
                context.read<VerifyPhoneCubit>().verifyCode(
                  pin,
                  widget.phoneNumber,
                  currentState.sessionInfo,
                );
              }
            },
          ),
          SizedBox(height: 30.h),
          if (isLoading)
            const CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: () {
                final pin = _otpController.text;
                if (pin.length == 6) {
                  final currentState = context.read<VerifyPhoneCubit>().state;
                  if (currentState is VerifyPhoneCodeSent) {
                    context.read<VerifyPhoneCubit>().verifyCode(
                      pin,
                      widget.phoneNumber,
                      currentState.sessionInfo,
                    );
                  }
                }
              },
              child: Text(l10n.verify),
            ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                      context
                          .read<VerifyPhoneCubit>()
                          .reset(); // Go back to captcha
                    },
            child: Text(l10n.resendCode),
          ),
        ],
      ),
    );
  }
}
