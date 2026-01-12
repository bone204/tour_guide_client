import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_phone/verify_phone_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_phone/verify_phone_state.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';

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
  final FocusNode _focusNode = FocusNode();
  String? _sessionInfo;
  Timer? _timer;
  int _start = 600; // 10 minutes
  bool _canResend = true;

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _start = 600;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get _formattedTime {
    final minutes = (_start / 60).floor().toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              _sessionInfo = state.sessionInfo;
              _startTimer();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.codeSentSuccess)));
            }
          },
          builder: (context, state) {
            return _buildVerificationForm(context, state, l10n);
          },
        ),
      ),
    );
  }

  Widget _buildVerificationForm(
    BuildContext context,
    VerifyPhoneState state,
    AppLocalizations l10n,
  ) {
    final isLoading =
        state is VerifyPhoneLoading || state is VerifyPhoneVerifying;

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

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.verifyPhoneMessage(widget.phoneNumber),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.textSubtitle),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Pinput(
              controller: _otpController,
              length: 6,
              focusNode: _focusNode,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) {
                // Wait for manual submit
              },
            ),
          ),
          SizedBox(height: 30.h),

          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap:
                  (_canResend && !isLoading)
                      ? () {
                        context.read<VerifyPhoneCubit>().sendCode(
                          widget.phoneNumber,
                        );
                      }
                      : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color:
                      _canResend ? AppColors.primaryYellow : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child:
                    isLoading && state is VerifyPhoneLoading
                        ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                        : Text(
                          _canResend
                              ? (_sessionInfo == null
                                  ? l10n.sendCode
                                  : l10n.resendCode)
                              : _formattedTime,
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(
                            color:
                                _canResend
                                    ? AppColors.primaryBlack
                                    : AppColors.primaryGrey,
                          ),
                        ),
              ),
            ),
          ),

          SizedBox(height: 50.h),

          PrimaryButton(
            title: l10n.verify,
            isLoading: state is VerifyPhoneVerifying,
            onPressed: () {
              final pin = _otpController.text;
              if (pin.length != 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.enterValid6DigitCode)),
                );
                return;
              }
              if (_sessionInfo == null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.requestCodeFirst)));
                return;
              }
              context.read<VerifyPhoneCubit>().verifyCode(
                pin,
                widget.phoneNumber,
                _sessionInfo!,
              );
            },
          ),
        ],
      ),
    );
  }
}
