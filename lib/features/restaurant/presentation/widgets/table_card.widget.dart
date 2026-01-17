import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_response.dart';

class TableCard extends StatelessWidget {
  final RestaurantTableSearchResponse table;
  final int selectedQuantity;
  final Function(int) onQuantityChanged;

  const TableCard({
    super.key,
    required this.table,
    required this.selectedQuantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isSelected = selectedQuantity > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : AppColors.secondaryGrey,
          width: isSelected ? 2.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image header
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Stack(
              children: [
                Image.network(
                  table.photo ?? "",
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 160.h,
                      color: AppColors.secondaryGrey,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSubtitle,
                      ),
                    );
                  },
                ),

                // Available/Unavailable badge
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          table.isAvailable
                              ? AppColors.primaryGreen
                              : AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      table.isAvailable
                          ? AppLocalizations.of(context)!.statusAvailable
                          : AppLocalizations.of(context)!.statusSoldOut,
                      style: theme.displayMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                // Selected badge
                if (isSelected)
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            AppLocalizations.of(context)!.statusSelected,
                            style: theme.displayMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        table.name,
                        style: theme.titleMedium?.copyWith(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        _formatPrice(context),
                        style: theme.displayLarge?.copyWith(
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Capacity
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.user,
                      width: 18.w,
                      height: 18.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryBlue,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${table.maxPeople ?? 0} ${AppLocalizations.of(context)!.people}',
                      style: theme.displayLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                if (table.note != null && table.note!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    table.note!,
                    style: theme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                SizedBox(height: 16.h),

                // Divider
                Divider(
                  height: 1.h,
                  color: AppColors.secondaryGrey.withOpacity(0.5),
                ),

                SizedBox(height: 16.h),

                // Quantity selector or unavailable message
                if (table.isAvailable) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.selectQuantity,
                        style: theme.displayLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrement
                            InkWell(
                              onTap:
                                  selectedQuantity > 0
                                      ? () => onQuantityChanged(
                                        selectedQuantity - 1,
                                      )
                                      : null,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color:
                                      selectedQuantity > 0
                                          ? AppColors.primaryBlue
                                          : AppColors.secondaryGrey,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 16.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            // Count
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                selectedQuantity.toString(),
                                style: theme.titleMedium?.copyWith(
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                            // Increment
                            InkWell(
                              onTap:
                                  selectedQuantity < table.availableQuantity
                                      ? () => onQuantityChanged(
                                        selectedQuantity + 1,
                                      )
                                      : null,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 16.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.block,
                          size: 16.sp,
                          color: AppColors.primaryRed,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          AppLocalizations.of(context)!.statusSoldOut,
                          style: theme.displayLarge?.copyWith(
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(BuildContext context) {
    if (table.priceRange == null) {
      return AppLocalizations.of(context)!.contactForPrice;
    }

    final cleanPrice = table.priceRange!
        .toLowerCase()
        .replaceAll(',', '')
        .replaceAll('.', '');
    final regex = RegExp(r'(\d+)');
    final matches = regex.allMatches(cleanPrice);

    if (matches.isEmpty) return table.priceRange!;

    List<int> prices = [];
    bool hasK = cleanPrice.contains('k');

    for (final match in matches) {
      int? val = int.tryParse(match.group(0)!);
      if (val != null) {
        if (hasK) val *= 1000;
        prices.add(val);
      }
    }

    if (prices.isEmpty) return table.priceRange!;

    if (prices.length > 1) {
      prices.sort();
      return "${Formatter.currency(prices.first.toDouble())} - ${Formatter.currency(prices.last.toDouble())}";
    }

    return Formatter.currency(prices.first.toDouble());
  }
}
