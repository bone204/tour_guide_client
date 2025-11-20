import 'package:flutter/services.dart';
import 'package:tour_guide_app/common_libs.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String placeholder;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final IconData? prefixIconData;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.label,
    required this.placeholder,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconData,
    this.keyboardType,
    this.onChanged,
    this.maxLines,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    Widget? styledPrefixIcon;
    if (prefixIcon != null) {
      if (prefixIcon is Icon) {
        final icon = prefixIcon as Icon;
        styledPrefixIcon = Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Icon(
            icon.icon,
            color: icon.color ?? AppColors.primaryGrey,
            size: icon.size ?? 20.sp,
          ),
        );
      } else {
        styledPrefixIcon = prefixIcon;
      }
    } else if (prefixIconData != null) {
      styledPrefixIcon = Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Icon(prefixIconData, color: AppColors.primaryGrey, size: 20.sp),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 6.h),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          inputFormatters: inputFormatters,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
            filled: true,
            fillColor: AppColors.primaryWhite,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondaryGrey, width: 1.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryGrey, width: 2.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryRed, width: 2.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryRed, width: 2.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: styledPrefixIcon,
            errorMaxLines: 2,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}

