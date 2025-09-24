import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/car_info_item.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/feature_chip.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/review_card.widget.dart';

class CarDetailPage extends StatelessWidget {
  final Map<String, dynamic>? car;

  const CarDetailPage({Key? key, this.car}) : super(key: key);

  // Fake data (used when `car` is not provided)
  static final Map<String, dynamic> _fakeCar = {
    'image': AppImage.defaultCar,
    'name': 'Toyota Vios G 2022',
    'type': 'Sedan',
    'price': 800000,
    'seats': 5,
    'transmission': 'Tự động (AT)',
    'fuel': 'Xăng',
    'year': 2022,
    'mileage': 25000,
    'rating': 4.6,
    'description':
        'Toyota Vios G 2022 - Xe gia đình nhỏ gọn, tiêu hao nhiên liệu thấp, nội thất tiện nghi. Phù hợp đi phố, đi du lịch ngắn ngày. Chủ xe nhiệt tình, bảo dưỡng định kỳ đầy đủ.',
    'features': [
      'Điều hòa',
      'GPS',
      'Bluetooth',
      'Ghế trẻ em (có thể lắp)',
      'Cruise control',
      'Camera lùi'
    ],
    'reviews': [
      {
        'author': 'Nguyễn Văn A',
        'rating': 5,
        'text': 'Xe sạch, chạy êm. Chủ xe nhiệt tình giao nhận.'
      },
      {
        'author': 'Lê Thị B',
        'rating': 4,
        'text': 'Xe tốt, giá hợp lý. Điều hòa hơi yếu khi nắng gắt.'
      }
    ],
    'locations': ['Hà Nội - Hoàn Kiếm', 'Hà Nội - Cầu Giấy']
  };

  @override
  Widget build(BuildContext context) {
    final c = car ?? _fakeCar;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)?.carDetails ?? 'Chi tiết xe',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 236.h,
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  child: Image.asset(
                    c['image'] as String,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  right: 12.w,
                  top: 12.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.star,
                          color: AppColors.primaryYellow,
                          width: 16.w,
                          height: 16.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          (c['rating'] as double).toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c['name'] as String,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${c['type']} • ${c['year']}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatter.currency(c['price']),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.primaryOrange,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "/ ${AppLocalizations.of(context)!.day}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
                          )
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 16.h),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 84.h,
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      viewportFraction: 0.4,
                      padEnds: false,
                    ),
                    items: [
                      CarInfoItem(icon: AppIcons.seat, text: '${c['seats']} chỗ'),
                      CarInfoItem(icon: AppIcons.setting, text: c['transmission']),
                      CarInfoItem(icon: AppIcons.gasPump, text: c['fuel']),
                      CarInfoItem(icon: AppIcons.speed, text: '${c['mileage']} km'),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 12.h),

                  Text(AppLocalizations.of(context)!.description, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 8.h),
                  Text(
                    c['description'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle, height: 1.5),
                  ),

                  SizedBox(height: 16.h),

                  Text(AppLocalizations.of(context)!.features, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: (c['features'] as List<dynamic>)
                        .map((f) => FeatureChip(text: f as String))
                        .toList(),
                  ),
                  SizedBox(height: 16.h),
                  Divider(),
                  SizedBox(height: 12.h),

                  Text(AppLocalizations.of(context)!.reviews, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 12.h),
                  Column(
                    children: (c['reviews'] as List<dynamic>)
                      .map((r) => ReviewCard(
                            author: r['author'] as String,
                            rating: r['rating'] as int,
                            text: r['text'] as String,
                          ))
                      .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
