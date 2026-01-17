import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_guide_app/common/pages/location_map.page.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/date_picker.dart';
import 'package:tour_guide_app/common/widgets/slider/price_range_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  RangeValues selectedRange = const RangeValues(500000, 5000000);
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int numberOfGuests =
      2; // Default guests changed to match commonly used default

  LatLng? _selectedLocation;
  String _address = '';

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

  void _navigateToHotelList(BuildContext context) {
    // Basic validation could be added here if needed, but for search often parameters are optional.
    // However, if location is mandatory for "searching nearby", we can enforce it.
    // The user request implied replacing the old location picker which was just a list of strings.

    final request = HotelRoomSearchRequest(
      latitude: _selectedLocation?.latitude,
      longitude: _selectedLocation?.longitude,
      checkInDate: checkInDate?.toIso8601String(),
      checkOutDate: checkOutDate?.toIso8601String(),
      guests: numberOfGuests,
      minPrice: selectedRange.start,
      maxPrice: selectedRange.end,
    );

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.hotelList, arguments: request);
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.location,
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
                                      )!.selectLocation
                                      : _address,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color:
                                        _address.isEmpty
                                            ? Colors.grey.shade400
                                            : AppColors.primaryBlack,
                                  ),
                                  maxLines: 5,
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

            // Number of guests
            _buildCounterField(
              AppLocalizations.of(context)!.numberOfGuests,
              numberOfGuests,
              () => setState(() => numberOfGuests++),
              () => setState(() {
                if (numberOfGuests > 1) numberOfGuests--;
              }),
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
