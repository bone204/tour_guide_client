import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;

  const VehicleCard({super.key, required this.vehicle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with license plate and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      vehicle.vehicleCatalog?.type == 'car'
                          ? Icons.directions_car
                          : Icons.two_wheeler,
                      color: AppColors.primaryBlue,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      vehicle.licensePlate,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                _buildStatusChip(context, vehicle.status),
              ],
            ),
            SizedBox(height: 12.h),

            // Vehicle info
            _buildInfoRow(
              context,
              label: 'Brand & Model',
              value: (() {
                final parts = [
                  vehicle.vehicleCatalog?.brand,
                  vehicle.vehicleCatalog?.model,
                ]
                    .whereType<String>()
                    .map((value) => value.trim())
                    .where((value) => value.isNotEmpty)
                    .toList();
                final composed = parts.join(' ').trim();
                return composed.isEmpty ? 'N/A' : composed;
              })(),
            ),
            SizedBox(height: 6.h),
            _buildInfoRow(
              context,
              label: 'Color',
              value: vehicle.vehicleCatalog?.color ?? 'N/A',
            ),

            // Price info
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Per Hour',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSubtitle,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${_formatPrice(vehicle.pricePerHour)} VND',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Per Day',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSubtitle,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${_formatPrice(vehicle.pricePerDay)} VND',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(
    BuildContext context,
    RentalVehicleApprovalStatus status,
  ) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status) {
      case RentalVehicleApprovalStatus.approved:
        backgroundColor = AppColors.primaryGreen;
        textColor = AppColors.textSecondary;
        displayText = 'Active';
        break;
      case RentalVehicleApprovalStatus.rejected:
        backgroundColor = AppColors.primaryRed;
        textColor = AppColors.textSecondary;
        displayText = 'Rejected';
        break;
      case RentalVehicleApprovalStatus.inactive:
        backgroundColor = AppColors.secondaryGrey;
        textColor = AppColors.textSecondary;
        displayText = 'Inactive';
        break;
      case RentalVehicleApprovalStatus.pending:
        backgroundColor = AppColors.primaryOrange;
        textColor = AppColors.textSecondary;
        displayText = 'Pending';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  String _formatPrice(double price) =>
      price == 0 ? '0' : price.toStringAsFixed(0);
}
