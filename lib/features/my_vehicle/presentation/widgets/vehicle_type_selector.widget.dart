import 'package:tour_guide_app/common_libs.dart';

class VehicleTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;
  final String? label;

  const VehicleTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 8.h),
        ],
        Row(
          children: [
            Expanded(
              child: _buildTypeOption(
                context: context,
                type: 'car',
                label: 'Car',
                icon: Icons.directions_car,
                isSelected: selectedType == 'car',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTypeOption(
                context: context,
                type: 'motorbike',
                label: 'Motorbike',
                icon: Icons.two_wheeler,
                isSelected: selectedType == 'motorbike',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption({
    required BuildContext context,
    required String type,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onChanged(type),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.secondaryGrey,
            width: 1.5.w,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryWhite : AppColors.textPrimary,
              size: 32.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? AppColors.primaryWhite : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

