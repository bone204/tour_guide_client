import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_password_field.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_params.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/sign_up.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/bloc/button/button_state.dart';
import 'package:tour_guide_app/common/bloc/button/button_state_cubit.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_cubit.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_state.dart';
import 'package:tour_guide_app/common/widgets/dropdown/lang_dropdown.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormSubmitted = false;

  // ===== Validation =====
  String? _validateUsername(String? value) {
    if (!_isFormSubmitted) return null;
    if (value == null || value.isEmpty)
      return AppLocalizations.of(context)!.pleaseEnterUsername;
    if (value.length < 3)
      return AppLocalizations.of(context)!.usernameMinLength;
    if (value.length > 20)
      return AppLocalizations.of(context)!.usernameMaxLength;
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(value))
      return AppLocalizations.of(context)!.usernameInvalid;
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_isFormSubmitted) return null;
    if (value == null || value.isEmpty)
      return AppLocalizations.of(context)!.pleaseEnterPassword;
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMinLength;
    }
    // if (value.length > 50) return 'Mật khẩu không được vượt quá 50 ký tự';
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
    //   return 'Phải có ít nhất 1 chữ hoa, 1 chữ thường và 1 số';
    // }
    return null;
  }

  String? _validateConfirmedPassword(String? value) {
    if (!_isFormSubmitted) return null;
    if (value == null || value.isEmpty)
      return AppLocalizations.of(context)!.pleaseConfirmPassword;
    if (value != _passwordController.text)
      return AppLocalizations.of(context)!.passwordMismatch;
    return null;
  }

  // ===== Handle Sign Up =====
  void _handleSignUp(BuildContext context) async {
    setState(() => _isFormSubmitted = true);
    _formKey.currentState!.validate();
    if (_validateUsername(_usernameController.text) == null &&
        _validatePassword(_passwordController.text) == null &&
        _validateConfirmedPassword(_confirmedPasswordController.text) == null) {
      context.read<ButtonStateCubit>().execute(
        usecase: sl<SignUpUseCase>(),
        params: SignUpParams(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleSignIn() {
    Navigator.pushReplacementNamed(context, AppRouteConstant.signIn);
  }

  void _handleTapOutside() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              // Navigate to sign in page after successful registration
              Navigator.pushReplacementNamed(context, AppRouteConstant.signIn);
            }
            if (state is ButtonFailureState) {
              String errorMessage = state.errorMessage;
              if (state.statusCode == 409) {
                errorMessage =
                    AppLocalizations.of(context)!.usernameAlreadyExists;
              }

              showAppDialog(
                context: context,
                title: AppLocalizations.of(context)!.error,
                content: errorMessage,
                icon: Icons.error_outline,
                iconColor: Colors.red,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.close),
                  ),
                ],
              );
            }
          },
          child: Stack(
            children: [
              GestureDetector(
                onTap: _handleTapOutside,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 120.h, 20.w, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.signUpNow,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          AppLocalizations.of(context)!.signUpDescription,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSubtitle),
                        ),
                        SizedBox(height: 40.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextField(
                                label: AppLocalizations.of(context)!.username,
                                placeholder:
                                    AppLocalizations.of(context)!.enterUsername,
                                prefixIconData: Icons.person_outline,
                                controller: _usernameController,
                                validator: _validateUsername,
                              ),
                              SizedBox(height: 16.h),
                              CustomPasswordField(
                                label: AppLocalizations.of(context)!.password,
                                placeholder:
                                    AppLocalizations.of(context)!.enterPassword,
                                prefixIcon: Icon(Icons.lock_outline),
                                controller: _passwordController,
                                validator: _validatePassword,
                              ),
                              SizedBox(height: 16.h),
                              CustomPasswordField(
                                label: AppLocalizations.of(context)!.password,
                                placeholder:
                                    AppLocalizations.of(context)!.enterPassword,
                                prefixIcon: Icon(Icons.lock_outline),
                                controller: _confirmedPasswordController,
                                validator: _validateConfirmedPassword,
                              ),
                              SizedBox(height: 40.h),
                              Builder(
                                builder: (context) {
                                  return PrimaryButton(
                                    title: AppLocalizations.of(context)!.signUp,
                                    onPressed: () => _handleSignUp(context),
                                    backgroundColor: AppColors.primaryBlue,
                                    textColor: AppColors.textSecondary,
                                  );
                                },
                              ),
                              SizedBox(height: 40.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.alreadyHaveAccount,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSubtitle,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _handleSignIn,
                                    child: Text(
                                      AppLocalizations.of(context)!.signIn,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.displayLarge?.copyWith(
                                        color: AppColors.primaryOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(top: 40.h, right: 20.w, child: LanguageDropdown()),
              BlocBuilder<ButtonStateCubit, ButtonState>(
                builder: (context, state) {
                  if (state is ButtonLoadingState) {
                    FocusScope.of(context).unfocus();
                    return AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, state) {
                  if (state is LocaleLoading) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    super.dispose();
  }
}
