// ignore_for_file: library_private_types_in_public_api
import 'package:tour_guide_app/common_libs.dart';

class CustomPasswordField extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final IconData? prefixIconData;

  const CustomPasswordField({
    super.key,
    this.label,
    this.placeholder,
    required this.controller,
    this.validator,
    this.prefixIcon,
    this.prefixIconData,
  });

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Widget? styledPrefixIcon;
    if (widget.prefixIcon != null) {
      if (widget.prefixIcon is Icon) {
        final icon = widget.prefixIcon as Icon;
        styledPrefixIcon = Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Icon(
            icon.icon,
            color: icon.color ?? AppColors.primaryGrey,
            size: icon.size ?? 20.sp,
          ),
        );
      } else {
        styledPrefixIcon = widget.prefixIcon;
      }
    } else if (widget.prefixIconData != null) {
      styledPrefixIcon = Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Icon(
          widget.prefixIconData,
          color: AppColors.primaryGrey,
          size: 20.sp,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.displayLarge),
          SizedBox(height: 6.h),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          validator: widget.validator,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            errorMaxLines: 2,
            hintText: widget.placeholder,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
            filled: true,
            fillColor: AppColors.primaryWhite,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 12.w,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.secondaryGrey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primaryGrey,
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primaryRed,
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primaryRed,
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryGrey,
                size: 20.sp,
              ),
              style: ButtonStyle(splashFactory: NoSplash.splashFactory),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            prefixIcon: styledPrefixIcon,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
