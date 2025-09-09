// ignore_for_file: deprecated_member_use
import 'package:tour_guide_app/common_libs.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_card.widget.dart';

class SliverRestaurantNearbyAttractionList extends StatelessWidget {
  final List<Map<String, dynamic>> places = [
    {
      "title": "Eiffel Tower",
      "image":
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      "location": "Paris, France",
      "rating": 4.8,
      "reviews": 2451,
    },
    {
      "title": "Great Wall",
      "image":
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      "location": "Beijing, China",
      "rating": 4.7,
      "reviews": 1875,
    },
    {
      "title": "Ha Long Bay",
      "image":
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      "location": "Quảng Ninh, Vietnam",
      "rating": 4.9,
      "reviews": 1320,
    },
    {
      "title": "Santorini",
      "image":
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      "location": "Cyclades, Greece",
      "rating": 4.6,
      "reviews": 980,
    },
    {
      "title": "Tokyo Tower",
      "image":
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      "location": "Tokyo, Japan",
      "rating": 4.5,
      "reviews": 1500,
    },
    {
      "title": "Sydney Opera House",
      "image":
          "https://imgcp.aacdn.jp/img-a/1440/auto/global-aaj-front/article/2017/06/595048184fa06_5950474045019_1189093891.jpg",
      "location": "Sydney, Australia",
      "rating": 4.8,
      "reviews": 2100,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.attraction,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 4.h),
            Text(
              AppLocalizations.of(context)!.attractionDes,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 20.h),

            MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 16.w,
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return AttractionCard(
                  imageUrl: place["image"],
                  title: place["title"],
                  location: place["location"],
                  rating: place["rating"],
                  reviews: place["reviews"],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
