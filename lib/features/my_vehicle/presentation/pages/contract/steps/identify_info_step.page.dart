import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/image_picker_field.widget.dart';

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
  }) onNext;

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
    _idNumberController = TextEditingController(text: widget.identificationNumber);
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
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
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
              label: 'Full Name',
              placeholder: 'Enter your full name',
              controller: _fullNameController,
              validator: (value) => _validateRequired(value, 'Full name'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Email',
              placeholder: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Phone Number',
              placeholder: 'Enter your phone number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Identification Number',
              placeholder: 'Enter your ID number',
              controller: _idNumberController,
              validator: (value) => _validateRequired(value, 'Identification number'),
            ),
            SizedBox(height: 20.h),
            ImagePickerField(
              title: 'Identification Photo',
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
                'Next',
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
