// ignore_for_file: deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/shimmer_widgets.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/hotel_rooms_search/hotel_rooms_search_cubit.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/hotel_rooms_search/hotel_rooms_search_state.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/pages/hotel_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/home_hotel_card.widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SliverHotelNearbyDestinationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelRoomsSearchCubit, HotelRoomsSearchState>(
      builder: (context, state) {
        // Show shimmer when loading
        if (state is HotelRoomsSearchLoading ||
            state is HotelRoomsSearchInitial) {
          return SliverHotelNearbyDestinationListShimmer();
        }

        // Hide on error or when no hotels found
        if (state is! HotelRoomsSearchSuccess || state.hotels.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final hotels = state.hotels;

        return SliverToBoxAdapter(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryPurple,
                      AppColors.primaryPurple.withOpacity(0.6),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -24,
                      right: 0,
                      child: Image.asset(
                        AppImage.cloud,
                        width: 100.w,
                        height: 100.h,
                      ),
                    ),
                    // 🔹 Nội dung
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            bottom: 20.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.hotelNearby,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                AppLocalizations.of(context)!.hotelNearbyDes,
                                style: Theme.of(context).textTheme.displayMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        // Carousel Hotel Cards
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: CarouselSlider.builder(
                            itemCount: hotels.length,
                            itemBuilder: (context, index, realIndex) {
                              final hotel = hotels[index];

                              return HomeHotelCard(
                                hotel: hotel,
                                onTap: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              HotelDetailPage.withProvider(
                                                hotel: hotel,
                                              ),
                                    ),
                                  );
                                },
                              );
                            },
                            options: CarouselOptions(
                              height: 300.h,
                              padEnds: false,
                              autoPlay: false,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.8,
                              enlargeCenterPage: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
