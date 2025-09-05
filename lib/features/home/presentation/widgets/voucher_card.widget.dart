// ignore_for_file: deprecated_member_use

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/ticket_clipper.widget.dart';

class VoucherCard extends StatelessWidget {
  final String voucherText;

  const VoucherCard({super.key, required this.voucherText});

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.card_giftcard,
                          color: AppColors.primaryBlue, size: 36.sp),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSubtitle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                        onPressed: () {},
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
