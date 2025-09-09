// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/voucher_card.widget.dart';

class SliverVoucherCarousel extends StatelessWidget {
  final List<String> vouchers = [
    'Voucher 10%',
    'Voucher Free Shipping',
    'Voucher 50K',
    'Voucher 20%',
    'Voucher Buy 1 Get 1',
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
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withOpacity(0.6),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 16,
                  right: 12,
                  child: Image.asset(
                    AppImage.coin,
                    width: 140.w,
                    height: 140.h,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            AppIcons.gift,
                            width: 28.w,
                            height: 28.h,
                            color: AppColors.primaryWhite,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            AppLocalizations.of(context)!.exclusiveVouchers,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Carousel
                    CarouselSlider.builder(
                      itemCount: vouchers.length,
                      itemBuilder: (context, index, realIndex) {
                        return VoucherCard(voucherText: vouchers[index]);
                      },
                      options: CarouselOptions(
                        height: 140,
                        autoPlay: true,
                        enableInfiniteScroll: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                        padEnds: false,
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
