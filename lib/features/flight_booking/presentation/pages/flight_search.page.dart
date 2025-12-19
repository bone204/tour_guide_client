import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/location_picker.dart';
import 'package:tour_guide_app/common/widgets/picker/date_picker.dart';
import 'package:tour_guide_app/common/widgets/selector/passenger_counter.widget.dart';
import 'package:tour_guide_app/common/widgets/selector/trip_type.widget.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/flight_booking/presentation/pages/flight_list.page.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class FlightSearchPage extends StatefulWidget {
  const FlightSearchPage({Key? key}) : super(key: key);

  @override
  State<FlightSearchPage> createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  TripType selectedTripType = TripType.oneWay;
  String? fromAirport;
  String? toAirport;
  DateTime? selectedDate;
  DateTime? returnDate;
  int passengerCount = 1;

  void _showAirportPicker(bool isFromAirport) {
    final airports = [
      {
        'name': 'Sân bay Tân Sơn Nhất',
        'code': 'SGN',
        'city': 'TP. Hồ Chí Minh',
      },
      {'name': 'Sân bay Nội Bài', 'code': 'HAN', 'city': 'Hà Nội'},
      {'name': 'Sân bay Đà Nẵng', 'code': 'DAD', 'city': 'Đà Nẵng'},
      {'name': 'Sân bay Cam Ranh', 'code': 'CXR', 'city': 'Nha Trang'},
      {'name': 'Sân bay Phú Bài', 'code': 'HUI', 'city': 'Huế'},
      {'name': 'Sân bay Phú Quốc', 'code': 'PQC', 'city': 'Phú Quốc'},
      {'name': 'Sân bay Cát Bi', 'code': 'HPH', 'city': 'Hải Phòng'},
      {'name': 'Sân bay Liên Khương', 'code': 'DLI', 'city': 'Đà Lạt'},
      {'name': 'Sân bay Vinh', 'code': 'VII', 'city': 'Vinh'},
      {'name': 'Sân bay Pleiku', 'code': 'PXU', 'city': 'Pleiku'},
      {'name': 'Sân bay Buôn Ma Thuột', 'code': 'BMV', 'city': 'Buôn Ma Thuột'},
      {'name': 'Sân bay Cần Thơ', 'code': 'VCA', 'city': 'Cần Thơ'},
      {'name': 'Sân bay Côn Đảo', 'code': 'VCS', 'city': 'Côn Đảo'},
      {'name': 'Sân bay Rạch Giá', 'code': 'VKG', 'city': 'Rạch Giá'},
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
                    isFromAirport ? 'Chọn sân bay đi' : 'Chọn sân bay đến',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Airports List
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: airports.length,
                      itemBuilder: (context, index) {
                        final airport = airports[index];
                        return ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.flight_takeoff_rounded,
                              color: AppColors.primaryBlue,
                              size: 24.r,
                            ),
                          ),
                          title: Text(
                            '${airport['city']} (${airport['code']})',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          subtitle: Text(
                            airport['name']!,
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(color: AppColors.textSubtitle),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.r,
                            color: AppColors.textSubtitle,
                          ),
                          onTap: () {
                            setState(() {
                              if (isFromAirport) {
                                fromAirport =
                                    '${airport['city']} (${airport['code']})';
                              } else {
                                toAirport =
                                    '${airport['city']} (${airport['code']})';
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

  void _navigateToFlightList() {
    // Validation
    if (fromAirport == null || toAirport == null || selectedDate == null) {
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
            (context) => FlightListPage(
              fromAirport: fromAirport!,
              toAirport: toAirport!,
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
        title: AppLocalizations.of(context)!.bookFlight,
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

            // From Airport
            LocationField(
              label: AppLocalizations.of(context)!.departureAirport,
              placeholder: AppLocalizations.of(context)!.selectDepartureAirport,
              locationText: fromAirport,
              onTap: () => _showAirportPicker(true),
              prefixIcon: SvgPicture.asset(
                AppIcons.location,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryBlue,
              ),
            ),

            SizedBox(height: 16.h),

            // To Airport
            LocationField(
              label: AppLocalizations.of(context)!.arrivalAirport,
              placeholder: AppLocalizations.of(context)!.selectArrivalAirport,
              locationText: toAirport,
              onTap: () => _showAirportPicker(false),
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
              max: 9,
              onChanged: (count) {
                setState(() => passengerCount = count);
              },
            ),

            SizedBox(height: 32.h),

            // Search Button
            PrimaryButton(
              title: AppLocalizations.of(context)!.findFlight,
              onPressed: _navigateToFlightList,
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
