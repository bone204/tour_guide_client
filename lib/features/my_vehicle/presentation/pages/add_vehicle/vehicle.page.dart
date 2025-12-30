import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/widgets/rental_bill_list_shimmer.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_my_vehicles/get_my_vehicles_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_my_vehicles/get_my_vehicles_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/contract_shimmer.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/vehicle_card.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/owner_rental_request_card.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_owner_rental_bills/get_owner_rental_bills_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_owner_rental_bills/get_owner_rental_bills_state.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GetMyVehiclesCubit>()..getMyVehicles(),
        ),
        BlocProvider(
          create: (context) => sl<GetOwnerRentalBillsCubit>()..getBills(),
        ),
      ],
      child: const _VehicleView(),
    );
  }
}

class _VehicleView extends StatefulWidget {
  const _VehicleView();

  @override
  State<_VehicleView> createState() => _VehicleViewState();
}

class _VehicleViewState extends State<_VehicleView> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = eventBus.on<dynamic>().listen((event) {
      if (mounted) {
        if (event is VehicleAddedEvent || event is VehicleStatusChangedEvent) {
          context.read<GetMyVehiclesCubit>().getMyVehicles();
        } else if (event is RentalRequestUpdatedEvent) {
          context.read<GetOwnerRentalBillsCubit>().getBills();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.rentalVehicle,
          showBackButton: false,
          bottom: TabBar(
            indicatorColor: AppColors.primaryBlue,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: AppColors.textSubtitle,
            labelStyle: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.myVehicles),
              Tab(text: AppLocalizations.of(context)!.rentalRequests),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_MyVehiclesTab(), _RentalRequestsTab()],
        ),
      ),
    );
  }
}

class _MyVehiclesTab extends StatelessWidget {
  const _MyVehiclesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMyVehiclesCubit, GetMyVehiclesState>(
      builder: (context, state) {
        if (state.status == GetMyVehiclesStatus.loading) {
          return const ContractShimmer();
        }

        if (state.status == GetMyVehiclesStatus.error) {
          return Center(
            child: Text(
              state.message ?? AppLocalizations.of(context)!.errorOccurred,
            ),
          );
        }

        if (state.vehicles.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => context.read<GetMyVehiclesCubit>().getMyVehicles(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          AppLotties.empty,
                          width: 300.w,
                          height: 200.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalizations.of(context)!.noVehicles,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 24.h),
                        PrimaryButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamed(AppRouteConstant.addVehicle);
                          },
                          title: AppLocalizations.of(context)!.addVehicle,
                          width: 200.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<GetMyVehiclesCubit>().getMyVehicles(),
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: state.vehicles.length + 1,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              if (index == state.vehicles.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: PrimaryButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(AppRouteConstant.addVehicle);
                      },
                      title: AppLocalizations.of(context)!.addVehicle,
                      width: 200.w,
                    ),
                  ),
                );
              }
              final vehicle = state.vehicles[index];
              return VehicleCard(
                vehicle: vehicle,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRouteConstant.vehicleDetail,
                    arguments: vehicle.licensePlate,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _RentalRequestsTab extends StatelessWidget {
  const _RentalRequestsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOwnerRentalBillsCubit, GetOwnerRentalBillsState>(
      builder: (context, state) {
        if (state.status == GetOwnerRentalBillsStatus.loading) {
          return const RentalBillListShimmer();
        }

        if (state.status == GetOwnerRentalBillsStatus.error) {
          return Center(
            child: Text(
              state.message ?? AppLocalizations.of(context)!.errorOccurred,
            ),
          );
        }

        if (state.bills.isEmpty) {
          return RefreshIndicator(
            onRefresh:
                () => context.read<GetOwnerRentalBillsCubit>().getBills(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          AppLotties.empty,
                          width: 300.w,
                          height: 200.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalizations.of(context)!.noRentalRequests,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<GetOwnerRentalBillsCubit>().getBills(),
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: state.bills.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final bill = state.bills[index];
              return OwnerRentalRequestCard(
                bill: bill,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRouteConstant.ownerRentalRequestDetail,
                    arguments: bill.id,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
