import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_itinerary_detail/get_itinerary_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/edit_stop.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/widgets/itinerary_stop_card.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/edit_stop/edit_stop_cubit.dart';

class EditItineraryPage extends StatefulWidget {
  final Itinerary itinerary;

  const EditItineraryPage({super.key, required this.itinerary});

  @override
  State<EditItineraryPage> createState() => _EditItineraryPageState();
}

class _EditItineraryPageState extends State<EditItineraryPage> {
  late Itinerary _currentItinerary;

  @override
  void initState() {
    super.initState();
    _currentItinerary = widget.itinerary;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetItineraryDetailCubit>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<GetItineraryDetailCubit>()),
          BlocProvider(create: (context) => sl<EditStopCubit>()),
        ],
        child: BlocListener<GetItineraryDetailCubit, GetItineraryDetailState>(
          listener: (context, state) {
            if (state is GetItineraryDetailSuccess) {
              setState(() {
                _currentItinerary = state.itinerary;
              });
              // Only show success message if it's not a background refresh or if explicit action happened.
              // For now, keeping as is, but could be noisy on drag/drop refresh.
            } else if (state is GetItineraryDetailFailure) {
              CustomSnackbar.show(
                context,
                message: state.message,
                type: SnackbarType.error,
              );
            }
          },
          child: Builder(
            builder: (context) {
              return _EditItineraryView(itinerary: _currentItinerary);
            },
          ),
        ),
      ),
    );
  }
}

class _EditItineraryView extends StatefulWidget {
  final Itinerary itinerary;
  const _EditItineraryView({required this.itinerary});

  @override
  State<_EditItineraryView> createState() => _EditItineraryViewState();
}

class _EditItineraryViewState extends State<_EditItineraryView>
    with SingleTickerProviderStateMixin {
  late Itinerary _currentItinerary;
  late StreamSubscription _busSubscription;
  late TabController _tabController;

  int get _calculatedDays {
    if (_currentItinerary.startDate.isEmpty ||
        _currentItinerary.endDate.isEmpty) {
      return _currentItinerary.numberOfDays > 0
          ? _currentItinerary.numberOfDays
          : 1;
    }
    try {
      final start = DateTime.parse(_currentItinerary.startDate);
      final end = DateTime.parse(_currentItinerary.endDate);
      return end.difference(start).inDays + 1;
    } catch (e) {
      return _currentItinerary.numberOfDays > 0
          ? _currentItinerary.numberOfDays
          : 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentItinerary = widget.itinerary;
    // Ensure at least 1 day to avoid errors
    _tabController = TabController(length: _calculatedDays, vsync: this);

    _busSubscription = eventBus.on<StopAddedEvent>().listen((_) {
      if (mounted) {
        context.read<GetItineraryDetailCubit>().getItineraryDetail(
          _currentItinerary.id,
        );
      }
    });
  }

  @override
  void didUpdateWidget(_EditItineraryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itinerary != oldWidget.itinerary) {
      // If number of days changes, we might need to recreate the controller,
      // but usually itinerary days don't change dynamically in this view.
      // If they do, we'd need to dispose and create a new controller.
      // For now, assuming day count is stable or we just update content.
      final newDays = _calculatedDays;
      if (_tabController.length != newDays) {
        _tabController.dispose();
        _tabController = TabController(length: newDays, vsync: this);
      }
      _currentItinerary = widget.itinerary;
    }
  }

  @override
  void dispose() {
    _busSubscription.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure we have a valid day count for UI generation
    // Ensure we have a valid day count for UI generation
    final dayCount = _calculatedDays;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.editItinerary,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primaryBlue,
          indicatorColor: AppColors.primaryBlue,
          tabs: List.generate(dayCount, (index) {
            final dayLabel = AppLocalizations.of(context)!.day;
            final capitalizedDay =
                dayLabel.isNotEmpty
                    ? '${dayLabel[0].toUpperCase()}${dayLabel.substring(1)}'
                    : dayLabel;
            return Tab(text: "$capitalizedDay ${index + 1}");
          }),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(dayCount, (dayIndex) {
                final currentDay = dayIndex + 1;
                final dayStops =
                    _currentItinerary.stops
                        .where((stop) => stop.dayOrder == currentDay)
                        .toList();

                if (dayStops.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          AppLotties.empty,
                          width: 200.w,
                          height: 200.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalizations.of(context)!.noStop,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  );
                }

                return ReorderableListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: dayStops.length,
                  proxyDecorator: (child, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget? child) {
                        return Material(
                          elevation: 5,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16.r),
                          child: ItineraryStopCard(
                            stop: dayStops[index],
                            onTap: () {}, 
                            margin: EdgeInsets.zero,
                          ),
                        );
                      },
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    if (oldIndex == newIndex) return;

                    final stop = dayStops[oldIndex];
                    final newSequence = newIndex + 1; // 1-based sequence

                    // Optimistic update locally
                    setState(() {
                      final newDayStops = List<Stop>.from(dayStops);
                      newDayStops.removeAt(oldIndex);
                      newDayStops.insert(newIndex, stop);

                      final updatedStops =
                          _currentItinerary.stops
                              .where((s) => s.dayOrder != currentDay)
                              .toList();
                      updatedStops.addAll(newDayStops);
                      updatedStops.sort(
                        (a, b) => a.dayOrder.compareTo(b.dayOrder),
                      );

                      _currentItinerary = _currentItinerary.copyWith(
                        stops: updatedStops,
                      );
                    });

                    // Call API
                    context
                        .read<EditStopCubit>()
                        .updateStop(
                          itineraryId: _currentItinerary.id,
                          originalStop: stop,
                          newSequence: newSequence,
                        )
                        .then((_) {
                          // Refresh global state
                          eventBus.fire(StopAddedEvent());
                        });
                  },
                  itemBuilder: (context, index) {
                    final stop = dayStops[index];
                    return ItineraryStopCard(
                      key: ValueKey(stop.id),
                      stop: stop,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditStopPage(
                                  itineraryId: _currentItinerary.id,
                                  stop: stop,
                                ),
                          ),
                        ).then((updated) {
                          if (updated == true) {
                            context
                                .read<GetItineraryDetailCubit>()
                                .getItineraryDetail(_currentItinerary.id);
                          }
                        });
                      },
                    );
                  },
                );
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.addStop,
              onPressed: () async {
                final currentDayIndex = _tabController.index;
                final currentDay = currentDayIndex + 1;

                Navigator.pushNamed(
                  context,
                  AppRouteConstant.itineraryDestinationSelection,
                  arguments: {
                    'province': _currentItinerary.province,
                    'itineraryId': _currentItinerary.id,
                    'dayOrder': currentDay,
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
