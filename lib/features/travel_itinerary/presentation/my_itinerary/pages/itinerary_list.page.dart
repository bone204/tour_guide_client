import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/bloc/get_itinerary_me/get_itinerary_me_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/itinerary_card.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/shimmer_itinerary_list.dart';

class ItineraryListPage extends StatelessWidget {
  const ItineraryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetItineraryMeCubit>()..getItineraryMe(),
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
                  child: Text(AppLocalizations.of(context)!.emptyItinerary),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<GetItineraryMeCubit>().getItineraryMe();
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
