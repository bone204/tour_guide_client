// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/ticket_clipper.widget.dart';

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
                // Coin nằm trên background
                Positioned(
                  top: 16,
                  right: 12,
                  child: Image.asset(
                    AppImage.coin,
                    width: 140.w,
                    height: 140.h,
                  ),
                ),

                // Nội dung (title + carousel)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Title
                    Padding(
                      padding: EdgeInsets.only(
                          left: 12.w, right: 12.w, bottom: 16.h),
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
                                .titleLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Carousel
                    CarouselSlider.builder(
                      itemCount: vouchers.length,
                      itemBuilder: (context, index, realIndex) {
                        return buildVoucherCard(context, vouchers[index]);
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


  Widget buildVoucherCard(BuildContext context, String voucherText) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    child: ClipPath(
      clipper: TicketClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.6),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // 🔹 Header Voucher
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.card_giftcard,color: AppColors.primaryBlue, size: 36.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucherText,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Ưu đãi đặc biệt cho bạn",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSubtitle,
                            overflow: TextOverflow.ellipsis,
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Dash line
            SizedBox(
              height: 1.h,
              child: DottedLine(
                dashLength: 6.w,
                dashGapLength: 4.w,
                lineThickness: 1.sp,
                dashColor: AppColors.secondaryGrey,
              ),
            ),

            // 🔹 Footer Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sử dụng ngay để nhận ưu đãi',
                        style: Theme.of(context).textTheme.displayMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        
                      },
                      icon: SvgPicture.asset(
                        AppIcons.arrorRight, 
                        width: 14.w,
                        height: 14.h,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


}
