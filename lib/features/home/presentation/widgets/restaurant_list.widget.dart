// ignore_for_file: deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/destination_card.widget.dart';

class SliverRestaurantNearbyDestinationList extends StatelessWidget {
  final List<DestinationCard> fakeDestinations = [
    DestinationCard(
      imageUrl:
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      name: "Le Petit Paris",
      rating: "4.8",
      location: "Paris, France",
      category: "Pháp",
    ),
    DestinationCard(
      imageUrl:
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      name: "Sushi Master",
      rating: "4.7",
      location: "Tokyo, Japan",
      category: "Nhật Bản",
    ),
    DestinationCard(
      imageUrl:
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      name: "Seafood Paradise",
      rating: "4.9",
      location: "Quang Ninh, Vietnam",
      category: "Hải sản",
    ),
    DestinationCard(
      imageUrl:
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      name: "Canyon Grill",
      rating: "4.6",
      location: "Arizona, USA",
      category: "BBQ",
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                stops: [0.6,1.0]
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
                      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.restaurantNearby,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            AppLocalizations.of(context)!.restaurantNearbyDes,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                    // Carousel Destination Cards
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: CarouselSlider.builder(
                        itemCount: fakeDestinations.length,
                        itemBuilder: (context, index, realIndex) {
                          final destination = fakeDestinations[index];
                          return DestinationCard(
                            imageUrl: destination.imageUrl,
                            name: destination.name,
                            rating: destination.rating,
                            location: destination.location,
                            category: destination.category,
                            onTap: () {
                              // TODO: Replace with real destination ID from API when integrated
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => DestinationDetailPage.withProvider(
                                    destinationId: index + 1, // Temporary: use index as ID
                                  ),
                                ),
                              );
                            },
                            onFavorite: () {
                              // TODO: add/remove from favorites
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
  }
}
