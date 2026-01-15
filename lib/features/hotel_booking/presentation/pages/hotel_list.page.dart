import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/find_hotel/find_hotel_cubit.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/find_hotel/find_hotel_state.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/widgets/hotel_card.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class HotelListPage extends StatefulWidget {
  final HotelRoomSearchRequest? request;

  const HotelListPage({super.key, this.request});

  @override
  State<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  late FindHotelCubit _findHotelCubit;

  @override
  void initState() {
    super.initState();
    _findHotelCubit = sl<FindHotelCubit>();
    _fetchHotels();
  }

  void _fetchHotels() {
    final searchRequest = widget.request ?? HotelRoomSearchRequest();
    print('🔍 HotelListPage - Search Request: ${searchRequest.toJson()}');
    _findHotelCubit.findHotels(searchRequest);
  }

  @override
  void dispose() {
    _findHotelCubit.close();
    super.dispose();
  }

  void _navigateToHotelDetail(BuildContext context, Hotel hotel) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRouteConstant.hotelDetail,
      arguments: {'hotel': hotel, 'rooms': hotel.rooms},
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.primaryGrey.withOpacity(0.3),
            highlightColor: AppColors.primaryGrey.withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGrey,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGrey,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 12.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGrey,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 12.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGrey,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _findHotelCubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.hotelList,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<FindHotelCubit, FindHotelState>(
          listener: (context, state) {
            if (state is FindHotelFailure) {
              CustomSnackbar.show(
                context,
                message: state.message,
                type: SnackbarType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is FindHotelLoading) {
              return _buildShimmerLoading();
            }

            if (state is FindHotelSuccess) {
              final hotels = state.hotels;

              if (hotels.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noRoomsFound),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _fetchHotels();
                  // Wait for the cubit to emit a new state
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: MasonryGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    itemCount: hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = hotels[index];
                      // Calculate min price from rooms
                      double minPrice = 0;
                      if (hotel.rooms.isNotEmpty) {
                        minPrice = hotel.rooms
                            .map((r) => r.price)
                            .reduce((a, b) => a < b ? a : b);
                      }

                      return HotelCard(
                        name: hotel.name,
                        location: hotel.province ?? '',
                        pricePerNight: minPrice,
                        rating: hotel.averageRating,
                        imageUrl:
                            hotel.photo != null && hotel.photo!.isNotEmpty
                                ? hotel.photo!
                                : AppImage.defaultHotel,
                        onTap: () => _navigateToHotelDetail(context, hotel),
                      );
                    },
                  ),
                ),
              );
            }

            return Center(
              child: Text(AppLocalizations.of(context)!.noRoomsFound),
            );
          },
        ),
      ),
    );
  }
}
