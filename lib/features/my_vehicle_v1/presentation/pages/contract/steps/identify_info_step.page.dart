import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/presentation/widgets/image_picker_field.widget.dart';

class IdentifyInfoStep extends StatefulWidget {
  final String fullName;
  final String email;
  final String phone;
  final String identificationNumber;
  final String? identificationPhoto;
  final Function({
    required String fullName,
    required String email,
    required String phone,
    required String identificationNumber,
    String? identificationPhoto,
  })
  onNext;

  const IdentifyInfoStep({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.identificationNumber,
    this.identificationPhoto,
    required this.onNext,
  });

  @override
  State<IdentifyInfoStep> createState() => _IdentifyInfoStepState();
}

class _IdentifyInfoStepState extends State<IdentifyInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _idNumberController;
  String? _idPhotoPath;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _idNumberController = TextEditingController(
      text: widget.identificationNumber,
    );
    _idPhotoPath = widget.identificationPhoto;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
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
        identificationNumber: _idNumberController.text,
        identificationPhoto: _idPhotoPath,
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
              label: AppLocalizations.of(context)!.identificationNumber,
              placeholder: AppLocalizations.of(context)!.enterIdNumber,
              controller: _idNumberController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.identificationNumber,
                  ),
            ),
            SizedBox(height: 20.h),
            ImagePickerField(
              title: AppLocalizations.of(context)!.identificationPhoto,
              imagePath: _idPhotoPath,
              onImageSelected: (path) {
                setState(() {
                  _idPhotoPath = path;
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
