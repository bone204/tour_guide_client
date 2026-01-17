import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/button/like_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback? onTap;

  const HomeHotelCard({super.key, required this.hotel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 290.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image Section with Overlay
            Stack(
              children: [
                // Image with gradient overlay
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: Stack(
                    children: [
                      hotel.photo != null && hotel.photo!.isNotEmpty
                          ? Image.network(
                            hotel.photo!,
                            width: double.infinity,
                            height: 170.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppImage.defaultHotel,
                                width: double.infinity,
                                height: 170.h,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                          : Image.asset(
                            AppImage.defaultHotel,
                            width: double.infinity,
                            height: 170.h,
                            fit: BoxFit.cover,
                          ),
                      // Subtle gradient overlay for better text contrast
                      Container(
                        width: double.infinity,
                        height: 170.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.03),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: BlocBuilder<
                    FavoriteCooperationsCubit,
                    FavoriteCooperationsState
                  >(
                    builder: (context, state) {
                      final isLiked = state.favoriteIds.contains(hotel.id);
                      return Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite.withOpacity(0.95),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomLikeButton(
                          size: 22.r,
                          isLiked: isLiked,
                          likedColor: AppColors.primaryRed,
                          unlikedColor: AppColors.textSubtitle.withOpacity(0.6),
                          onTap: (bool liked) async {
                            return await context
                                .read<FavoriteCooperationsCubit>()
                                .toggleFavorite(hotel.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // 🔹 Content Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating Badge
                  Row(
                    children: [
                      // Rating Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppIcons.star,
                              width: 16.w,
                              height: 16.h,
                              color: AppColors.primaryYellow,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              hotel.averageRating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Name
                  Text(
                    hotel.name,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(letterSpacing: -0.3),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

                  SizedBox(height: 10.h),

                  // Location
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: SvgPicture.asset(
                          AppIcons.location,
                          width: 12.w,
                          height: 12.h,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          hotel.address ??
                              hotel.province ??
                              AppLocalizations.of(context)!.unknownLocation,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
