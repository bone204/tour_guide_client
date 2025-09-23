import 'package:tour_guide_app/common_libs.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double? width;
  final IconData? icon;

  const SecondaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.borderColor = AppColors.primaryBlue,
    this.textColor = AppColors.primaryBlue,
    this.borderRadius = 8.0,
    this.height = 50,
    this.width,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 1.5),
        minimumSize: Size(width ?? double.infinity, height.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 20.sp),
            SizedBox(width: 8.w),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }
}
