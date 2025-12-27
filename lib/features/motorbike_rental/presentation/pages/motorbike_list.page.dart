import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/card/vehicle_card.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/motorbike_search_request.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/search_motorbike/search_motorbike_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/search_motorbike/search_motorbike_state.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/widgets/motorbike_list_shimmer.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

class MotorbikeListPage extends StatelessWidget {
  const MotorbikeListPage({super.key});

  void _navigateToMotorbikeDetailsPage(
    BuildContext context,
    String licensePlate,
  ) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.motorbikeDetails, arguments: licensePlate);
  }

  void _navigateToCreateRentalBillPage(
    BuildContext context,
    RentalVehicle vehicle,
    String? rentalType,
    DateTime? startDate,
  ) {
    if (rentalType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectRentType)),
      );
      return;
    }
    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRouteConstant.createRentalBill,
      arguments: {
        'vehicle': vehicle,
        'rentalType': rentalType,
        'initialStartDate': startDate ?? DateTime.now(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request =
        ModalRoute.of(context)!.settings.arguments as MotorbikeSearchRequest?;

    return BlocProvider(
      create: (context) {
        final cubit = sl<SearchMotorbikeCubit>();
        if (request != null) {
          cubit.searchMotorbikes(request);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.motorbikeList,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<SearchMotorbikeCubit, SearchMotorbikeState>(
          builder: (context, state) {
            if (state.status == SearchMotorbikeStatus.loading) {
              return const MotorbikeListShimmer();
            }

            if (state.status == SearchMotorbikeStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.errorOccurred,
                ),
              );
            }

            if (state.motorbikes.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noData));
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.motorbikes.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final motorbike = state.motorbikes[index];
                return VehicleCard(
                  name:
                      "${motorbike.vehicleCatalog?.brand} ${motorbike.vehicleCatalog?.model}",
                  price:
                      (request?.rentalType == RentalType.daily
                              ? motorbike.pricePerDay
                              : motorbike.pricePerHour)
                          .toInt(),
                  imageUrl: motorbike.vehicleCatalog?.photo ?? '',
                  seats: 2,
                  priceLabel:
                      request?.rentalType == RentalType.daily
                          ? AppLocalizations.of(context)!.day
                          : AppLocalizations.of(context)!.hour,
                  onDetail:
                      () => _navigateToMotorbikeDetailsPage(
                        context,
                        motorbike.licensePlate,
                      ),
                  onRent:
                      () => _navigateToCreateRentalBillPage(
                        context,
                        motorbike,
                        request?.rentalType?.name,
                        request?.startDate,
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
