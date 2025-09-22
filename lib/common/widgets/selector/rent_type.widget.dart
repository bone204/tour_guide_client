import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart'; 

enum RentType { hourly, daily }

class RentTypeSelector extends StatefulWidget {
  final Function(RentType) onChanged;
  final RentType? initialType;

  const RentTypeSelector({
    super.key,
    required this.onChanged,
    this.initialType,
  });

  @override
  State<RentTypeSelector> createState() => _RentTypeSelectorState();
}

class _RentTypeSelectorState extends State<RentTypeSelector> {
  late RentType selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialType ?? RentType.hourly;
  }

  void _select(RentType type) {
    setState(() {
      selectedType = type;
    });
    widget.onChanged(type);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOption(
            type: RentType.hourly,
            icon: AppIcons.clock,
            label: AppLocalizations.of(context)!.hourlyRent,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildOption(
            type: RentType.daily,
            icon: AppIcons.calendar,
            label: AppLocalizations.of(context)!.dailyRent,
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required RentType type,
    required String icon,
    required String label,
  }) {
    final bool isSelected = selectedType == type;

    return GestureDetector(
      onTap: () => _select(type),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.primaryGrey,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 32.w,
              height: 32.h,
              colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : AppColors.primaryBlack,
                  BlendMode.srcIn),
            ),
            SizedBox(height: 16.h),
            Text(
              label,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: isSelected ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
