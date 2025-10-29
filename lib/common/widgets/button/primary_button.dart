import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double? width;
  final String? icon;

  const PrimaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryBlue,
    this.textColor = AppColors.textSecondary,
    this.borderRadius = 8.0,
    this.height = 50,
    this.width,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
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
            SvgPicture.asset(icon!, width: 20.w, height: 20.h, colorFilter: ColorFilter.mode(textColor , BlendMode.srcIn)),
            SizedBox(width: 8.w),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            )
          ),
        ],
      ),
    );
  }
}
