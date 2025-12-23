import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/image_picker_field.widget.dart';

class CitizenInfoStep extends StatefulWidget {
  final String fullName;
  final String email;
  final String phone;
  final String citizenNumber;
  final String? citizenFrontPhoto;
  final String? citizenBackPhoto;
  final Function({
    required String fullName,
    required String email,
    required String phone,
    required String citizenNumber,
    String? citizenFrontPhoto,
    String? citizenBackPhoto,
  })
  onNext;

  const CitizenInfoStep({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.citizenNumber,
    this.citizenFrontPhoto,
    this.citizenBackPhoto,
    required this.onNext,
  });

  @override
  State<CitizenInfoStep> createState() => _CitizenInfoStepState();
}

class _CitizenInfoStepState extends State<CitizenInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _citizenNumberController;
  String? _citizenFrontPhotoPath;
  String? _citizenBackPhotoPath;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _citizenNumberController = TextEditingController(
      text: widget.citizenNumber,
    );
    _citizenFrontPhotoPath = widget.citizenFrontPhoto;
    _citizenBackPhotoPath = widget.citizenBackPhoto;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _citizenNumberController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.pleaseEnterValidEmail;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.phoneRequired;
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.pleaseEnterValidPhone;
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired(fieldName);
    }
    return null;
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      widget.onNext(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        citizenNumber: _citizenNumberController.text,
        citizenFrontPhoto: _citizenFrontPhotoPath,
        citizenBackPhoto: _citizenBackPhotoPath,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              label: AppLocalizations.of(context)!.fullName,
              placeholder: AppLocalizations.of(context)!.enterFullName,
              controller: _fullNameController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.fullName,
                  ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.email,
              placeholder: AppLocalizations.of(context)!.enterEmail,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.phoneNumber,
              placeholder: AppLocalizations.of(context)!.enterPhoneNumber,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.citizenId,
              placeholder: AppLocalizations.of(context)!.enterIdNumber,
              controller: _citizenNumberController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.citizenId,
                  ),
            ),
            SizedBox(height: 20.h),
            ImagePickerField(
              title: AppLocalizations.of(context)!.citizenFrontPhoto,
              imagePath: _citizenFrontPhotoPath,
              onImageSelected: (path) {
                setState(() {
                  _citizenFrontPhotoPath = path;
                });
              },
            ),
            SizedBox(height: 16.h),
            ImagePickerField(
              title: AppLocalizations.of(context)!.citizenBackPhoto,
              imagePath: _citizenBackPhotoPath,
              onImageSelected: (path) {
                setState(() {
                  _citizenBackPhotoPath = path;
                });
              },
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.next,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
