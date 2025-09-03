import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/bloc/button/button_state.dart';
import 'package:tour_guide_app/common/bloc/button/button_state_cubit.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/settings/domain/usecases/logout.dart';
import 'package:tour_guide_app/features/settings/presentation/widgets/navigation_button.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void _logOut(BuildContext context) {
      context.read<ButtonStateCubit>().execute(usecase: sl<LogOutUseCase>(), params: NoParams());
    }

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ButtonStateCubit())],
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lỗi: ${state.errorMessage}")),
            );
          } else if (state is ButtonSuccessState) {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              AppRouteConstant.signIn,
              (route) => false,
            );
          }
        },
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.primaryWhite,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Account & Security",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 12.w),
                      NavigationButton(
                        leadingIcon: Icons.person,
                        title: "Personal Information",
                        trailingIcon: Icons.arrow_forward_ios,
                        onTap: () {},
                      ),
                      SizedBox(height: 12.w),
                      NavigationButton(
                        leadingIcon: Icons.key,
                        title: 'Change Password',
                        trailingIcon: Icons.arrow_forward_ios,
                        onTap: () {},
                      ),
                      SizedBox(height: 16.w),
                      Text(
                        "Settings",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 12.w),
                      NavigationButton(
                        leadingIcon: Icons.book,
                        title: 'Terms & Conditions',
                        trailingIcon: Icons.arrow_forward_ios,
                        onTap: () {},
                      ),
                      SizedBox(height: 12.w),
                      NavigationButton(
                        leadingIcon: Icons.lock,
                        title: 'Privacy Policy',
                        trailingIcon: Icons.arrow_forward_ios,
                        onTap: () {},
                      ),
                      SizedBox(height: 12.w),
                      NavigationButton(
                        leadingIcon: Icons.phone,
                        title: 'Contact Us',
                        trailingIcon: Icons.arrow_forward_ios,
                        onTap: () {},
                      ),
                      SizedBox(height: 12.w),
                      Builder(
                        builder:
                          (context) => PrimaryButton(
                            onPressed: () => _logOut(context),
                            title: AppLocalizations.of(context)!.signOut,
                            backgroundColor: AppColors.primaryGrey,
                            textColor: AppColors.textSecondary,
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
          ]
        ),
      ),
    );
  }
}
