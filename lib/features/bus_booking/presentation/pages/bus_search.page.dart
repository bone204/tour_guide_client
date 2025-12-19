import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/location_picker.dart';
import 'package:tour_guide_app/common/widgets/picker/date_picker.dart';
import 'package:tour_guide_app/common/widgets/selector/passenger_counter.widget.dart';
import 'package:tour_guide_app/common/widgets/selector/trip_type.widget.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bus_booking/presentation/pages/bus_list.page.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class BusSearchPage extends StatefulWidget {
  const BusSearchPage({Key? key}) : super(key: key);

  @override
  State<BusSearchPage> createState() => _BusSearchPageState();
}

class _BusSearchPageState extends State<BusSearchPage> {
  TripType selectedTripType = TripType.oneWay;
  String? fromLocation;
  String? toLocation;
  DateTime? selectedDate;
  DateTime? returnDate;
  int passengerCount = 1;

  void _showLocationPicker(bool isFromLocation) {
    final cities = [
      'TP. Hồ Chí Minh',
      'Hà Nội',
      'Đà Nẵng',
      'Đà Lạt',
      'Nha Trang',
      'Vũng Tàu',
      'Cần Thơ',
      'Hải Phòng',
      'Huế',
      'Quy Nhơn',
      'Buôn Ma Thuột',
      'Phan Thiết',
      'Bến Tre',
      'Mỹ Tho',
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
                  // Drag handle
                  Container(
                    margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.textSubtitle.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),

                  // Title
                  Text(
                    isFromLocation
                        ? AppLocalizations.of(context)!.selectDeparture
                        : AppLocalizations.of(context)!.selectDestination,

                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Cities List
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        return ListTile(
                          leading: Icon(
                            Icons.location_city_rounded,
                            color: AppColors.primaryBlue,
                          ),
                          title: Text(
                            city,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.r,
                            color: AppColors.textSubtitle,
                          ),
                          onTap: () {
                            setState(() {
                              if (isFromLocation) {
                                fromLocation = city;
                              } else {
                                toLocation = city;
                              }
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

  void _navigateToBusList() {
    // Validation
    if (fromLocation == null || toLocation == null || selectedDate == null) {
      _showError(AppLocalizations.of(context)!.fillAllFields);
      return;
    }

    if (selectedTripType == TripType.roundTrip && returnDate == null) {
      _showError(AppLocalizations.of(context)!.pleaseSelectReturnDate);
      return;
    }

    if (selectedTripType == TripType.roundTrip &&
        returnDate != null &&
        returnDate!.isBefore(selectedDate!)) {
      _showError(AppLocalizations.of(context)!.invalidReturnDate);
      return;
    }

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder:
            (context) => BusListPage(
              fromLocation: fromLocation!,
              toLocation: toLocation!,
              date: selectedDate!,
              passengerCount: passengerCount,
              isRoundTrip: selectedTripType == TripType.roundTrip,
              returnDate: returnDate,
            ),
      ),
    );
  }

  void _showError(String message) {
    CustomSnackbar.show(context, message: message, type: SnackbarType.error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.bookBus,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Type Selector
            TripTypeSelector(
              initialType: selectedTripType,
              onChanged: (type) {
                setState(() {
                  selectedTripType = type;
                  if (type == TripType.oneWay) {
                    returnDate = null;
                  }
                });
              },
            ),

            SizedBox(height: 24.h),

            // From Location
            LocationField(
              label: AppLocalizations.of(context)!.departurePoint,
              placeholder: AppLocalizations.of(context)!.selectDeparturePoint,
              locationText: fromLocation,
              onTap: () => _showLocationPicker(true),
              prefixIcon: SvgPicture.asset(
                AppIcons.location,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryBlue,
              ),
            ),

            SizedBox(height: 16.h),

            // To Location
            LocationField(
              label: AppLocalizations.of(context)!.arrivalPoint,
              placeholder: AppLocalizations.of(context)!.selectArrivalPoint,
              locationText: toLocation,
              onTap: () => _showLocationPicker(false),
              prefixIcon: SvgPicture.asset(
                AppIcons.location,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryRed,
              ),
            ),

            SizedBox(height: 16.h),

            // Departure Date Picker
            DatePickerField(
              label: AppLocalizations.of(context)!.departureDate,
              placeholder: AppLocalizations.of(context)!.selectDepartureDate,
              initialDate: selectedDate,
              onChanged: (date) {
                setState(() => selectedDate = date);
              },
              prefixIcon: SvgPicture.asset(
                AppIcons.calendar,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryBlue,
              ),
            ),

            // Return Date Picker (if round trip)
            if (selectedTripType == TripType.roundTrip) ...[
              SizedBox(height: 16.h),
              DatePickerField(
                label: AppLocalizations.of(context)!.returnDate,
                placeholder: AppLocalizations.of(context)!.selectReturnDate,
                initialDate: returnDate,
                onChanged: (date) {
                  setState(() => returnDate = date);
                },
                prefixIcon: SvgPicture.asset(
                  AppIcons.calendar,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primaryRed,
                ),
              ),
            ],

            SizedBox(height: 16.h),

            // Passenger Count
            PassengerCounter(
              label: AppLocalizations.of(context)!.numberOfPassengers,
              count: passengerCount,
              min: 1,
              max: 10,
              onChanged: (count) {
                setState(() => passengerCount = count);
              },
            ),

            SizedBox(height: 32.h),

            // Search Button
            PrimaryButton(
              title: AppLocalizations.of(context)!.findBus,
              onPressed: _navigateToBusList,
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
