import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/get_draft_itineraries/get_draft_itineraries_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/explore_itinerary_card.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/shimmer_itinerary_list.dart';

class ItineraryExplorePage extends StatefulWidget {
  const ItineraryExplorePage({super.key});

  @override
  State<ItineraryExplorePage> createState() => _ItineraryExplorePageState();
}

class _ItineraryExplorePageState extends State<ItineraryExplorePage> {
  late GetDraftItinerariesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<GetDraftItinerariesCubit>()..getDraftItineraries();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: 'Explore Itineraries',
          showBackButton: true,
          backgroundColor: AppColors.backgroundColor,
          onBackPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: BlocBuilder<GetDraftItinerariesCubit, GetDraftItinerariesState>(
          builder: (context, state) {
            if (state is GetDraftItinerariesLoading) {
              return const ShimmerItineraryList();
            } else if (state is GetDraftItinerariesFailure) {
              return Center(child: Text(state.message));
            } else if (state is GetDraftItinerariesSuccess) {
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
                  await _cubit.getDraftItineraries();
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
                    String imageUrl =
                        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop';

                    if (item.stops.isNotEmpty) {
                      for (final stop in item.stops) {
                        if (stop.destination?.photos != null &&
                            stop.destination!.photos!.isNotEmpty) {
                          imageUrl = stop.destination!.photos!.first;
                          break;
                        }
                      }
                    }

                    return ExploreItineraryCard(
                      title: item.name,
                      dateRange: '${item.startDate} - ${item.endDate}',
                      destinationCount: item.stops.length.toString(),
                      status: item.status,
                      imageUrl: imageUrl,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRouteConstant.itineraryDetail,
                          arguments: item.id,
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
