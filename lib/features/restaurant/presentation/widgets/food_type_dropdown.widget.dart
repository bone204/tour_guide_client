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
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryGrey, width: 1.w),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: prefixIcon!,
                ),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: selectedType,
                    isExpanded: true,
                    hint: Text(
                      AppLocalizations.of(context)!.selectFoodType,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 24.h,
                      padding: EdgeInsets.zero,
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryBlack,
                      ),
                      iconSize: 24.r,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 300.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.primaryWhite,
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    items:
                        foodTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
