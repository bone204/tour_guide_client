import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';

class MappingAddressDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String label;
  final String hint;
  final Function(T?) onChanged;
  final String Function(T) itemLabel;
  final bool isLoading;

  const MappingAddressDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.itemLabel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure uniqueness and value existence to prevent DropdownButton2 assertion errors
    final List<T> uniqueItems = [];
    for (final item in items) {
      if (!uniqueItems.any((element) => element == item)) {
        uniqueItems.add(item);
      }
    }

    // Find the exact object reference in uniqueItems that matches `value`
    // This is critical because DropdownButton checks for reference identity or strict equality
    T? effectiveValue;
    try {
      if (value != null) {
        effectiveValue = uniqueItems.firstWhere((element) => element == value);
      }
    } catch (_) {
      effectiveValue = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 6.h),
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            hint:
                isLoading
                    ? Shimmer.fromColors(
                      baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                      highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                      child: Container(
                        width: 120.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    )
                    : Text(
                      hint,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            items:
                uniqueItems
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          itemLabel(item),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
            value: effectiveValue,
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
              icon: const Icon(Icons.arrow_drop_down_sharp),
              iconSize: 24.w,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primaryWhite,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
          ),
        ),
      ],
    );
  }
}
