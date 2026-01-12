import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_email/verify_email_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_email/verify_email_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class VerifyEmailPage extends StatelessWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VerifyEmailCubit>(),
      child: _VerifyEmailBody(email: email),
    );
  }
}

class _VerifyEmailBody extends StatefulWidget {
  final String email;
  const _VerifyEmailBody({required this.email});

  @override
  State<_VerifyEmailBody> createState() => _VerifyEmailBodyState();
}

class _VerifyEmailBodyState extends State<_VerifyEmailBody> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _token;
  Timer? _timer;
  int _start = 600; // 10 minutes (600 seconds)
  bool _canResend = true;

  @override
  void dispose() {
    _pinController.dispose();
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: l10n.verifyEmail,
          showBackButton: true,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocListener<VerifyEmailCubit, VerifyEmailState>(
          listener: (context, state) {
            if (state is SendCodeSuccess) {
              _token = state.token;
              _startTimer();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.codeSentSuccess)));
            } else if (state is VerifyEmailSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.emailVerifiedSuccess)),
              );
              Navigator.pop(context, true);
            } else if (state is VerifyEmailFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.verifyEmailMessage(widget.email),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _pinController,
                    focusNode: _focusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) {
                      // Automatically verify or wait for button press
                    },
                  ),
                ),

                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
                    builder: (context, state) {
                      final isLoading = state is SendCodeLoading;
                      return InkWell(
                        onTap:
                            (_canResend && !isLoading)
                                ? () {
                                  context
                                      .read<VerifyEmailCubit>()
                                      .sendVerificationCode();
                                }
                                : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _canResend
                                    ? AppColors.primaryYellow
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child:
                              isLoading
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
                                        ? (_start == 600
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
                      );
                    },
                  ),
                ),

                SizedBox(height: 50.h),

                BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
                  builder: (context, state) {
                    final isLoading = state is VerifyCodeLoading;
                    return PrimaryButton(
                      title: l10n.verify,
                      isLoading: isLoading,
                      onPressed: () {
                        final code = _pinController.text;
                        if (code.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.enterValid6DigitCode)),
                          );
                          return;
                        }
                        if (_token == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.requestCodeFirst)),
                          );
                          return;
                        }

                        context.read<VerifyEmailCubit>().verifyEmail(
                          email: widget.email,
                          code: code,
                          token: _token!,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
