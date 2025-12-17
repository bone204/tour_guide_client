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
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/widgets/stop_card.dart';
import 'package:tour_guide_app/service_locator.dart';

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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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

class _EditItineraryViewState extends State<_EditItineraryView> {
  late Itinerary _currentItinerary;
  late StreamSubscription _busSubscription;

  @override
  void initState() {
    super.initState();
    _currentItinerary = widget.itinerary;
    _busSubscription = eventBus.on<StopAddedEvent>().listen((_) {
      if (mounted) {
        // Using context here works because we are child of BlocProvider
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
      _currentItinerary = widget.itinerary;
    }
  }

  @override
  void dispose() {
    _busSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetItineraryDetailCubit, GetItineraryDetailState>(
      listener: (context, state) {
        if (state is GetItineraryDetailSuccess) {
          setState(() {
            _currentItinerary = state.itinerary;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.itineraryUpdated),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.editItinerary,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Column(
          children: [
            Expanded(
              child:
                  _currentItinerary.stops.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              AppLotties.empty,
                              width: 300.w,
                              height: 300.h,
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
                      )
                      : ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: _currentItinerary.stops.length,
                        itemBuilder: (context, index) {
                          final stop = _currentItinerary.stops[index];
                          return StopCard(
                            stop: stop,
                            onTap: () {
                              // TODO: Implement Edit Stop logic
                            },
                          );
                        },
                      ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: PrimaryButton(
                title: AppLocalizations.of(context)!.addStop,
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    AppRouteConstant.itineraryDestinationSelection,
                    arguments: {
                      'province': _currentItinerary.province,
                      'itineraryId': _currentItinerary.id,
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
