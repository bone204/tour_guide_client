import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/bloc/get_itinerary_me/get_itinerary_me_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/itinerary_card.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/shimmer_itinerary_list.dart';
import 'package:tour_guide_app/core/events/app_events.dart';

class ItineraryListPage extends StatefulWidget {
  const ItineraryListPage({super.key});

  @override
  State<ItineraryListPage> createState() => _ItineraryListPageState();
}

class _ItineraryListPageState extends State<ItineraryListPage> {
  late StreamSubscription _busSubscription;
  late GetItineraryMeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<GetItineraryMeCubit>()..getItineraryMe();
    _busSubscription = eventBus.on<ItineraryDeletedEvent>().listen((_) {
      if (mounted) {
        _cubit.getItineraryMe();
      }
    });
    // Also listen to CreateItinerarySuccessEvent if needed, but sticking to Delete for now
  }

  @override
  void dispose() {
    _busSubscription.cancel();
    _cubit
        .close(); // Since we created it via sl(), we should technically close it if we own it, or let BlocProvider handle it?
    // Wait, BlocProvider.value should be used if we create it in initState.
    // Or simpler: Keep BlocProvider in build, but access it.
    // Actually, purely creating in BlocProvider(create: ...) is cleaner if we access context.read in listener.
    // But listener needs context. So we can't do it in initState easily unless we store the cubit.
    // Better pattern: Wrap the Scaffold body in a pure State class?
    // Let's stick to storing cubit in initState but providing it via BlocProvider.value or similar?
    // No, standard way:
    // BlocProvider(create: ...) in build.
    // Listener in initState? No, initState doesn't have access to context provided by build's BlocProvider.
    // SOLUTION: Use BlocProvider at top of build, and have a child widget that is Stateful and listens?
    // OR: Just use the event bus to trigger a setState or call the methods, but we need the cubit instance.
    // EASIEST: Create cubit in initState. Pass to BlocProvider.value.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit, // Use value since we created it in initState
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.tripList,
          showBackButton: true,
          backgroundColor: AppColors.backgroundColor,
          onBackPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: BlocBuilder<GetItineraryMeCubit, GetItineraryMeState>(
          builder: (context, state) {
            if (state is GetItineraryMeLoading) {
              return const ShimmerItineraryList();
            } else if (state is GetItineraryMeFailure) {
              return Center(child: Text(state.message));
            } else if (state is GetItineraryMeSuccess) {
              if (state.itineraries.isEmpty) {
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
                        AppLocalizations.of(context)!.emptyItinerary,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await _cubit.getItineraryMe();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  itemCount: state.itineraries.length,
                  itemBuilder: (context, index) {
                    final item = state.itineraries[index];
                    return ItineraryCard(
                      title: item.name,
                      dateRange: '${item.startDate} - ${item.endDate}',
                      destinationCount: item.stops.length.toString(),
                      status: item.status,
                      onTap: () async {
                        final result = await Navigator.of(context).pushNamed(
                          AppRouteConstant.itineraryDetail,
                          arguments: item.id,
                        );
                        if (result == true && context.mounted) {
                          CustomSnackbar.show(
                            context,
                            message:
                                AppLocalizations.of(context)!.deleteSuccess,
                            type: SnackbarType.success,
                            margin: EdgeInsets.only(
                              bottom: 100.h,
                              left: 16.w,
                              right: 16.w,
                            ),
                          );
                          _cubit.getItineraryMe();
                        }
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamed(AppRouteConstant.itineraryProvinceSelection);
          },
          backgroundColor: AppColors.primaryBlue,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
