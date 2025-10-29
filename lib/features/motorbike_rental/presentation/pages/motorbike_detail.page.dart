import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/widgets/motorbike_info_item.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/feature_chip.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/review_card.widget.dart';

class MotorbikeDetailPage extends StatelessWidget {
  final Map<String, dynamic>? motorbike;

  const MotorbikeDetailPage({Key? key, this.motorbike}) : super(key: key);

  // Fake data (used when `motorbike` is not provided)
  static final Map<String, dynamic> _fakeMotorbike = {
    'image': AppImage.defaultCar,
    'name': 'Honda Wave RSX 2023',
    'type': 'Số',
    'price': 100000,
    'seats': 2,
    'transmission': 'Số',
    'fuel': 'Xăng',
    'year': 2023,
    'mileage': 15000,
    'rating': 4.5,
    'description':
        'Honda Wave RSX 2023 - Xe máy tiết kiệm nhiên liệu, bền bỉ, phù hợp đi lại trong thành phố. Máy mạnh mẽ, khởi động nhanh, phanh an toàn. Chủ xe nhiệt tình, bảo dưỡng định kỳ đầy đủ.',
    'features': [
      'Phanh đĩa',
      'Khoá điện tử',
      'Đèn LED',
      'Yên rộng',
      'Giỏ hàng lớn',
      'Chống sốc tốt'
    ],
    'reviews': [
      {
        'author': 'Nguyễn Văn A',
        'rating': 5,
        'text': 'Xe tốt, chạy rất tiết kiệm xăng. Chủ xe giao xe đúng giờ.'
      },
      {
        'author': 'Lê Thị B',
        'rating': 4,
        'text': 'Xe mới, sạch sẽ. Phanh hơi cứng nhưng vẫn an toàn.'
      }
    ],
    'locations': ['Hà Nội - Hoàn Kiếm', 'Hà Nội - Cầu Giấy']
  };

  @override
  Widget build(BuildContext context) {
    final m = motorbike ?? _fakeMotorbike;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)?.mortorbikeDetails ?? 'Chi tiết xe máy',
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
                    m['image'] as String,
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
                          (m['rating'] as double).toStringAsFixed(1),
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
                              m['name'] as String,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${m['type']} • ${m['year']}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatter.currency(m['price']),
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
                      MotorbikeInfoItem(icon: AppIcons.seat, text: '${m['seats']} người'),
                      MotorbikeInfoItem(icon: AppIcons.setting, text: m['transmission'] as String),
                      MotorbikeInfoItem(icon: AppIcons.gasPump, text: m['fuel'] as String),
                      MotorbikeInfoItem(icon: AppIcons.speed, text: '${m['mileage']} km'),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 12.h),

                  Text(AppLocalizations.of(context)!.description, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 8.h),
                  Text(
                    m['description'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle, height: 1.5),
                  ),

                  SizedBox(height: 16.h),

                  Text(AppLocalizations.of(context)!.features, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: (m['features'] as List<dynamic>)
                        .map((f) => FeatureChip(text: f as String))
                        .toList(),
                  ),
                  SizedBox(height: 16.h),
                  Divider(),
                  SizedBox(height: 12.h),

                  Text(AppLocalizations.of(context)!.reviews, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 12.h),
                  Column(
                    children: (m['reviews'] as List<dynamic>)
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

