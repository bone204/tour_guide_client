import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/car_detail/car_detail_cubit.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/car_detail/car_detail_state.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/car_info_item.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class CarDetailPage extends StatelessWidget {
  final String? licensePlate;

  const CarDetailPage({Key? key, this.licensePlate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<CarDetailCubit>();
        if (licensePlate != null) {
          cubit.getCarDetail(licensePlate!);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)?.carDetails ?? 'Chi tiết xe ô tô',
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<CarDetailCubit, CarDetailState>(
          builder: (context, state) {
            if (state.status == CarDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CarDetailStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.errorOccurred,
                ),
              );
            }

            final vehicle = state.vehicle;
            if (vehicle == null) {
              return Center(child: Text(AppLocalizations.of(context)!.noData));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 236.h,
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        child:
                            vehicle.vehicleCatalog?.photo != null
                                ? Image.network(
                                  vehicle.vehicleCatalog!.photo!,
                                  fit: BoxFit.contain,
                                )
                                : vehicle.vehicleRegistrationFront != null
                                ? Image.network(
                                  vehicle.vehicleRegistrationFront!,
                                  fit: BoxFit.contain,
                                )
                                : Image.asset(
                                  AppImage.defaultCar,
                                  fit: BoxFit.contain,
                                ),
                      ),
                      Positioned(
                        right: 12.w,
                        top: 12.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.star,
                                color: AppColors.primaryYellow,
                                width: 16.w,
                                height: 16.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                vehicle.averageRating.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.displayLarge
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vehicle.vehicleCatalog?.brand ?? ''} ${vehicle.vehicleCatalog?.model ?? ''}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontSize: 22.sp),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              vehicle.vehicleCatalog?.color ?? '',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSubtitle),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.primaryGrey.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.day,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSubtitle,
                                        ),
                                      ),
                                      Text(
                                        Formatter.currency(vehicle.pricePerDay),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          color: AppColors.primaryOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.w,
                                    height: 30.h,
                                    color: AppColors.primaryGrey.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.hour,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSubtitle,
                                        ),
                                      ),
                                      Text(
                                        Formatter.currency(
                                          vehicle.pricePerHour,
                                        ),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          color: AppColors.primaryOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 84.h,
                            autoPlay: true,
                            enableInfiniteScroll: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            viewportFraction: 0.4,
                            padEnds: false,
                          ),
                          items: [
                            CarInfoItem(
                              icon: AppIcons.seat,
                              text:
                                  '${vehicle.vehicleCatalog?.seatingCapacity ?? 4} ${AppLocalizations.of(context)!.seats}',
                            ),
                            CarInfoItem(
                              icon: AppIcons.setting,
                              text: _getLocalizedValue(
                                context,
                                vehicle.vehicleCatalog?.transmission ??
                                    'Automatic',
                              ),
                            ),
                            CarInfoItem(
                              icon: AppIcons.gasPump,
                              text: _getLocalizedValue(
                                context,
                                vehicle.vehicleCatalog?.fuelType ?? 'Gasoline',
                              ),
                            ),
                            CarInfoItem(
                              icon: AppIcons.speed,
                              text:
                                  '${vehicle.totalRentals} ${AppLocalizations.of(context)!.rentalCount}',
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Divider(height: 2.h, color: AppColors.primaryGrey),
                        SizedBox(height: 12.h),
                        if (vehicle.description != null &&
                            vehicle.description!.isNotEmpty) ...[
                          Text(
                            AppLocalizations.of(context)!.description,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primaryGrey.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              vehicle.description!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSubtitle,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        if (vehicle.requirements != null &&
                            vehicle.requirements!.isNotEmpty) ...[
                          Text(AppLocalizations.of(context)!.requirements),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primaryGrey.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              vehicle.requirements!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSubtitle,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getLocalizedValue(BuildContext context, String value) {
    if (value.toLowerCase() == 'manual' || value.toLowerCase() == 'số sàn') {
      return AppLocalizations.of(context)!.transmissionManual;
    } else if (value.toLowerCase() == 'automatic' ||
        value.toLowerCase() == 'tự động') {
      return AppLocalizations.of(context)!.transmissionAutomatic;
    } else if (value.toLowerCase() == 'gasoline' ||
        value.toLowerCase() == 'xăng') {
      return AppLocalizations.of(context)!.fuelGasoline;
    } else if (value.toLowerCase() == 'electric' ||
        value.toLowerCase() == 'điện') {
      return AppLocalizations.of(context)!.fuelElectric;
    }
    return value;
  }
}
