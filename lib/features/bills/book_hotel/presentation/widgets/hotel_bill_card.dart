import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/utils/hotel_status_helper.dart';

class HotelBillCard extends StatelessWidget {
  final HotelBill bill;
  final VoidCallback? onTap;

  const HotelBillCard({super.key, required this.bill, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine representative image (first room's hotel photo, or some default)
    // HotelBillDetails -> room -> hotel -> images
    // Or room -> photos
    String? imageUrl;
    String title = '';

    // Prioritize cooperation info (hotel info)
    if (bill.cooperation != null) {
      title = bill.cooperation!.name;
      imageUrl = bill.cooperation!.photo;
    }

    // Fallback to room info if cooperation is missing (legacy support)
    if (title.isEmpty && bill.details.isNotEmpty) {
      final firstDetail = bill.details.first;
      title = firstDetail.roomName;
      if (bill.numberOfRooms > 1) {
        title += " (+${bill.numberOfRooms - 1} rooms)";
      }

      if (imageUrl == null || imageUrl.isEmpty) {
        if (firstDetail.room != null) {
          if (firstDetail.room!.photo != null &&
              firstDetail.room!.photo!.isNotEmpty) {
            imageUrl = firstDetail.room!.photo;
          }
        }
      }
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
                                  AppImage.defaultHotel,
                                  width: 70.w,
                                  height: 70.w,
                                  fit: BoxFit.cover,
                                ),
                          )
                          : Image.asset(
                            AppImage.defaultHotel,
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
                              title.isNotEmpty
                                  ? title
                                  : AppLocalizations.of(context)!.hotelBooking,
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
                        '${AppLocalizations.of(context)!.billCode}: ${bill.code}',
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
            // Info Row
            _buildInfoRow(
              context,
              icon: AppIcons.calendar,
              label: AppLocalizations.of(context)!.checkIn,
              value: DateFormatter.formatDateTime(bill.checkInDate),
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              icon: AppIcons.calendar,
              label: AppLocalizations.of(context)!.checkOut,
              value: DateFormatter.formatDateTime(bill.checkOutDate),
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              icon: AppIcons.hotel,
              label: AppLocalizations.of(context)!.numberOfRooms,
              value: "${bill.numberOfRooms}",
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              icon: AppIcons.clock,
              label: AppLocalizations.of(context)!.nights,
              value: "${bill.nights}",
            ),
            SizedBox(height: 12.h),
            const Divider(height: 1, color: AppColors.primaryGrey),
            SizedBox(height: 12.h),
            // Total Price
            Builder(
              builder: (context) {
                double displayTotal = bill.total;
                // Safeguard: if total is 0 but we have details, calculate from details
                if (displayTotal == 0 && bill.details.isNotEmpty) {
                  displayTotal = bill.details.fold(
                    0,
                    (sum, item) => sum + item.total,
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalPayment,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      Formatter.currency(displayTotal),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              },
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
    final (color, text) = HotelStatusHelper.getStatusColorAndText(
      context,
      bill,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
