import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/bloc/button/button_state.dart';
import 'package:tour_guide_app/common/bloc/button/button_state_cubit.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_cubit.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_state.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/dropdown/lang_dropdown.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_password_field.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_params.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/sign_in.dart';
import 'package:tour_guide_app/service_locator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormSubmitted = false;

  String? _validateIdentifier(String? value) {
    if (!_isFormSubmitted) return null;
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email hoặc tên đăng nhập';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final usernameRegex = RegExp(r'^[a-zA-Z0-9._-]{3,}$');
    if (!emailRegex.hasMatch(value) && !usernameRegex.hasMatch(value)) {
      return 'Vui lòng nhập email hoặc tên đăng nhập hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_isFormSubmitted) return null;
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    // if (value.length < 8) {
    //   return 'Mật khẩu phải có ít nhất 8 ký tự';
    // }
    return null;
  }

  void _handleSignIn(BuildContext context) async {
    setState(() {
      _isFormSubmitted = true;
    });
    _formKey.currentState!.validate();

    if (_identifierController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _validateIdentifier(_identifierController.text) == null &&
        _validatePassword(_passwordController.text) == null) {
      context.read<ButtonStateCubit>().execute(
        usecase: sl<SignInUseCase>(),
        params: SignInParams(
          username: _identifierController.text,
          password: _passwordController.text,
        ),
      );
    }
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
        create: (context) => ButtonStateCubit(),
        child: MultiBlocListener(
          listeners: [
              BlocListener<ButtonStateCubit, ButtonState>(
                listener: (context, state) {
                  if (state is ButtonSuccessState) {
                    Navigator.pushReplacementNamed(context, AppRouteConstant.mainScreen);
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
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Đóng'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
            child: GestureDetector(
              onTap: _handleTapOutside,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 140.h, 20.w, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.signInNow,
                            style: Theme.of(context).textTheme.headlineLarge
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            AppLocalizations.of(context)!.signInDescription,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Container(
                            padding: EdgeInsets.all(15.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                  label: AppLocalizations.of(context)!.usernameOrEmail,
                                  placeholder: AppLocalizations.of(context)!.enterUsernameOrEmail,
                                  prefixIconData: Icons.person_outline,
                                  controller: _identifierController,
                                  validator: _validateIdentifier,
                                ),
                                SizedBox(height: 16.h),
                                CustomPasswordField(
                                  label: AppLocalizations.of(context)!.password,
                                  placeholder: AppLocalizations.of(context)!.enterPassword,
                                  prefixIcon: Icon(Icons.lock_outline),
                                  controller: _passwordController,
                                  validator: _validatePassword,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigator.pushNamed(
                                      //   context,
                                      //   AppRouteConstant.forgotPassword,
                                      // );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.forgotPassword,
                                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: AppColors.primaryOrange,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Builder(
                                  builder: (context) {
                                    return PrimaryButton(
                                      title: AppLocalizations.of(context)!.signIn,
                                      onPressed: () => _handleSignIn(context),
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
                                      AppLocalizations.of(context)!.noAccount,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textSubtitle,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, AppRouteConstant.signUp);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.signUp,
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
                  Positioned(
                    top: 40.h,
                    right: 20.w,
                    child: LanguageDropdown(),
                  ),
                  BlocBuilder<ButtonStateCubit, ButtonState>(
                    builder: (context, state) {
                      if (state is ButtonLoadingState) {
                        FocusScope.of(context).unfocus();
                        return Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: CircularProgressIndicator(),
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
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
