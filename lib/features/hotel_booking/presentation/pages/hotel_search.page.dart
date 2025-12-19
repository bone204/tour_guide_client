import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/date_picker.dart';
import 'package:tour_guide_app/common/widgets/picker/location_picker.dart';
import 'package:tour_guide_app/common/widgets/slider/price_range_slider.dart';
import 'package:tour_guide_app/common_libs.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  RangeValues selectedRange = const RangeValues(500000, 5000000);
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int numberOfRooms = 1;
  int numberOfGuests = 2;
  String? selectedLocation;

  void _showLocationPicker() {
    final locations = [
      'Quận 1',
      'Quận 2',
      'Quận 3',
      'Quận 7',
      'Thủ Đức',
      'Bình Thạnh',
      'Phú Nhuận',
      'Tân Bình',
      'Vũng Tàu',
      'Đà Lạt',
      'Nha Trang',
      'Phú Quốc',
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
                    AppLocalizations.of(context)!.selectLocation,
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

  void _navigateToHotelList(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.hotelList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.findHotel,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price range
            PriceRangeSlider(
              min: 500000,
              max: 10000000,
              start: selectedRange.start,
              end: selectedRange.end,
              onChanged: (range) {
                setState(() => selectedRange = range);
              },
            ),

            SizedBox(height: 24.h),

            // Check-in date
            DatePickerField(
              label: AppLocalizations.of(context)!.checkInDate,
              placeholder: AppLocalizations.of(context)!.selectCheckInDate,
              initialDate: checkInDate,
              onChanged: (date) {
                setState(() => checkInDate = date);
              },
              prefixIcon: SvgPicture.asset(
                AppIcons.calendar,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryBlack,
                  BlendMode.srcIn,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Check-out date
            DatePickerField(
              label: AppLocalizations.of(context)!.checkOutDate,
              placeholder: AppLocalizations.of(context)!.selectCheckOutDate,
              initialDate: checkOutDate,
              onChanged: (date) {
                setState(() => checkOutDate = date);
              },
              prefixIcon: SvgPicture.asset(
                AppIcons.calendar,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryBlack,
                  BlendMode.srcIn,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Number of rooms
            _buildCounterField(
              AppLocalizations.of(context)!.numberOfRooms,
              numberOfRooms,
              () => setState(() => numberOfRooms++),
              () => setState(() {
                if (numberOfRooms > 1) numberOfRooms--;
              }),
            ),

            SizedBox(height: 16.h),

            // Number of guests
            _buildCounterField(
              AppLocalizations.of(context)!.numberOfGuests,
              numberOfGuests,
              () => setState(() => numberOfGuests++),
              () => setState(() {
                if (numberOfGuests > 1) numberOfGuests--;
              }),
            ),

            SizedBox(height: 16.h),

            // Location
            LocationField(
              label: AppLocalizations.of(context)!.location,
              placeholder: AppLocalizations.of(context)!.selectPlace,
              locationText: selectedLocation,
              onTap: _showLocationPicker,
              prefixIcon: SvgPicture.asset(
                AppIcons.location,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryBlue,
                  BlendMode.srcIn,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Search button
            PrimaryButton(
              title: AppLocalizations.of(context)!.searchButton,
              onPressed: () => _navigateToHotelList(context),
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterField(
    String label,
    int count,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Row(
                children: [
                  InkWell(
                    onTap: onDecrement,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 18.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      count.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onIncrement,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
