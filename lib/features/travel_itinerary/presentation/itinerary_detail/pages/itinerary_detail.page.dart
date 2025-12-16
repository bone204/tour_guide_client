import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_itinerary_detail/get_itinerary_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/itinerary_timeline.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class ItineraryDetailPage extends StatelessWidget {
  final int itineraryId;

  const ItineraryDetailPage({super.key, required this.itineraryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<GetItineraryDetailCubit>()..getItineraryDetail(itineraryId),
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
    return BlocBuilder<GetItineraryDetailCubit, GetItineraryDetailState>(
      builder: (context, state) {
        if (state is GetItineraryDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is GetItineraryDetailFailure) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(state.message)),
          );
        } else if (state is GetItineraryDetailSuccess) {
          final itinerary = state.itinerary;
          // Unpack data
          final title = itinerary.name;
          final dateRange = '${itinerary.startDate} - ${itinerary.endDate}';
          final status = itinerary.status;
          final imageUrl =
              'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop';
          final days =
              itinerary.stops
                  .map(
                    (stop) => {
                      'day':
                          stop.dayOrder > 0 ? 'Day ${stop.dayOrder}' : 'Day 1',
                      'activity':
                          stop.notes.isNotEmpty
                              ? stop.notes
                              : 'Stop ${stop.sequence}',
                      'time': '${stop.startTime} - ${stop.endTime}',
                    },
                  )
                  .toList();

          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: CustomScrollView(
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
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 16.w,
                        top: 8.h,
                        bottom: 8.h,
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRouteConstant.editItinerary,
                              arguments: itinerary,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
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
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  status,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                              Text(
                                title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.white70,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    dateRange,
                                    style: Theme.of(context).textTheme.bodySmall
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
                        Text(
                          AppLocalizations.of(context)!.itinerarySchedule,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 16.h),
                        days.isNotEmpty
                            ? ItineraryTimeline(timelineItems: days)
                            : const Text('No stops yet'),
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
