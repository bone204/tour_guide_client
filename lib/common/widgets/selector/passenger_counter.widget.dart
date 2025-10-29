import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class PassengerCounter extends StatelessWidget {
  final String? label;
  final int count;
  final int min;
  final int max;
  final Function(int) onChanged;

  const PassengerCounter({
    Key? key,
    this.label,
    required this.count,
    this.min = 1,
    this.max = 10,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryGrey, width: 1.w),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SvgPicture.asset(
                  AppIcons.user,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primaryBlue,
                ),
              ),
              Expanded(
                child: Text(
                  '$count hành khách',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryBlack,
                      ),
                ),
              ),
              _buildCounterButton(
                icon: Icons.remove_rounded,
                onTap: () {
                  if (count > min) {
                    onChanged(count - 1);
                  }
                },
              ),
              SizedBox(width: 16.w),
              Text(
                '$count',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryBlue,
                    ),
              ),
              SizedBox(width: 16.w),
              _buildCounterButton(
                icon: Icons.add_rounded,
                onTap: () {
                  if (count < max) {
                    onChanged(count + 1);
                  }
                },
              ),
              SizedBox(width: 12.w),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryBlue,
          size: 18.r,
        ),
      ),
    );
  }
}

