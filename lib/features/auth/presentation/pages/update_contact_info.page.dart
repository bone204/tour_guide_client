import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_contact_info/update_contact_info_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_contact_info/update_contact_info_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tour_guide_app/common/widgets/dropdown/country_dropdown.dart';
import 'package:tour_guide_app/features/auth/data/models/country.dart';

class UpdateContactInfoPage extends StatefulWidget {
  const UpdateContactInfoPage({super.key});

  @override
  State<UpdateContactInfoPage> createState() => _UpdateContactInfoPageState();
}

class _UpdateContactInfoPageState extends State<UpdateContactInfoPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Country? _selectedCountry;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.emailInvalid;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.phoneRequired;
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.phoneInvalid;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UpdateContactInfoCubit>(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          Navigator.pushReplacementNamed(context, AppRouteConstant.signIn);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: AppLocalizations.of(context)!.updateContactInfo,
            onBackPressed:
                () => Navigator.pushReplacementNamed(
                  context,
                  AppRouteConstant.signIn,
                ),
          ),
          body: BlocConsumer<UpdateContactInfoCubit, UpdateContactInfoState>(
            listener: (context, state) {
              if (state is UpdateContactInfoSuccess) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRouteConstant.interestSelection,
                );
              }
              if (state is UpdateContactInfoFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        placeholder: AppLocalizations.of(context)!.email,
                        label: AppLocalizations.of(context)!.email,
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: _phoneController,
                        placeholder: AppLocalizations.of(context)!.phoneNumber,
                        label: AppLocalizations.of(context)!.phoneNumber,
                        validator: _validatePhone,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 20.h),
                      CountryDropdown(
                        label: AppLocalizations.of(context)!.nationality,
                        onChanged: (country) {
                          _selectedCountry = country;
                        },
                      ),
                      const Spacer(),
                      PrimaryButton(
                        title: AppLocalizations.of(context)!.update,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<UpdateContactInfoCubit>()
                                .updateContactInfo(
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  nationality:
                                      _selectedCountry?.getvietnameseName(),
                                );
                          }
                        },
                        isLoading: state is UpdateContactInfoLoading,
                        backgroundColor: AppColors.primaryBlue,
                        textColor: AppColors.primaryWhite,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
