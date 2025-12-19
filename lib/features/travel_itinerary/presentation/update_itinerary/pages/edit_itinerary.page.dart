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

class EditItineraryPage extends StatefulWidget {
  final Itinerary itinerary;

  const EditItineraryPage({super.key, required this.itinerary});

  @override
  State<EditItineraryPage> createState() => _EditItineraryPageState();
}

class _EditItineraryPageState extends State<EditItineraryPage> {
  late Itinerary _currentItinerary;
  late StreamSubscription _busSubscription;

  @override
  void initState() {
    super.initState();
    _currentItinerary = widget.itinerary;
    _busSubscription = eventBus.on<StopAddedEvent>().listen((_) {
      if (mounted) {
        context.read<GetItineraryDetailCubit>().getItineraryDetail(
          _currentItinerary.id,
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
    return BlocProvider(
      create: (context) => sl<GetItineraryDetailCubit>(),
      child: BlocListener<GetItineraryDetailCubit, GetItineraryDetailState>(
        listener: (context, state) {
          if (state is GetItineraryDetailSuccess) {
            setState(() {
              _currentItinerary = state.itinerary;
            });
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

  @override
  void initState() {
    super.initState();
    _currentItinerary = widget.itinerary;
    // Ensure at least 1 day to avoid errors
    final dayCount =
        _currentItinerary.numberOfDays > 0 ? _currentItinerary.numberOfDays : 1;
    _tabController = TabController(length: dayCount, vsync: this);

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
      if (widget.itinerary.numberOfDays != oldWidget.itinerary.numberOfDays) {
        _tabController.dispose();
        final dayCount =
            widget.itinerary.numberOfDays > 0
                ? widget.itinerary.numberOfDays
                : 1;
        _tabController = TabController(length: dayCount, vsync: this);
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
    final dayCount =
        _currentItinerary.numberOfDays > 0 ? _currentItinerary.numberOfDays : 1;

    return BlocListener<GetItineraryDetailCubit, GetItineraryDetailState>(
      listener: (context, state) {
        if (state is GetItineraryDetailSuccess) {
          setState(() {
            _currentItinerary = state.itinerary;
            // Handle day count change if necessary matching logic in didUpdateWidget
            if (state.itinerary.numberOfDays != _tabController.length) {
              _tabController.dispose();
              final newDayCount =
                  state.itinerary.numberOfDays > 0
                      ? state.itinerary.numberOfDays
                      : 1;
              _tabController = TabController(length: newDayCount, vsync: this);
            }
          });
          CustomSnackbar.show(
            context,
            message: AppLocalizations.of(context)!.itineraryUpdated,
            type: SnackbarType.success,
          );
        }
      },
      child: Scaffold(
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
              return Tab(
                text: "${AppLocalizations.of(context)!.day} ${index + 1}",
              );
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

                  return ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: dayStops.length,
                    itemBuilder: (context, index) {
                      final stop = dayStops[index];
                      return ItineraryStopCard(
                        stop: stop,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditStopPage(
                                    itineraryId: _currentItinerary.id,
                                    stop: stop,
                                    // Pass day count to EditStopPage if needed,
                                    // or just rely on it updating the backend.
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
                  // Pass the currently selected day to the destination selection
                  // So the new stop is added to the correct day
                  final currentDayIndex = _tabController.index;
                  final currentDay = currentDayIndex + 1;

                  Navigator.pushNamed(
                    context,
                    AppRouteConstant.itineraryDestinationSelection,
                    arguments: {
                      'province': _currentItinerary.province,
                      'itineraryId': _currentItinerary.id,
                      'dayOrder':
                          currentDay, // OPTIONAL: if backend/selection supports pre-selecting day
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
