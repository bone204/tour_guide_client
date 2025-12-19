import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final int selectedQuantity;
  final Function(int) onQuantityChanged;

  const RoomCard({
    super.key,
    required this.room,
    required this.selectedQuantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isSelected = selectedQuantity > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : AppColors.secondaryGrey,
          width: isSelected ? 2.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image header
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Stack(
              children: [
                Image.asset(
                  room.image,
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                ),
                // Available/Unavailable badge
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          room.isAvailable
                              ? AppColors.primaryGreen
                              : AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      room.isAvailable
                          ? AppLocalizations.of(context)!.statusAvailable
                          : AppLocalizations.of(context)!.statusSoldOut,
                      style: theme.displayMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                // Selected badge
                if (isSelected)
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            AppLocalizations.of(context)!.statusSelected,
                            style: theme.displayMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room name and type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(room.name, style: theme.titleMedium?.copyWith()),
                          SizedBox(height: 4.h),
                          Text(
                            room.type,
                            style: theme.displayMedium?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "${Formatter.currency(room.pricePerNight)}/đêm",
                        style: theme.displayLarge?.copyWith(
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Capacity
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.user,
                      width: 18.w,
                      height: 18.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryBlue,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Tối đa ${room.capacity} người',
                      style: theme.displayLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Amenities
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children:
                      room.amenities.take(4).map((amenity) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: AppColors.primaryBlue.withOpacity(0.2),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getAmenityIcon(amenity),
                                size: 14.sp,
                                color: AppColors.primaryBlue,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                amenity,
                                style: theme.displayMedium?.copyWith(
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),

                SizedBox(height: 16.h),

                // Divider
                Divider(
                  height: 1.h,
                  color: AppColors.secondaryGrey.withOpacity(0.5),
                ),

                SizedBox(height: 16.h),

                // Quantity selector or unavailable message
                if (room.isAvailable) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.roomQuantity,
                        style: theme.displayLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrement
                            InkWell(
                              onTap:
                                  selectedQuantity > 0
                                      ? () => onQuantityChanged(
                                        selectedQuantity - 1,
                                      )
                                      : null,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color:
                                      selectedQuantity > 0
                                          ? AppColors.primaryBlue
                                          : AppColors.secondaryGrey,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 16.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            // Count
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                selectedQuantity.toString(),
                                style: theme.titleMedium?.copyWith(
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                            // Increment
                            InkWell(
                              onTap:
                                  () => onQuantityChanged(selectedQuantity + 1),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 16.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Subtotal if selected
                  if (selectedQuantity > 0) ...[
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.subtotal}:',
                            style: theme.displayLarge?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                          ),
                          Text(
                            Formatter.currency(
                              room.pricePerNight * selectedQuantity,
                            ),
                            style: theme.titleSmall?.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.block,
                          size: 16.sp,
                          color: AppColors.primaryRed,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          AppLocalizations.of(context)!.roomNotAvailable,
                          style: theme.displayLarge?.copyWith(
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'điều hòa':
        return Icons.ac_unit;
      case 'tv':
        return Icons.tv;
      case 'minibar':
        return Icons.local_bar;
      case 'bồn tắm':
        return Icons.bathtub;
      case 'phòng khách':
        return Icons.weekend;
      case '2 giường đôi':
        return Icons.bed;
      default:
        return Icons.check_circle_outline;
    }
  }
}
