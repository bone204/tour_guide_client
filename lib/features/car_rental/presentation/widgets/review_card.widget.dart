import 'package:tour_guide_app/common_libs.dart';

class ReviewCard extends StatelessWidget {
  final String author;
  final int rating;
  final String text;

  const ReviewCard({
    Key? key,
    required this.author,
    required this.rating,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryGrey.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: Text(
                  author.substring(0, 1),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: Theme.of(context).textTheme.displayLarge
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 14.sp,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSubtitle,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
