import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class DestinationSelectionPage extends StatelessWidget {
  final String province;
  final int itineraryId;

  const DestinationSelectionPage({
    super.key,
    required this.province,
    required this.itineraryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<GetDestinationCubit>()
                ..getDestinations(query: DestinationQuery(province: province)),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Select Destination',
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<GetDestinationCubit, GetDestinationState>(
          builder: (context, state) {
            if (state is GetDestinationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetDestinationError) {
              return Center(child: Text(state.message));
            } else if (state is GetDestinationLoaded) {
              if (state.destinations.isEmpty) {
                return const Center(child: Text('No destinations found'));
              }
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount:
                    state.destinations.length + (state.hasReachedEnd ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= state.destinations.length) {
                    context.read<GetDestinationCubit>().loadMoreDestinations();
                    return const Center(child: CircularProgressIndicator());
                  }
                  final destination = state.destinations[index];
                  return _buildDestinationCard(context, destination);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDestinationCard(BuildContext context, Destination destination) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          AppRouteConstant.addStop,
          arguments: {'itineraryId': itineraryId, 'destination': destination},
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: Image.network(
                destination.photos!.first,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: 100.w,
                      height: 100.h,
                      color: Colors.grey,
                      child: const Icon(Icons.error),
                    ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14.sp,
                          color: AppColors.primaryGrey,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            destination.specificAddress!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSubtitle),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primaryGrey),
            SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }
}
