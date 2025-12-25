import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_my_vehicles/get_my_vehicles_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_my_vehicles/get_my_vehicles_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/contract_shimmer.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/vehicle_card.dart';
import 'package:tour_guide_app/service_locator.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetMyVehiclesCubit>()..getMyVehicles(),
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
    _subscription = eventBus.on<VehicleAddedEvent>().listen((event) {
      if (mounted) {
        context.read<GetMyVehiclesCubit>().getMyVehicles();
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
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.rentalVehicle,
        showBackButton: false,
      ),
      body: BlocBuilder<GetMyVehiclesCubit, GetMyVehiclesState>(
        builder: (context, state) {
          if (state.status == GetMyVehiclesStatus.loading) {
            return const ContractShimmer(); // Reuse contract shimmer or create specific one
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
              onRefresh:
                  () => context.read<GetMyVehiclesCubit>().getMyVehicles(),
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
              itemCount:
                  state.vehicles.length +
                  1, // +1 for "Add Vehicle" button at bottom
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
      ),
    );
  }
}
