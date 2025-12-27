import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/date_and_hour_picker.dart';
import 'package:tour_guide_app/common/widgets/slider/price_range_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/selector/rent_type.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_provinces.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/motorbike_search_request.dart';
import 'package:tour_guide_app/service_locator.dart';

class MotorbikeRentalPage extends StatefulWidget {
  MotorbikeRentalPage({Key? key}) : super(key: key);

  @override
  State<MotorbikeRentalPage> createState() => _MotorbikeRentalPageState();
}

class _MotorbikeRentalPageState extends State<MotorbikeRentalPage> {
  RangeValues selectedRange = const RangeValues(10000, 5000000);
  RentType selectedRentType = RentType.hourly;

  DateTime? startDateTime;
  DateTime? endDateTime;

  String? pickupLocation;
  List<Province> provinces = [];
  Province? selectedProvince;
  bool isLoadingProvinces = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    setState(() => isLoadingProvinces = true);
    final result = await sl<GetProvincesUseCase>().call(null);
    if (mounted) {
      result.fold(
        (failure) => debugPrint('Error loading provinces: ${failure.message}'),
        (response) {
          setState(() {
            provinces = response.items;
            isLoadingProvinces = false;
          });
        },
      );
    }
  }

  void _navigateToMotorbikeListPage(BuildContext context) {
    if (selectedProvince == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectPickupLocation),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    if (startDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectStartDate),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    if (endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectEndDate),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    if (endDateTime!.isBefore(startDateTime!) ||
        endDateTime!.isAtSameMomentAs(startDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.endDateMustBeAfterStartDate,
          ),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    final request = MotorbikeSearchRequest(
      rentalType:
          selectedRentType == RentType.hourly
              ? RentalType.hourly
              : RentalType.daily,
      vehicleType: 'bike',
      minPrice: selectedRange.start.toInt(),
      maxPrice: selectedRange.end.toInt(),
      startDate: startDateTime,
      endDate: endDateTime,
      province: selectedProvince?.name,
    );

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.motorbikeList, arguments: request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.bikeRental,
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.pickupLocation,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.primaryGrey,
                      width: 1.w,
                    ),
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
                            isLoadingProvinces
                                ? 'Loading...'
                                : AppLocalizations.of(
                                  context,
                                )!.selectPickupLocation,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSubtitle),
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryBlack,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                      onChanged: (Province? newValue) {
                        setState(() {
                          selectedProvince = newValue;
                        });
                      },
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
            ),
            SizedBox(height: 16.h),
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

            SizedBox(height: 32.h),
            PrimaryButton(
              title: AppLocalizations.of(context)!.findVehicle,
              onPressed: () => _navigateToMotorbikeListPage(context),
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
