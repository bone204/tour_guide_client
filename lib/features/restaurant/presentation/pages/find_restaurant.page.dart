import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/date_and_hour_picker.dart';
import 'package:tour_guide_app/common/widgets/picker/location_picker.dart';
import 'package:tour_guide_app/common/widgets/slider/price_range_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/food_type_dropdown.widget.dart';

class FindRestaurantPage extends StatefulWidget {
  const FindRestaurantPage({Key? key}) : super(key: key);

  @override
  State<FindRestaurantPage> createState() => _FindRestaurantPageState();
}

class _FindRestaurantPageState extends State<FindRestaurantPage> {
  RangeValues selectedRange = const RangeValues(50000, 500000);
  DateTime? checkInDateTime;
  String? selectedFoodType;
  String? selectedLocation;

  void _showLocationPicker() {
    final locations = [
      'Quận 1',
      'Quận 2',
      'Quận 3',
      'Quận 4',
      'Quận 5',
      'Quận 7',
      'Quận 10',
      'Thủ Đức',
      'Bình Thạnh',
      'Phú Nhuận',
      'Tân Bình',
      'Gò Vấp',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.textSubtitle.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  Text(
                    'Chọn vị trí',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        return ListTile(
                          leading: Icon(
                            Icons.location_city_rounded,
                            color: AppColors.primaryBlue,
                          ),
                          title: Text(
                            location,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.r,
                            color: AppColors.textSubtitle,
                          ),
                          onTap: () {
                            setState(() {
                              selectedLocation = location;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToRestaurantList(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.restaurantList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tìm nhà hàng',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PriceRangeSlider(
              min: 50000,
              max: 1000000,
              start: selectedRange.start,
              end: selectedRange.end,
              onChanged: (range) {
                setState(() => selectedRange = range);
                debugPrint('Selected range: ${range.start} - ${range.end}');
              },
            ),
            SizedBox(height: 24.h),
            DateHourPickerField(
              label: 'Thời gian đặt bàn',
              placeholder: 'Chọn ngày và giờ',
              initialDateTime: checkInDateTime,
              onChanged: (dateTime) {
                setState(() => checkInDateTime = dateTime);
                debugPrint('Selected check-in time: $dateTime');
              },
              prefixIcon: SvgPicture.asset(
                AppIcons.calendar,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryBlack,
              ),
            ),
            SizedBox(height: 16.h),
            FoodTypeDropdown(
              label: 'Loại đồ ăn',
              selectedType: selectedFoodType,
              onChanged: (type) {
                setState(() => selectedFoodType = type);
                debugPrint('Selected food type: $type');
              },
              prefixIcon: SvgPicture.asset(
                AppIcons.foodType,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryBlack,
              ),
            ),
            SizedBox(height: 16.h),
            LocationField(
              label: 'Vị trí',
              placeholder: 'Chọn vị trí',
              locationText: selectedLocation,
              onTap: _showLocationPicker,
              prefixIcon: SvgPicture.asset(
                AppIcons.location,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 32.h),
            PrimaryButton(
              title: 'Tìm kiếm',
              onPressed: () => _navigateToRestaurantList(context),
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textSecondary,
            )
          ],
        ),
      ),
    );
  }
}

