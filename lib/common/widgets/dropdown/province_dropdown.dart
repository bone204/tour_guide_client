import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';

class ProvinceDropdown extends StatelessWidget {
  final List<Province> provinces;
  final Province? selectedProvince;
  final bool isLoading;
  final ValueChanged<Province?> onChanged;

  const ProvinceDropdown({
    super.key,
    required this.provinces,
    required this.selectedProvince,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.province,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<Province>(
              isExpanded: true,
              value: selectedProvince,
              hint: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.location,
                    width: 20.w,
                    height: 20.h,
                    color: AppColors.primaryBlack,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    isLoading
                        ? AppLocalizations.of(context)!.loading
                        : AppLocalizations.of(context)!.selectPickupLocation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                ],
              ),
              items:
                  provinces.map((Province province) {
                    return DropdownMenuItem<Province>(
                      value: province,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.location,
                            width: 20.w,
                            height: 20.h,
                            color: AppColors.primaryBlack,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            province.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.primaryBlack),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.only(right: 12.w),
                height: 48.h,
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.arrow_drop_down_sharp),
                iconSize: 24.w,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                maxHeight: 300.h,
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
