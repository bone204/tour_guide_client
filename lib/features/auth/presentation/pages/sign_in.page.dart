import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common_libs.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 140.h, 20.w, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('Sign in now'),
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context).translate('Please sign in to continue using our app'),
                    style: TextStyle(fontSize: 16.sp, color: const Color(0xFF7D848D)),
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          hintText: AppLocalizations.of(context).translate('Email'),
                          controller: _emailController,
                        ),
                        SizedBox(height: 16.h),
                        CustomPasswordField(
                          controller: _passwordController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const ForgotPasswordPhoneScreen(),
                              //   ),
                              // );
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('Forgot Password?'),
                              style: TextStyle(fontSize: 14.sp, color: const Color(0xFFFF7029)),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF),
                            minimumSize: Size(double.infinity, 50.h),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate('Sign In'),
                            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context).translate("Don't have an account?"),
                              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF7D848D)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, AppRouteConstant.signUp);
                              },
                              child: Text(
                                AppLocalizations.of(context).translate('Sign up'),
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xFFFF7029)),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          AppLocalizations.of(context).translate('Or connect'),
                          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF7D848D)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SocialIconButton(
                  //       icon: FontAwesomeIcons.google,
                  //       label: AppLocalizations.of(context).translate('Google'),
                  //       color: const Color(0xFFDB4437),
                  //       onPressed: () async {
                  //         User? user = await loginViewModel.signInWithGoogle();
                  //         if (user != null && mounted) {
                  //           Navigator.pushReplacementNamed(context, '/home');
                  //         } else if (kDebugMode) {
                  //           print("Google login failed");
                  //         }
                  //       },
                  //     ),
                  //     SizedBox(width: 15.w),
                  //     SocialIconButton(
                  //       icon: FontAwesomeIcons.facebook,
                  //       label: AppLocalizations.of(context).translate('Facebook'),
                  //       color: const Color(0xFF4267B2),
                  //       onPressed: () async {
                  //         User? user = await loginViewModel.signInWithFacebook();
                  //         if (user != null && mounted) {
                  //           Navigator.pushReplacementNamed(context, '/home');
                  //         } else if (kDebugMode) {
                  //           print("Facebook login failed");
                  //         }
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
