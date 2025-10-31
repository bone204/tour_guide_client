import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/fast_delivery/data/models/shipping_provider.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';

class VehicleSelector extends StatelessWidget {
  final VehicleType? selectedVehicle;
  final List<VehicleType> vehicles;
  final Function(VehicleType) onSelect;

  const VehicleSelector({
    super.key,
    this.selectedVehicle,
    required this.vehicles,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loại xe',
          style: theme.displayLarge,
        ),
        SizedBox(height: 12.h),
        // Grid layout - 2 items per row
        Column(
          children: [
            for (int i = 0; i < vehicles.length; i += 2)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    // First item
                    Expanded(
                      child: _buildVehicleCard(
                        vehicle: vehicles[i],
                        isSelected: selectedVehicle?.id == vehicles[i].id,
                        onTap: () => onSelect(vehicles[i]),
                        theme: theme,
                      ),
                    ),
                    
                    // Second item (if exists)
                    if (i + 1 < vehicles.length) ...[
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildVehicleCard(
                          vehicle: vehicles[i + 1],
                          isSelected: selectedVehicle?.id == vehicles[i + 1].id,
                          onTap: () => onSelect(vehicles[i + 1]),
                          theme: theme,
                        ),
                      ),
                    ] else
                      Expanded(child: SizedBox()), // Empty space if odd number
                  ],
                ),
              ),
          ],
        ),
        if (selectedVehicle != null) ...[
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              selectedVehicle!.description,
              style: theme.displayMedium?.copyWith(
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVehicleCard({
    required VehicleType vehicle,
    required bool isSelected,
    required VoidCallback onTap,
    required TextTheme theme,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryBlue 
              : AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryBlue 
                : AppColors.secondaryGrey,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              vehicle.icon,
              style: TextStyle(fontSize: 24.sp),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vehicle.name,
                    style: theme.displayLarge?.copyWith(
                      color: isSelected 
                          ? AppColors.textSecondary 
                          : AppColors.primaryBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    Formatter.currency(vehicle.basePrice),
                    style: theme.displayMedium?.copyWith(
                      color: isSelected 
                          ? AppColors.textSecondary 
                          : AppColors.textSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

