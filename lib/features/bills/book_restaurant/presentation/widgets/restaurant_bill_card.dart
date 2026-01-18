import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/models/restaurant_booking.dart';

class RestaurantBillCard extends StatelessWidget {
  final RestaurantBooking booking;
  final VoidCallback? onTap;

  const RestaurantBillCard({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    String title = '';

    if (booking.cooperation != null) {
      title = booking.cooperation!.name;
      imageUrl = booking.cooperation!.photo;
    }

    if (title.isEmpty) {
      title = AppLocalizations.of(context)!.restaurantBills;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGrey.withOpacity(0.25),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header: Image + Name + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child:
                      (imageUrl != null && imageUrl.isNotEmpty)
                          ? Image.network(
                            imageUrl,
                            width: 70.w,
                            height: 70.w,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  AppImage.defaultFood, // Use defaultFood
                                  width: 70.w,
                                  height: 70.w,
                                  fit: BoxFit.cover,
                                ),
                          )
                          : Image.asset(
                            AppImage.defaultFood,
                            width: 70.w,
                            height: 70.w,
                            fit: BoxFit.cover,
                          ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _buildStatusBadge(context),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${AppLocalizations.of(context)!.bookingCode}: ${booking.code}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            const Divider(height: 1, color: AppColors.primaryGrey),
            SizedBox(height: 12.h),
            // Info Rows
            _buildInfoRow(
              context,
              icon: AppIcons.calendar,
              label: AppLocalizations.of(context)!.checkIn,
              value:
                  booking.checkInDate != null
                      ? DateFormatter.formatDateTime(booking.checkInDate!)
                      : '-',
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              icon: AppIcons.restaurant, // Or table icon
              label: AppLocalizations.of(context)!.tableInfo,
              value: booking.tables?.map((e) => e.name).join(', ') ?? '-',
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              icon: AppIcons.clock,
              label: AppLocalizations.of(context)!.duration,
              value:
                  "${booking.durationMinutes ?? 60} ${Localizations.localeOf(context).languageCode == 'vi' ? 'phút' : 'mins'}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 16.sp,
          height: 16.sp,
          color: AppColors.textSubtitle,
        ),
        SizedBox(width: 8.w),
        Text(
          "$label: ",
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppColors.textSubtitle),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    // Basic status coloring impl if helper not exists
    Color color = Colors.grey;
    String text = booking.status ?? 'UNKNOWN';

    String localizedText = text;
    switch (text) {
      case 'CONFIRMED':
        localizedText = AppLocalizations.of(context)!.statusConfirmed;
        color = Colors.green;
        break;
      case 'PENDING':
        localizedText = AppLocalizations.of(context)!.statusPending;
        color = Colors.orange;
        break;
      case 'CANCELLED':
        localizedText = AppLocalizations.of(context)!.statusCancelled;
        color = Colors.red;
        break;
      case 'COMPLETED':
        localizedText = AppLocalizations.of(context)!.statusCompleted;
        color = Colors.blue;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        localizedText,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
