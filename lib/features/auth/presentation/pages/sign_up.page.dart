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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormSubmitted = false;

  // ===== Validation =====
  String? _validateUsername(String? value) {
    if (!_isFormSubmitted) return null;
    if (value == null || value.isEmpty) return 'Vui lòng nhập tên đăng nhập';
    if (value.length < 3) return 'Tên đăng nhập phải có ít nhất 3 ký tự';
    if (value.length > 20) return 'Tên đăng nhập không được vượt quá 20 ký tự';
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(value)) return 'Tên đăng nhập chỉ gồm chữ, số và gạch dưới';
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_isFormSubmitted) return null;
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
    // if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
    // if (value.length > 50) return 'Mật khẩu không được vượt quá 50 ký tự';
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
    //   return 'Phải có ít nhất 1 chữ hoa, 1 chữ thường và 1 số';
    // }
    return null;
  }

  String? _validateConfirmedPassword(String? value) {
    if (!_isFormSubmitted) return null;
    if (value == null || value.isEmpty) return 'Vui lòng xác nhận mật khẩu';
    if (value != _passwordController.text) return 'Mật khẩu không khớp';
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
              showAppDialog(
                context: context,
                title: 'Lỗi',
                content: state.errorMessage,
                icon: Icons.error_outline,
                iconColor: Colors.red,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng'),
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
                  padding: EdgeInsets.fromLTRB(20.w, 90.h, 20.w, 0),
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextField(
                                label: 'Tên đăng nhập',
                                placeholder: 'Nhập tên đăng nhập',
                                prefixIconData: Icons.person_outline,
                                controller: _usernameController,
                                validator: _validateUsername,
                              ),
                              SizedBox(height: 16.h),
                              CustomPasswordField(
                                label: 'Mật khẩu',
                                placeholder: 'Nhập mật khẩu',
                                prefixIcon: Icon(Icons.lock_outline),
                                controller: _passwordController,
                                validator: _validatePassword,
                              ),
                              SizedBox(height: 16.h),
                              CustomPasswordField(
                                label: 'Mật khẩu',
                                placeholder: 'Nhập mật khẩu',
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
                                    AppLocalizations.of(context)!.alreadyHaveAccount,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSubtitle,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _handleSignIn,
                                    child: Text(
                                      AppLocalizations.of(context)!.signIn,
                                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: AppColors.primaryOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                AppLocalizations.of(context)!.orConnect,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSubtitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<ButtonStateCubit, ButtonState>(
                builder: (context, state) {
                  if (state is ButtonLoadingState) {
                    FocusScope.of(context).unfocus();
                    return AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
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
