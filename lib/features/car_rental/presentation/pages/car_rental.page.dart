import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_guide_app/common/pages/location_map.page.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/date_and_hour_picker.dart';
import 'package:tour_guide_app/common/widgets/slider/price_range_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/selector/rent_type.widget.dart';
import 'package:tour_guide_app/features/car_rental/data/models/car_search_request.dart';

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

  LatLng? _selectedLocation;
  String _address = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LocationMapPage(initialLocation: _selectedLocation),
      ),
    );

    if (result != null && result is Map) {
      setState(() {
        _selectedLocation = LatLng(result['lat'], result['lng']);
        _address = result['address'];
      });
    }
  }

  void _navigateToCarListPage(BuildContext context) {
    if (_selectedLocation == null) {
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

    final request = CarSearchRequest(
      rentalType:
          selectedRentType == RentType.hourly
              ? RentalType.hourly
              : RentalType.daily,
      vehicleType: 'car',
      minPrice: selectedRange.start.toInt(),
      maxPrice: selectedRange.end.toInt(),
      startDate: startDateTime,
      endDate: endDateTime,
      latitude: _selectedLocation?.latitude,
      longitude: _selectedLocation?.longitude,
    );

    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRouteConstant.carList,
      arguments: {
        'request': request,
        'locationAddress': _address,
        'latitude': _selectedLocation?.latitude,
        'longitude': _selectedLocation?.longitude,
      },
    );
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.rentalLocation,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickLocation,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Map Preview
                        SizedBox(
                          height: 150.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.r),
                            ),
                            child:
                                _selectedLocation == null
                                    ? Container(
                                      color: Colors.grey.shade100,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.map_outlined,
                                              size: 32.sp,
                                              color: AppColors.primaryBlue,
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.tapToSelectLocation,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                color: AppColors.primaryBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : IgnorePointer(
                                      child: FlutterMap(
                                        options: MapOptions(
                                          initialCenter: _selectedLocation!,
                                          initialZoom: 15.0,
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          ),
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: _selectedLocation!,
                                                width: 30,
                                                height: 30,
                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                        ),
                        // Address Text
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _address.isEmpty
                                      ? AppLocalizations.of(
                                        context,
                                      )!.enterPickupLocation
                                      : _address,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color:
                                        _address.isEmpty
                                            ? Colors.grey.shade400
                                            : AppColors.primaryBlack,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14.sp,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
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
              onPressed: () => _navigateToCarListPage(context),
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
