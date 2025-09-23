import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/date_and_hour_picker.dart';
import 'package:tour_guide_app/common/widgets/picker/hour_picker.dart';
import 'package:tour_guide_app/common/widgets/picker/location_picker.dart';
import 'package:tour_guide_app/common/widgets/slider/price_range_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/selector/rent_type.widget.dart';

class CarRentalPage extends StatefulWidget {
  CarRentalPage({Key? key}) : super(key: key);

  @override
  State<CarRentalPage> createState() => _CarRentalPageState();
}

class _CarRentalPageState extends State<CarRentalPage> {
  RangeValues selectedRange = const RangeValues(10000, 5000000);
  RentType selectedRentType = RentType.hourly;

  DateTime? startDateTime;
  DateTime? endDateTime;

  TimeOfDay? startHour;
  TimeOfDay? endHour;

  String? pickupLocation;

  void _navigateToCarListPage(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.carList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.carRental,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RentTypeSelector(
              initialType: selectedRentType,
              onChanged: (type) {
                setState(() => selectedRentType = type);
                debugPrint('Selected rent type: $type');
              },
            ),
            SizedBox(height: 24.h),
            PriceRangeSlider(
              min: 10000,
              max: 10000000,
              start: selectedRange.start,
              end: selectedRange.end,
              onChanged: (range) {
                setState(() => selectedRange = range);
                debugPrint('Selected range: ${range.start} - ${range.end}');
              },
            ),
            SizedBox(height: 24.h),
            if (selectedRentType == RentType.daily) ...[
              DateHourPickerField(
                label: AppLocalizations.of(context)!.startDate,
                placeholder: AppLocalizations.of(context)!.selectDateAndHour,
                initialDateTime: startDateTime,
                onChanged: (dateTime) {
                  setState(() => startDateTime = dateTime);
                  debugPrint('Selected startDateTime: $dateTime');
                },
                prefixIcon: SvgPicture.asset(
                  AppIcons.calendar,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primaryBlack,
                ),
              ),
              SizedBox(height: 16.h),
              DateHourPickerField(
                label: AppLocalizations.of(context)!.endDate,
                placeholder: AppLocalizations.of(context)!.selectDateAndHour,
                initialDateTime: endDateTime,
                onChanged: (dateTime) {
                  setState(() => endDateTime = dateTime);
                  debugPrint('Selected endDateTime: $dateTime');
                },
                prefixIcon: SvgPicture.asset(
                  AppIcons.calendar,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primaryBlack,
                ),
              ),
            ] else if (selectedRentType == RentType.hourly) ...[
              HourPickerField(
                label: AppLocalizations.of(context)!.startHour,
                placeholder: AppLocalizations.of(context)!.selectHour,
                initialTime: startHour,
                onChanged: (time) {
                  setState(() => startHour = time);
                  debugPrint('Selected startHour: $time');
                },
                prefixIcon: SvgPicture.asset(
                  AppIcons.clock,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primaryBlack,
                ),
              ),
              SizedBox(height: 16.h),
              HourPickerField(
                label: AppLocalizations.of(context)!.endHour,
                placeholder: AppLocalizations.of(context)!.selectHour,
                initialTime: endHour,
                onChanged: (time) {
                  setState(() => endHour = time);
                  debugPrint('Selected endHour: $time');
                },
                prefixIcon: SvgPicture.asset(
                  AppIcons.clock,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primaryBlack,
                ),
              ),
            ],

            SizedBox(height: 16.h),
            LocationField(
              label: AppLocalizations.of(context)!.pickupLocation,
              placeholder: AppLocalizations.of(context)!.selectPickupLocation,
              locationText: pickupLocation,
            ),
            SizedBox(height: 32.h),
            PrimaryButton(
              title: AppLocalizations.of(context)!.rent,
              onPressed: () => _navigateToCarListPage(context),
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textSecondary,
            )
          ],
        ),
      ),
    );
  }
}



