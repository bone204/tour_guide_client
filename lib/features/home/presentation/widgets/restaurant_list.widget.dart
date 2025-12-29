// ignore_for_file: deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_list/cooperation_list_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_list/cooperation_list_state.dart';
import 'package:tour_guide_app/features/cooperations/presentation/pages/cooperation_detail.page.dart';
import 'package:tour_guide_app/features/cooperations/presentation/widgets/cooperation_card.widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SliverRestaurantNearbyDestinationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CooperationListCubit, CooperationListState>(
      builder: (context, state) {
        if (state is! CooperationListLoaded || state.restaurants.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final restaurants = state.restaurants;

        return SliverToBoxAdapter(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryYellow,
                      AppColors.primaryYellow.withOpacity(0.6),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.6, 1.0],
                  ),
                ),
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -12,
                      right: 56,
                      child: Image.asset(
                        AppImage.food,
                        width: 60.w,
                        height: 60.h,
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: 8,
                      child: Image.asset(
                        AppImage.drink,
                        width: 60.w,
                        height: 60.h,
                      ),
                    ),
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
                                AppLocalizations.of(context)!.restaurantNearby,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.restaurantNearbyDes,
                                style: Theme.of(context).textTheme.displayMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        // Carousel Cooperation Cards
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: CarouselSlider.builder(
                            itemCount: restaurants.length,
                            itemBuilder: (context, index, realIndex) {
                              final cooperation = restaurants[index];
                              return CooperationCard(
                                cooperation: cooperation,
                                onTap: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              CooperationDetailPage.withProvider(
                                                id: cooperation.id,
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
