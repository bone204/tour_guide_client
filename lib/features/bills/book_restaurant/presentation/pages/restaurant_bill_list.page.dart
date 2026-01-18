import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/presentation/bloc/get_restaurant_bills/get_restaurant_bills_cubit.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/presentation/bloc/get_restaurant_bills/get_restaurant_bills_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/presentation/widgets/restaurant_bill_card.dart';

class RestaurantBillListPage extends StatelessWidget {
  const RestaurantBillListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GetRestaurantBillsCubit>()..getBookings(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.restaurantBills,
          showBackButton: true,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocBuilder<GetRestaurantBillsCubit, GetRestaurantBillsState>(
          builder: (context, state) {
            if (state is GetRestaurantBillsLoading) {
              return _buildShimmerList();
            } else if (state is GetRestaurantBillsFailure) {
              return Center(child: Text(state.message));
            } else if (state is GetRestaurantBillsLoaded) {
              final bookings = state.bookings;
              if (bookings.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noBookingsFound),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GetRestaurantBillsCubit>().getBookings();
                },
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];

                    return RestaurantBillCard(
                      booking: booking,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouteConstant.restaurantBillDetail,
                          arguments: booking.id,
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

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150.w,
                        height: 16.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 100.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80.w,
                            height: 12.h,
                            color: Colors.white,
                          ),
                          Container(
                            width: 60.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
