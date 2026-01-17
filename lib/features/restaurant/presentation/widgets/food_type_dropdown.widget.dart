import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';

class FoodTypeDropdown extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onChanged;
  final String label;
  final Widget? prefixIcon;

  const FoodTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
    required this.label,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final foodTypes = [
      AppLocalizations.of(context)!.foodTypeAll,
      AppLocalizations.of(context)!.foodTypeVietnamese,
      AppLocalizations.of(context)!.foodTypeAsian,
      AppLocalizations.of(context)!.foodTypeEuropean,
      AppLocalizations.of(context)!.foodTypeSeafood,
      AppLocalizations.of(context)!.foodTypeHotpot,
      AppLocalizations.of(context)!.foodTypeBBQ,
      AppLocalizations.of(context)!.foodTypeVegetarian,
      AppLocalizations.of(context)!.foodTypeKorean,
      AppLocalizations.of(context)!.foodTypeJapanese,
      AppLocalizations.of(context)!.foodTypeFastFood,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 6.h),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: selectedType,
            isExpanded: true,
            hint: Row(
              children: [
                if (prefixIcon != null) ...[
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: prefixIcon!,
                  ),
                ],
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.selectFoodType,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                ),
              ],
            ),
            items:
                foodTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
            selectedItemBuilder: (BuildContext context) {
              return foodTypes.map<Widget>((String type) {
                return Row(
                  children: [
                    if (prefixIcon != null) ...[
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: prefixIcon!,
                      ),
                    ],
                    Expanded(
                      child: Text(
                        type,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              padding: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down_sharp),
              iconSize: 24.w,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primaryWhite,
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
          ),
        ),
      ],
    );
  }
}
