import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/itinerary_detail_shimmer.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/itinerary_explore_detail/itinerary_explore_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/itinerary_explore_detail/itinerary_explore_detail_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/explore_timeline.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class ItineraryExploreDetailPage extends StatelessWidget {
  final int itineraryId;

  const ItineraryExploreDetailPage({super.key, required this.itineraryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<ItineraryExploreDetailCubit>()
                ..getItineraryDetail(itineraryId),
      child: const _ItineraryExploreDetailView(),
    );
  }
}

class _ItineraryExploreDetailView extends StatelessWidget {
  const _ItineraryExploreDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      ItineraryExploreDetailCubit,
      ItineraryExploreDetailState
    >(
      listener: (context, state) {
        if (state is ItineraryExploreDetailFailure) {
          CustomSnackbar.show(
            context,
            message: state.message,
            type: SnackbarType.error,
          );
        }
      },
      builder: (context, state) {
        if (state is ItineraryExploreDetailLoading) {
          return const ItineraryDetailShimmer();
        } else if (state is ItineraryExploreDetailSuccess) {
          final itinerary = state.itinerary;
          final title = itinerary.name;
          final defaultImage =
              'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop';
          final List<String> images = [];
          if (itinerary.stops.isNotEmpty) {
            for (var stop in itinerary.stops) {
              if (stop.destination != null &&
                  stop.destination!.photos != null &&
                  stop.destination!.photos!.isNotEmpty) {
                images.add(stop.destination!.photos!.first);
              }
            }
          }
          final List<Map<String, dynamic>> days =
              itinerary.stops
                  .map(
                    (stop) => <String, dynamic>{
                      'day': AppLocalizations.of(
                        context,
                      )!.dayNumber(stop.dayOrder > 0 ? stop.dayOrder : 1),
                      'activity': stop.destination!.name,
                      'time': stop.startTime,
                      'stop': stop,
                    },
                  )
                  .toList();

          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.h,
                  pinned: true,
                  backgroundColor: AppColors.backgroundColor,
                  leading: Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          AppIcons.arrowLeft,
                          width: 16.w,
                          height: 16.h,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryBlack,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (images.isNotEmpty)
                          CarouselSlider(
                            options: CarouselOptions(
                              height: double.infinity,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayAnimationDuration: const Duration(
                                seconds: 1,
                              ),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              scrollDirection: Axis.horizontal,
                            ),
                            items:
                                images.map((imgUrl) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Image.network(
                                        imgUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(color: Colors.grey),
                                      );
                                    },
                                  );
                                }).toList(),
                          )
                        else
                          Image.network(
                            defaultImage,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Container(color: Colors.grey),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                margin: EdgeInsets.only(bottom: 8.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  itinerary.province,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                              Text(
                                title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (days.isNotEmpty) ...[
                          Text(
                            AppLocalizations.of(context)!.itinerarySchedule,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 16.h),
                          ExploreTimeline(timelineItems: days),
                        ] else
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  AppLotties.empty,
                                  width: 300.w,
                                  height: 300.h,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image_not_supported,
                                      size: 64.sp,
                                      color: AppColors.primaryGrey,
                                    );
                                  },
                                ),
                                SizedBox(height: 16.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.w,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.noSchedule,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
