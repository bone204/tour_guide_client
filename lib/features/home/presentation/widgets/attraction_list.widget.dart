// ignore_for_file: deprecated_member_use
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_state.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_card.widget.dart';

class SliverRestaurantNearbyAttractionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.attraction,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 4.h),
            Text(
              AppLocalizations.of(context)!.attractionDes,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 20.h),

            BlocBuilder<GetDestinationCubit, GetDestinationState>(
              builder: (context, state) {
                if (state is GetDestinationLoading) {
                  return Container(
                    height: 200.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  );
                }

                if (state is GetDestinationError) {
                  return Container(
                    height: 200.h,
                    padding: EdgeInsets.all(16.w),
                    child: Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: AppColors.textSubtitle),
                      ),
                    ),
                  );
                }

                if (state is GetDestinationLoaded) {
                  final destinations = state.destinations;

                  if (destinations.isEmpty) {
                    return Container(
                      height: 200.h,
                      child: Center(
                        child: Text(
                          'No attractions found',
                          style: TextStyle(color: AppColors.textSubtitle),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 16.w,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final destination = destinations[index];
                          
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => DestinationDetailPage.withProvider(
                                    destinationId: destination.id,
                                  ),
                                ),
                              );
                            },
                            child: AttractionCard(
                              imageUrl: destination.photos?.isNotEmpty == true
                                  ? destination.photos!.first
                                  : AppImage.defaultDestination,
                              title: destination.name,
                              location: destination.province ?? "Unknown",
                              rating: destination.rating ?? 0.0,
                              reviews: destination.userRatingsTotal ?? 0,
                            ),
                          );
                        },
                      ),
                      
                      // Loading more indicator
                      if (state.isLoadingMore)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      
                      // End of list message
                      if (state.hasReachedEnd && destinations.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: Text(
                              'You have seen all attractions',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSubtitle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }

                return Container(height: 200.h);
              },
            ),
          ],
        ),
      ),
    );
  }
}
