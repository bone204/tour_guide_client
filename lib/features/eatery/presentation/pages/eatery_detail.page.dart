import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/eatery/presentation/bloc/get_eatery_detail/get_eatery_detail_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';

class EateryDetailPage extends StatelessWidget {
  final int eateryId;

  const EateryDetailPage({super.key, required this.eateryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<GetEateryDetailCubit>()..getEateryDetail(eateryId),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<GetEateryDetailCubit, GetEateryDetailState>(
          builder: (context, state) {
            if (state is GetEateryDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetEateryDetailFailure) {
              return Center(child: Text(state.message));
            } else if (state is GetEateryDetailSuccess) {
              final eatery = state.eatery;
              return Stack(
                children: [
                  // Full screen background image or top image
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 350.h,
                    child: Image.network(
                      eatery.imageUrl ?? 'https://via.placeholder.com/300',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 50.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Back Button overlaid on image
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10.h,
                    left: 16.w,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),

                  // Content Container
                  Positioned.fill(
                    top: 300.h,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.r),
                          topRight: Radius.circular(32.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 32.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              eatery.name ?? '',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(fontSize: 26.sp, height: 1.2),
                            ),
                            SizedBox(height: 20.h),

                            // Location
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withOpacity(
                                      0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 20.sp,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Text(
                                    eatery.address ?? '',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSubtitle,
                                      fontSize: 15.sp,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (eatery.phone != null) ...[
                              SizedBox(height: 16.h),
                              Divider(color: Colors.grey[200], height: 1),
                              SizedBox(height: 16.h),

                              // Phone
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGreen.withOpacity(
                                        0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.phone,
                                      size: 20.sp,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Text(
                                    eatery.phone!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            SizedBox(height: 24.h),
                            Divider(color: Colors.grey[200], height: 1),
                            SizedBox(height: 24.h),

                            // About
                            if (eatery.description != null) ...[
                              Text(
                                AppLocalizations.of(context)!.about,
                                style: Theme.of(context).textTheme.displayLarge
                                    ?.copyWith(fontSize: 20.sp),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                eatery.description!,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSubtitle,
                                  height: 1.6,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
