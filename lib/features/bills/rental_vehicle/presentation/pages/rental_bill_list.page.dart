import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_my_rental_bills/get_my_rental_bills_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_my_rental_bills/rental_bill_list_state.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/widgets/rental_bill_card.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/widgets/rental_bill_list_shimmer.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart'; // Add this

class RentalBillListPage extends StatefulWidget {
  const RentalBillListPage({super.key});

  @override
  State<RentalBillListPage> createState() => _RentalBillListPageState();
}

class _RentalBillListPageState extends State<RentalBillListPage> {
  final RefreshController _refreshController = RefreshController();

  void _onRefresh(BuildContext context) {
    context.read<GetMyRentalBillsCubit>().loadMyBills();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetMyRentalBillsCubit>()..loadMyBills(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.myRentalBills,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocListener<GetMyRentalBillsCubit, RentalBillListState>(
          listener: (context, state) {
            if (state.status == RentalBillListStatus.success ||
                state.status == RentalBillListStatus.failure) {
              _refreshController.refreshCompleted();
            }
          },
          child: BlocBuilder<GetMyRentalBillsCubit, RentalBillListState>(
            builder: (context, state) {
              if (state.status == RentalBillListStatus.loading) {
                return const RentalBillListShimmer();
              } else if (state.status == RentalBillListStatus.failure &&
                  state.bills.isEmpty) {
                return Center(child: Text(state.errorMessage ?? 'Error'));
              }

              final Widget content;
              if (state.bills.isEmpty) {
                content = Center(
                  child: Text(AppLocalizations.of(context)!.noRentalBills),
                );
              } else {
                content = ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.bills.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final bill = state.bills[index];
                    return RentalBillCard(
                      bill: bill,
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            AppRouteConstant.rentalBillDetail,
                            arguments: bill.id,
                          );
                      },
                    );
                  },
                );
              }

              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () => _onRefresh(context),
                child: content,
              );
            },
          ),
        ),
      ),
    );
  }
}
