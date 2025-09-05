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
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Title
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(AppIcons.gift, width: 28.w, height: 28.h, color: AppColors.primaryWhite,),
                  SizedBox(width: 12.w,),
                  Text(
                    AppLocalizations.of(context)!.exclusiveVouchers,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                    )
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
                height: 130, 
                autoPlay: true,
                enableInfiniteScroll: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.75,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVoucherCard(BuildContext context, String voucherText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipPath(
        clipper: TicketClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  color: AppColors.primaryWhite,
                  child: Center(
                    child: Text(
                      voucherText,
                      style: const TextStyle(
                        fontSize: 20, // giảm xuống
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              // 🔹 Dash line
              SizedBox(
                height: 1,
                child: DottedLine(
                  dashLength: 6,
                  dashGapLength: 4,
                  lineThickness: 1,
                  dashColor: Colors.grey.shade400,
                ),
              ),

              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer,
                          color: Colors.black, size: 22), // giảm size icon
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Sử dụng ngay để nhận ưu đãi',
                          style: const TextStyle(
                            fontSize: 13, // giảm size text
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.black54, size: 14),
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
