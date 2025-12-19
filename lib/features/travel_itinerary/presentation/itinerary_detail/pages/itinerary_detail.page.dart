import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_itinerary_detail/get_itinerary_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/delete_itinerary/delete_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/itinerary_detail_shimmer.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/itinerary_timeline.widget.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/menu/itinerary_action_menu.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class ItineraryDetailPage extends StatelessWidget {
  final int itineraryId;

  const ItineraryDetailPage({super.key, required this.itineraryId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<GetItineraryDetailCubit>()
                    ..getItineraryDetail(itineraryId),
        ),
        BlocProvider(create: (_) => sl<DeleteItineraryCubit>()),
      ],
      child: _ItineraryDetailView(itineraryId: itineraryId),
    );
  }
}

class _ItineraryDetailView extends StatefulWidget {
  final int itineraryId;

  const _ItineraryDetailView({required this.itineraryId});

  @override
  State<_ItineraryDetailView> createState() => _ItineraryDetailViewState();
}

class _ItineraryDetailViewState extends State<_ItineraryDetailView> {
  late StreamSubscription _busSubscription;

  @override
  void initState() {
    super.initState();
    _busSubscription = eventBus.on<StopAddedEvent>().listen((_) {
      if (mounted) {
        context.read<GetItineraryDetailCubit>().getItineraryDetail(
          widget.itineraryId,
        );
      }
    });
  }

  @override
  void dispose() {
    _busSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetItineraryDetailCubit, GetItineraryDetailState>(
      listener: (context, state) {
        if (state is GetItineraryDetailFailure) {
          CustomSnackbar.show(
            context,
            message: state.message,
            type: SnackbarType.error,
          );
        }
      },
      builder: (context, state) {
        if (state is GetItineraryDetailLoading) {
          return const ItineraryDetailShimmer();
        } else if (state is GetItineraryDetailSuccess) {
          final itinerary = state.itinerary;
          // Unpack data
          final title = itinerary.name;
          final dateRange = '${itinerary.startDate} - ${itinerary.endDate}';
          final status = itinerary.status;
          final defaultImage = 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop';
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
          final days =
              itinerary.stops
                  .map(
                    (stop) => {
                      'day': AppLocalizations.of(
                        context,
                      )!.dayNumber(stop.dayOrder > 0 ? stop.dayOrder : 1),
                      'activity': stop.destination!.name,
                      'time': stop.startTime,
                    },
                  )
                  .toList();

          return BlocListener<DeleteItineraryCubit, DeleteItineraryState>(
            listener: (context, deleteState) {
              if (deleteState is DeleteItinerarySuccess) {
                Navigator.pop(
                  context,
                  true,
                ); // Return true to indicate deletion
              } else if (deleteState is DeleteItineraryFailure) {
                CustomSnackbar.show(
                  context,
                  message: deleteState.message,
                  type: SnackbarType.error,
                );
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              extendBody: true,
              body: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 250.h,
                        pinned: true,
                        backgroundColor: AppColors.backgroundColor,
                        leading: Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            top: 8.h,
                            bottom: 8.h,
                          ),
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
                                    autoPlayInterval: const Duration(
                                      seconds: 5,
                                    ),
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
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color: Colors.grey,
                                                  ),
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
                                        color: AppColors.primaryBlue,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Text(
                                        _getTranslatedStatus(context, status),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.calendar,
                                          width: 16.w,
                                          height: 16.h,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.primaryWhite,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          dateRange,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
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
                                  AppLocalizations.of(
                                    context,
                                  )!.itinerarySchedule,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: AppColors.textPrimary),
                                ),
                                SizedBox(height: 16.h),
                              ],
                              days.isNotEmpty
                                  ? ItineraryTimeline(timelineItems: days)
                                  : Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                          AppLotties.empty,
                                          width: 300.w,
                                          height: 300.h,
                                          fit: BoxFit.contain,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
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
                                            AppLocalizations.of(
                                              context,
                                            )!.noSchedule,
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
                              SizedBox(height: 120.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.w, bottom: 20.h),
                        child: ItineraryActionMenu(
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              AppRouteConstant.editItinerary,
                              arguments: itinerary,
                            );
                          },
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.confirmDelete,
                                    ),
                                    content: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.confirmDeleteContent,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(
                                          AppLocalizations.of(context)!.cancel,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          context
                                              .read<DeleteItineraryCubit>()
                                              .deleteItinerary(itinerary.id);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.delete,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  String _getTranslatedStatus(BuildContext context, String status) {
    switch (status) {
      case 'upcoming':
        return AppLocalizations.of(context)!.statusUpcoming;
      case 'completed':
        return AppLocalizations.of(context)!.statusCompleted;
      case 'ongoing':
        return AppLocalizations.of(context)!.statusOngoing;
      case 'cancelled':
        return AppLocalizations.of(context)!.statusCancelled;
      case 'draft':
        return AppLocalizations.of(context)!.statusDraft;
      default:
        return status;
    }
  }
}
