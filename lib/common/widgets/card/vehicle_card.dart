import 'package:intl/intl.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/button/secondary_button.dart';
import 'package:tour_guide_app/common_libs.dart';

class VehicleCard extends StatelessWidget {
  final String name;
  final String type;
  final int seats;
  final int price;
  final String imageUrl;
  final VoidCallback? onDetail;
  final VoidCallback? onRent;

  VehicleCard({
    super.key,
    required this.name,
    required this.type,
    required this.seats,
    required this.price,
    required this.imageUrl,
    this.onDetail,
    this.onRent,
  });

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.primaryBlue.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      imageUrl,
                      height: 100.h,
                      width: 120.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          Text(
                            type,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSubtitle),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "| $seats ${AppLocalizations.of(context)!.seats}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSubtitle),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        "${_currencyFormat.format(price)} / ${AppLocalizations.of(context)!.day}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primaryOrange,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    title: AppLocalizations.of(context)!.details,
                    onPressed: onDetail ?? () {},
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: PrimaryButton(
                    title: AppLocalizations.of(context)!.rent,
                    onPressed: onRent ?? () {},
                    backgroundColor: AppColors.primaryBlue,
                    textColor: AppColors.textSecondary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
