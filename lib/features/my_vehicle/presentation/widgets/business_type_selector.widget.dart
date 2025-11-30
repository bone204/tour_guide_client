import 'package:tour_guide_app/common_libs.dart';

class BusinessTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;
  final String? label;

  const BusinessTypeSelector({
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
                type: 'personal',
                label: AppLocalizations.of(context)!.personal,
                isSelected: selectedType == 'personal',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTypeOption(
                context: context,
                type: 'company',
                label: AppLocalizations.of(context)!.company,
                isSelected: selectedType == 'company',
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
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? AppColors.primaryWhite : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }
}

