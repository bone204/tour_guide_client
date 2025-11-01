import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/location_picker.dart';
import 'package:tour_guide_app/common/widgets/picker/date_picker.dart';
import 'package:tour_guide_app/common/widgets/selector/passenger_counter.widget.dart';
import 'package:tour_guide_app/common/widgets/selector/trip_type.widget.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/train_booking/presentation/pages/train_list.page.dart';

class TrainSearchPage extends StatefulWidget {
  const TrainSearchPage({Key? key}) : super(key: key);

  @override
  State<TrainSearchPage> createState() => _TrainSearchPageState();
}

class _TrainSearchPageState extends State<TrainSearchPage> {
  TripType selectedTripType = TripType.oneWay;
  String? fromStation;
  String? toStation;
  DateTime? selectedDate;
  DateTime? returnDate;
  int passengerCount = 1;

  void _showStationPicker(bool isFromStation) {
    final stations = [
      'Ga Sài Gòn',
      'Ga Hà Nội',
      'Ga Đà Nẵng',
      'Ga Nha Trang',
      'Ga Huế',
      'Ga Vinh',
      'Ga Đồng Hới',
      'Ga Quảng Ngãi',
      'Ga Dĩ An',
      'Ga Biên Hòa',
      'Ga Phan Thiết',
      'Ga Ninh Bình',
      'Ga Nam Định',
      'Ga Thanh Hóa',
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
                    isFromStation ? 'Chọn ga đi' : 'Chọn ga đến',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  
                  SizedBox(height: 16.h),

                  // Stations List
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: stations.length,
                      itemBuilder: (context, index) {
                        final station = stations[index];
                        return ListTile(
                          leading: Icon(
                            Icons.train_rounded,
                            color: AppColors.primaryBlue,
                          ),
                          title: Text(
                            station,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.r,
                            color: AppColors.textSubtitle,
                          ),
                          onTap: () {
                            setState(() {
                              if (isFromStation) {
                                fromStation = station;
                              } else {
                                toStation = station;
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

  void _navigateToTrainList() {
    // Validation
    if (fromStation == null || toStation == null || selectedDate == null) {
      _showError('Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (selectedTripType == TripType.roundTrip && returnDate == null) {
      _showError('Vui lòng chọn ngày về');
      return;
    }

    if (selectedTripType == TripType.roundTrip && 
        returnDate != null && 
        returnDate!.isBefore(selectedDate!)) {
      _showError('Ngày về phải sau ngày đi');
      return;
    }

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => TrainListPage(
          fromStation: fromStation!,
          toStation: toStation!,
          date: selectedDate!,
          passengerCount: passengerCount,
          isRoundTrip: selectedTripType == TripType.roundTrip,
          returnDate: returnDate,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Đặt vé tàu hỏa',
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

            // From Station
            LocationField(
              label: 'Ga đi',
              placeholder: 'Chọn ga đi',
              locationText: fromStation,
              onTap: () => _showStationPicker(true),
              prefixIcon: SvgPicture.asset(
                AppIcons.location,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryBlue,
              ),
            ),
            
            SizedBox(height: 16.h),

            // To Station
            LocationField(
              label: 'Ga đến',
              placeholder: 'Chọn ga đến',
              locationText: toStation,
              onTap: () => _showStationPicker(false),
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
              label: 'Ngày đi',
              placeholder: 'Chọn ngày đi',
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
                label: 'Ngày về',
                placeholder: 'Chọn ngày về',
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
              label: 'Số hành khách',
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
              title: 'Tìm chuyến tàu',
              onPressed: _navigateToTrainList,
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

