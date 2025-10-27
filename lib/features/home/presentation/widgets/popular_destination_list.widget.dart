// ignore_for_file: deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/destination_card.widget.dart';

class SliverPopularDestinationList extends StatelessWidget {
  final List<DestinationCard> fakeDestinations = [
    DestinationCard(
      imageUrl:
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      name: "Eiffel Tower",
      rating: "4.8",
      location: "Paris, France",
      category: "Địa danh",
    ),
    DestinationCard(
      imageUrl:
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      name: "Mount Fuji",
      rating: "4.7",
      location: "Tokyo, Japan",
      category: "Thiên nhiên",
    ),
    DestinationCard(
      imageUrl:
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      name: "Ha Long Bay",
      rating: "4.9",
      location: "Quang Ninh, Vietnam",
      category: "Bãi biển",
    ),
    DestinationCard(
      imageUrl:
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      name: "Grand Canyon",
      rating: "4.6",
      location: "Arizona, USA",
      category: "Phiêu lưu",
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
                  AppColors.primaryOrange,
                  AppColors.primaryOrange.withOpacity(0.6),
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
                  top: -28,
                  right: 0,
                  child: Image.asset(
                    AppImage.sakura,
                    width: 140.w,
                    height: 140.h,
                  ),
                ),

                // 🔹 Nội dung
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
                            AppLocalizations.of(context)!.popular,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            AppLocalizations.of(context)!.popularDes,
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
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => DestinationDetailPage(
                                    imageUrl: destination.imageUrl,
                                    name: destination.name,
                                    location: destination.location,
                                    rating: destination.rating,
                                    category: destination.category,
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
