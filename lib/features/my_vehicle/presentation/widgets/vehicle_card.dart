import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

class VehicleCard extends StatelessWidget {
  final RentalVehicle vehicle;
  final VoidCallback? onTap;

  const VehicleCard({super.key, required this.vehicle, this.onTap});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final locale = AppLocalizations.of(context)!;

    Color statusColor;
    String statusText;

    switch (vehicle.status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        statusText = locale.approved;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = locale.rejected;
        break;
      case 'pending':
      default:
        statusColor = Colors.orange;
        statusText = locale.pending;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, statusColor, statusText),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Divider(height: 1, color: Colors.grey[200]),
                ),
                _buildSectionTitle(
                  context,
                  locale.vehicleInfo,
                ), // Ensure locale has this or generic
                SizedBox(height: 12.h),
                _buildVehicleInfo(context),
                if (vehicle.status.toLowerCase() == 'rejected' &&
                    vehicle.rejectedReason != null) ...[
                  SizedBox(height: 16.h),
                  _buildRejectionReason(context, locale),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color statusColor,
    String statusText,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicle.licensePlate, // Use license plate as title
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primaryBlue,
              ),
            ),
            if (vehicle.createdAt.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                _formatDate(vehicle.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: statusColor.withOpacity(0.2)),
          ),
          child: Text(
            statusText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(
        context,
      ).textTheme.displayLarge?.copyWith(color: AppColors.primaryGreen),
    );
  }

  Widget _buildVehicleInfo(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Using Money icons or similar
        _buildInfoRow(
          context,
          AppIcons.calendar,
          '${vehicle.pricePerDay} / ${locale.day}',
        ),
        SizedBox(height: 6.h),
        _buildInfoRow(
          context,
          AppIcons.star,
          '${vehicle.averageRating} (${vehicle.totalRentals} ${locale.rentalCount})',
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            icon,
            width: 14.sp,
            height: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.displayLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRejectionReason(BuildContext context, AppLocalizations locale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16.sp, color: Colors.red[700]),
              SizedBox(width: 8.w),
              Text(
                locale.rejected,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.red[700]),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            vehicle.rejectedReason ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.red[900]),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty) return '';
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }
}
