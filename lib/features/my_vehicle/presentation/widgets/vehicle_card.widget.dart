import 'package:intl/intl.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle.dart';

class VehicleCard extends StatelessWidget {
  VehicleCard({super.key, required this.vehicle, this.onTap});

  final Vehicle vehicle;
  final VoidCallback? onTap;

  final NumberFormat _priceFormatter = NumberFormat('#,###', 'vi_VN');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.15),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    vehicle.vehicleCatalog?.type == 'car'
                        ? Icons.directions_car_filled
                        : Icons.two_wheeler,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.licensePlate,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _vehicleName(context),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusChip(
                      label: _statusLabel(context, vehicle.status),
                      background: _statusColor(vehicle.status),
                    ),
                    SizedBox(height: 6.h),
                    _StatusChip(
                      label: _availabilityLabel(context, vehicle.availability),
                      background: _availabilityColor(vehicle.availability),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _PriceTile(
                    label: AppLocalizations.of(context)!.pricePerHour,
                    value: _formatPrice(vehicle.pricePerHour),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _PriceTile(
                    label: AppLocalizations.of(context)!.pricePerDay,
                    value: _formatPrice(vehicle.pricePerDay),
                  ),
                ),
              ],
            ),
            if (vehicle.requirements?.isNotEmpty ?? false) ...[
              SizedBox(height: 14.h),
              Text(
                '${AppLocalizations.of(context)!.requirements}: ${vehicle.requirements}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _vehicleName(BuildContext context) {
    final parts = [
      vehicle.vehicleCatalog?.brand,
      vehicle.vehicleCatalog?.model,
    ]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
    final composed = parts.join(' ').trim();
    return composed.isEmpty ? AppLocalizations.of(context)!.rentalVehicle : composed;
  }

  String _formatPrice(double price) {
    if (price <= 0) return '—';
    return '${_priceFormatter.format(price)} đ';
  }

  String _statusLabel(BuildContext context, RentalVehicleApprovalStatus status) {
    switch (status) {
      case RentalVehicleApprovalStatus.approved:
        return AppLocalizations.of(context)!.approved;
      case RentalVehicleApprovalStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case RentalVehicleApprovalStatus.rejected:
        return AppLocalizations.of(context)!.rejected;
      case RentalVehicleApprovalStatus.inactive:
        return AppLocalizations.of(context)!.inactive;
    }
  }

  Color _statusColor(RentalVehicleApprovalStatus status) {
    switch (status) {
      case RentalVehicleApprovalStatus.approved:
        return AppColors.primaryGreen;
      case RentalVehicleApprovalStatus.pending:
        return AppColors.primaryOrange;
      case RentalVehicleApprovalStatus.rejected:
        return AppColors.primaryRed;
      case RentalVehicleApprovalStatus.inactive:
        return AppColors.primaryGrey;
    }
  }

  String _availabilityLabel(BuildContext context, RentalVehicleAvailabilityStatus status) {
    switch (status) {
      case RentalVehicleAvailabilityStatus.available:
        return AppLocalizations.of(context)!.available;
      case RentalVehicleAvailabilityStatus.rented:
        return AppLocalizations.of(context)!.rented;
      case RentalVehicleAvailabilityStatus.maintenance:
        return AppLocalizations.of(context)!.maintenance;
    }
  }

  Color _availabilityColor(RentalVehicleAvailabilityStatus status) {
    switch (status) {
      case RentalVehicleAvailabilityStatus.available:
        return AppColors.primaryBlue;
      case RentalVehicleAvailabilityStatus.rented:
        return AppColors.primaryOrange;
      case RentalVehicleAvailabilityStatus.maintenance:
        return AppColors.primaryGrey;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.background});

  final String label;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _PriceTile extends StatelessWidget {
  const _PriceTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSubtitle,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
          ),
        ],
      ),
    );
  }
}
