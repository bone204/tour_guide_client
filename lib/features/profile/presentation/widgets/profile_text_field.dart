import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;

  const ProfileTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: CustomTextField(
        label: label,
        placeholder: '',
        controller: controller,
        suffixIcon: suffixIcon,
        validator: validator,
        readOnly: readOnly,
        // If readOnly is true, we might also want to set enabled to false or style it differently,
        // but CustomTextField handles readOnly.
        // Let's also set filled color or text style if readOnly?
        // For now, just pass readOnly.
      ),
    );
  }
}
