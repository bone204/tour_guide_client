import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common_libs.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812)); 
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 90.h, 20.w, 0), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('Sign up now'), 
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26.sp), 
                ),
                SizedBox(height: 15.h), 
                Text(
                  AppLocalizations.of(context).translate('Please fill the details and create account'), 
                  style: TextStyle(fontSize: 16.sp, color: const Color(0xFF7D848D)), 
                ),
                SizedBox(height: 40.h), 
                Container(
                  padding: EdgeInsets.all(16.w), 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        hintText: AppLocalizations.of(context).translate('Username'), 
                        controller: _usernameController,
                      ),
                      SizedBox(height: 16.h), 
                      CustomTextField(
                        hintText: AppLocalizations.of(context).translate('Email'), 
                        controller: _emailController,
                      ),
                      SizedBox(height: 16.h), 
                      CustomPasswordField(
                        controller: _passwordController,
                      ),
                      SizedBox(height: 16.h), 
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context).translate("Password must be at least 8 characters long"), 
                          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF7D848D)), 
                        ),
                      ),
                      SizedBox(height: 40.h), 
                      ElevatedButton(
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          minimumSize: Size(double.infinity, 50.h), 
                          padding: EdgeInsets.symmetric(vertical: 16.h), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r), 
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate('Sign Up'), 
                          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16.sp), 
                        ),
                      ),
                      SizedBox(height: 40.h), 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("Already have an account?"), 
                            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF7D848D)), 
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, AppRouteConstant.signIn);
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('Sign in'), 
                              style: TextStyle(fontSize: 14.sp, color: const Color(0xFFFF7029), fontWeight: FontWeight.w700), 
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
                //         User? user = await signupViewModel.signInWithGoogle();
                //         if (user != null) {
                //           Navigator.pushNamed(context, "/home");
                //         } else {
                //           if (kDebugMode) {
                //             print("Google sign-up failed");
                //           }
                //         }
                //       },
                //     ),
                //     SizedBox(width: 15.w), 
                //     SocialIconButton(
                //       icon: FontAwesomeIcons.facebook,
                //       label: AppLocalizations.of(context).translate('Facebook'),
                //       color: const Color(0xFF4267B2),
                //       onPressed: () async {
                //         User? user = await signupViewModel.signInWithFacebook();
                //         if (user != null) {
                //           Navigator.pushNamed(context, "/home");
                //         } else {
                //           if (kDebugMode) {
                //             print("Facebook sign-up failed");
                //           }
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
    );
  }
}
