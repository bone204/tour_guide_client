import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/button/like_button.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_state.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantSearchResponse restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine price range text
    String priceText = "";
    if (restaurant.restaurantTables.isNotEmpty) {
      final prices =
          restaurant.restaurantTables
              .map((t) => _parsePrice(t.priceRange))
              .where((p) => p != null)
              .toList();
      if (prices.isNotEmpty) {
        prices.sort();
        final minPrice = prices.first;
        final maxPrice = prices.last;
        if (minPrice == maxPrice) {
          priceText =
              "${Formatter.currency(minPrice!)} / ${AppLocalizations.of(context)!.person}";
        } else {
          priceText =
              "${Formatter.currency(minPrice!)} - ${Formatter.currency(maxPrice!)} / ${AppLocalizations.of(context)!.person}";
        }
      } else {
        priceText = AppLocalizations.of(context)!.contactForPrice;
      }
    } else {
      priceText = AppLocalizations.of(context)!.contactForPrice;
    }

    String cuisineText = "";
    if (restaurant.restaurantTables.isNotEmpty &&
        restaurant.restaurantTables.first.dishType != null) {
      cuisineText = restaurant.restaurantTables.first.dishType!;
    } else {
      cuisineText =
          AppLocalizations.of(context)!.foodTypeVietnamese; // Default fallback
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: Image.network(
                    restaurant.photo ?? "",
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Image.asset(
                          AppImage.defaultFood,
                          width: double.infinity,
                          height: 180.h,
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
                // Rating Badge (Inline)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlack.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.star,
                          width: 16.w,
                          height: 16.h,
                          color: AppColors.primaryYellow,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          double.tryParse(
                                restaurant.averageRating,
                              )?.toStringAsFixed(1) ??
                              "0.0",
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: _buildFavoriteButton(context),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontSize: 16.sp, height: 1.3),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          cuisineText,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.location,
                        width: 14.w,
                        height: 14.h,
                        color: AppColors.textSubtitle,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          restaurant.province ?? '',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSubtitle),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  if (priceText.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Text(
                      priceText,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primaryOrange,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int? _parsePrice(String? priceRange) {
    if (priceRange == null) return null;
    // Assuming format "200k - 500k" or similar, just parsing first number found for simplicity or creating a proper parser
    // For now, let's try to extract digits
    final cleanPrice = priceRange
        .toLowerCase()
        .replaceAll(',', '')
        .replaceAll('.', '');
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(cleanPrice);

    if (match != null) {
      int? value = int.tryParse(match.group(0)!);
      if (value != null) {
        if (cleanPrice.contains('k')) {
          value *= 1000;
        }
        return value;
      }
    }
    return null;
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return BlocBuilder<FavoriteCooperationsCubit, FavoriteCooperationsState>(
      builder: (context, state) {
        final isFavorite = state.favoriteIds.contains(restaurant.id);

        return Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CustomLikeButton(
            size: 20.r,
            isLiked: isFavorite,
            likedColor: AppColors.primaryRed,
            unlikedColor: AppColors.secondaryGrey,
            onTap: (isLiked) async {
              await context.read<FavoriteCooperationsCubit>().toggleFavorite(
                restaurant.id,
              );
              return !isLiked;
            },
          ),
        );
      },
    );
  }
}
