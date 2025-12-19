import 'package:tour_guide_app/common_libs.dart';

class TableCard extends StatelessWidget {
  final String tableName;
  final int seats;
  final String location;
  final bool isAvailable;
  final VoidCallback? onSelect;

  const TableCard({
    super.key,
    required this.tableName,
    required this.seats,
    required this.location,
    required this.isAvailable,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAvailable ? onSelect : null,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color:
                isAvailable
                    ? AppColors.primaryBlue
                    : AppColors.primaryGrey.withOpacity(0.5),
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      tableName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isAvailable
                              ? AppColors.primaryBlue.withOpacity(0.15)
                              : AppColors.primaryGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      isAvailable
                          ? AppLocalizations.of(context)!.statusEmpty
                          : AppLocalizations.of(context)!.statusBooked,
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(
                        color:
                            isAvailable
                                ? AppColors.primaryBlue
                                : AppColors.textSubtitle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 18.r,
                    color: AppColors.primaryBlue,
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      '$seats ${AppLocalizations.of(context)!.people}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18.r,
                    color: AppColors.primaryBlue,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      location,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
