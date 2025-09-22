import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/bloc/button/button_state.dart';
import 'package:tour_guide_app/common/bloc/button/button_state_cubit.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/loading/dialog_loading.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/settings/domain/usecases/logout.dart';
import 'package:tour_guide_app/features/settings/presentation/widgets/navigation_button.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void logOut(BuildContext context) {
      context.read<ButtonStateCubit>().execute(
            usecase: sl<LogOutUseCase>(),
            params: NoParams(),
          );
    }

    void openLanguageScreen(BuildContext context) {
      Navigator.of(context, rootNavigator: true).pushNamed(AppRouteConstant.language);
    }

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ButtonStateCubit())],
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonLoadingState) {
            FocusScope.of(context).unfocus();
            LoadingDialog.show(context);
          } else {
            LoadingDialog.hide(context);
          }

          if (state is ButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lỗi: ${state.errorMessage}")),
            );
          } else if (state is ButtonSuccessState) {
            Navigator.of(context, rootNavigator: true)
                .pushNamedAndRemoveUntil(AppRouteConstant.signIn, (route) => false);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primaryWhite,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.accountAndSecurity,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12.w),
                  NavigationButton(
                    icon: AppIcons.user,
                    title: AppLocalizations.of(context)!.personalInfo,
                    trailingIcon: AppIcons.arrowRight,
                    onTap: () {},
                  ),
                  SizedBox(height: 12.w),
                  NavigationButton(
                    icon: AppIcons.userActive,
                    title: AppLocalizations.of(context)!.accountInfo,
                    trailingIcon: AppIcons.arrowRight,
                    onTap: () {},
                  ),
                  SizedBox(height: 12.w),
                  NavigationButton(
                    icon: AppIcons.lock,
                    title: AppLocalizations.of(context)!.changePassword,
                    trailingIcon: AppIcons.arrowRight,
                    onTap: () {},
                  ),
                  SizedBox(height: 16.w),
                  Text(
                    AppLocalizations.of(context)!.settings,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12.w),
                  NavigationButton(
                    icon: AppIcons.language,
                    title: AppLocalizations.of(context)!.language,
                    trailingIcon: AppIcons.arrowRight,
                    onTap: () => openLanguageScreen(context),
                  ),
                  SizedBox(height: 12.w),
                  NavigationButton(
                    icon: AppIcons.term,
                    title: AppLocalizations.of(context)!.terms,
                    trailingIcon: AppIcons.arrowRight,
                    onTap: () {},
                  ),
                  SizedBox(height: 12.w),
                  NavigationButton(
                    icon: AppIcons.policy,
                    title: AppLocalizations.of(context)!.policy,
                    trailingIcon: AppIcons.arrowRight,
                    onTap: () {},
                  ),
                  SizedBox(height: 12.w),
                  NavigationButton(
                    icon: AppIcons.contact,
                    title: AppLocalizations.of(context)!.contact,
                    trailingIcon: AppIcons.arrowRight,
                    onTap: () {},
                  ),
                  SizedBox(height: 12.w),
                  Builder(
                    builder: (context) => PrimaryButton(
                      onPressed: () => logOut(context),
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
      ),
    );
  }
}
