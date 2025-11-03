import 'package:tour_guide_app/common_libs.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps * 2 - 1, (i) {
          if (i.isEven) {
            // Step circle and title
            final index = i ~/ 2;
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circle indicator
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isCurrent
                        ? AppColors.primaryBlue
                        : AppColors.primaryWhite,
                    border: Border.all(
                      color: isCompleted || isCurrent
                          ? AppColors.primaryBlue
                          : AppColors.secondaryGrey,
                      width: 2.w,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(
                            Icons.check,
                            color: AppColors.primaryWhite,
                            size: 20.sp,
                          )
                        : Text(
                            '${index + 1}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isCurrent
                                      ? AppColors.primaryWhite
                                      : AppColors.textSubtitle,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                          ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Step title
                SizedBox(
                  width: 80.w,
                  child: Text(
                    stepTitles[index],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isCompleted || isCurrent
                              ? AppColors.textPrimary
                              : AppColors.textSubtitle,
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 11.sp,
                          height: 1.3,
                        ),
                  ),
                ),
              ],
            );
          } else {
            // Line connector
            final index = i ~/ 2;
            final isCompleted = index < currentStep;

            return Container(
              width: 40.w,
              height: 2.h,
              margin: EdgeInsets.only(bottom: 45.h),
              color: isCompleted
                  ? AppColors.primaryBlue
                  : AppColors.secondaryGrey,
            );
          }
        }),
      ),
    );
  }
}

