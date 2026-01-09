import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/card/vehicle_card.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/car_rental/data/models/car_search_request.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/search_car/search_car_cubit.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/search_car/search_car_state.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/car_list_shimmer.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

class CarListPage extends StatelessWidget {
  const CarListPage({super.key});

  void _navigateToCarDetailsPage(BuildContext context, String licensePlate) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.carDetails, arguments: licensePlate);
  }

  void _navigateToCreateRentalBillPage(
    BuildContext context,
    RentalVehicle vehicle,
    String? rentalType,
    DateTime? startDate,
    String? locationAddress,
    double? latitude,
    double? longitude,
  ) {
    if (rentalType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectRentType)),
      );
      return;
    }
    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRouteConstant.createCarRentalBill,
      arguments: {
        'vehicle': vehicle,
        'rentalType': rentalType,
        'initialStartDate': startDate ?? DateTime.now(),
        'locationAddress': locationAddress,
        'pickupLatitude': latitude,
        'pickupLongitude': longitude,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final request = args['request'] as CarSearchRequest?;
    final locationAddress = args['locationAddress'] as String?;
    final latitude = args['latitude'] as double?;
    final longitude = args['longitude'] as double?;

    return BlocProvider(
      create: (context) {
        final cubit = sl<SearchCarCubit>();
        if (request != null) {
          cubit.searchCars(request);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.carList,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<SearchCarCubit, SearchCarState>(
          builder: (context, state) {
            if (state.status == SearchCarStatus.loading) {
              return const CarListShimmer();
            }

            if (state.status == SearchCarStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.errorOccurred,
                ),
              );
            }

            if (state.cars.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noData));
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.cars.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final car = state.cars[index];
                return VehicleCard(
                  name:
                      "${car.vehicleCatalog?.brand} ${car.vehicleCatalog?.model}",
                  price:
                      (request?.rentalType == RentalType.daily
                              ? car.pricePerDay
                              : car.pricePerHour)
                          .toInt(),
                  imageUrl: car.vehicleCatalog?.photo ?? '',
                  seats: car.vehicleCatalog?.seatingCapacity ?? 4,
                  priceLabel:
                      request?.rentalType == RentalType.daily
                          ? AppLocalizations.of(context)!.day
                          : AppLocalizations.of(context)!.hour,
                  onDetail:
                      () =>
                          _navigateToCarDetailsPage(context, car.licensePlate),
                  onRent:
                      () => _navigateToCreateRentalBillPage(
                        context,
                        car,
                        request?.rentalType?.name,
                        request?.startDate,
                        locationAddress,
                        latitude,
                        longitude,
                      ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
