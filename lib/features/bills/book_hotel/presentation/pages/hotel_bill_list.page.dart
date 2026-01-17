import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/get_my_hotel_bills/get_my_hotel_bills_cubit.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/widgets/hotel_bill_card.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/widgets/hotel_bill_list_shimmer.dart';
import 'package:tour_guide_app/service_locator.dart';

class HotelBillListPage extends StatelessWidget {
  const HotelBillListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetMyHotelBillsCubit>()..getMyBills(),
      child: const _HotelBillListView(),
    );
  }
}

class _HotelBillListView extends StatelessWidget {
  const _HotelBillListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.rentalInformation,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocBuilder<GetMyHotelBillsCubit, GetMyHotelBillsState>(
        builder: (context, state) {
          if (state is GetMyHotelBillsLoading) {
            return const HotelBillListShimmer();
          } else if (state is GetMyHotelBillsFailure) {
            return Center(child: Text(state.message));
          } else if (state is GetMyHotelBillsSuccess) {
            if (state.bills.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noBookingsFound),
              ); // Reuse Empty widget later
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GetMyHotelBillsCubit>().getMyBills();
              },
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: state.bills.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final bill = state.bills[index];
                  return HotelBillCard(
                    bill: bill,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteConstant.hotelBillDetail,
                        arguments: bill.id,
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
