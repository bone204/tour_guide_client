import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tour_guide_app/common_libs.dart';

class VehicleTypeSelector extends StatelessWidget {
  final String? selectedType;
  final Function(String?) onChanged;
  final String? label;

  const VehicleTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> typeLabels = {
      'car': AppLocalizations.of(context)!.car,
      'motorbike': AppLocalizations.of(context)!.motorbike,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.displayLarge),
          SizedBox(height: 8.h),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: selectedType,
              isExpanded: true,
              alignment: Alignment.centerLeft,
              iconStyleData: IconStyleData(
                icon: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Icon(Icons.arrow_drop_down_sharp),
                ),
                iconSize: 24.w,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 28,
                      spreadRadius: 2,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                elevation: 5,
                padding: EdgeInsets.zero,
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                overlayColor: MaterialStateProperty.all(
                  AppColors.secondaryGrey.withOpacity(0.1),
                ),
              ),
              hint: Text(
                AppLocalizations.of(context)!.vehicleType,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
              ),
              items:
                  ['car', 'motorbike'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        typeLabels[type] ?? type,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
