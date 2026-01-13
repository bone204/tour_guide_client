import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/features/settings/presentation/bloc/change_password/change_password_cubit.dart';
import 'package:tour_guide_app/features/settings/presentation/bloc/change_password/change_password_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onChangePasswordPressed(BuildContext context) {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.passwordMismatch)),
      );
      return;
    }

    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      // Optionally handle empty fields if not handled by form validation or cubit
      return;
    }

    context.read<ChangePasswordCubit>().changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChangePasswordCubit>(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: CustomAppBar(
            title: AppLocalizations.of(context)!.changePassword,
            onBackPressed: () => Navigator.pop(context),
          ),
          body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                Navigator.of(context).pop();
              } else if (state is ChangePasswordFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _currentPasswordController,
                      label: AppLocalizations.of(context)!.currentPassword,
                      obscureText: true,
                      placeholder: AppLocalizations.of(context)!.enterPassword,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _newPasswordController,
                      label: AppLocalizations.of(context)!.newPassword,
                      obscureText: true,
                      placeholder: AppLocalizations.of(context)!.enterPassword,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: AppLocalizations.of(context)!.confirmPassword,
                      obscureText: true,
                      placeholder:
                          AppLocalizations.of(context)!.enterConfirmPassword,
                    ),
                    SizedBox(height: 32.h),
                    PrimaryButton(
                      title: AppLocalizations.of(context)!.changePassword,
                      onPressed: () => _onChangePasswordPressed(context),
                      isLoading: state is ChangePasswordLoading,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
