import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/presentation/bloc/get_restaurant_bill_detail/get_restaurant_bill_detail_cubit.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/presentation/bloc/get_restaurant_bill_detail/get_restaurant_bill_detail_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class RestaurantBillDetailPage extends StatelessWidget {
  final int bookingId;

  const RestaurantBillDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<GetRestaurantBillDetailCubit>()..getBookingDetail(bookingId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.bookingDetails,
          showBackButton: true,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocBuilder<
          GetRestaurantBillDetailCubit,
          GetRestaurantBillDetailState
        >(
          builder: (context, state) {
            if (state is GetRestaurantBillDetailLoading) {
              return _buildShimmerDetail();
            } else if (state is GetRestaurantBillDetailFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            } else if (state is GetRestaurantBillDetailLoaded) {
              final booking = state.booking;
              final restaurant = booking.cooperation;
              final tables = booking.tables;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GetRestaurantBillDetailCubit>().getBookingDetail(
                    bookingId,
                  );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant Info Card
                      if (restaurant != null) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryWhite,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
            BoxShadow(
              color: AppColors.primaryGrey.withOpacity(0.25),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (restaurant.photo != null &&
                                  restaurant.photo!.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.r),
                                  ),
                                  child: Image.network(
                                    restaurant.photo!,
                                    width: double.infinity,
                                    height: 180.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 180.h,
                                        color: AppColors.secondaryGrey,
                                        child: Icon(
                                          Icons.restaurant,
                                          size: 64.sp,
                                          color: AppColors.textSubtitle,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (restaurant.address != null) ...[
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 16.sp,
                                            color: AppColors.textSubtitle,
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              restaurant.address!,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.textSubtitle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      // Booking Info Card
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGrey.withOpacity(0.25),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.bookingInfo,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 16.h),
                            _buildInfoRow(
                              context,
                              icon: AppIcons.star,
                              label: AppLocalizations.of(context)!.bookingCode,
                              value: booking.code ?? '-',
                            ),
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              context,
                              icon: AppIcons.restaurant,
                              label: AppLocalizations.of(context)!.table,
                              value:
                                  tables?.map((t) => t.name).join(', ') ?? '-',
                            ),
                            if (booking.checkInDate != null) ...[
                              SizedBox(height: 12.h),
                              _buildInfoRow(
                                context,
                                icon: AppIcons.calendar,
                                label: AppLocalizations.of(context)!.checkIn,
                                value: DateFormatter.formatDateTime(
                                  booking.checkInDate!,
                                ),
                              ),
                            ],
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              context,
                              icon: AppIcons.clock,
                              label: AppLocalizations.of(context)!.duration,
                              value:
                                  "${booking.durationMinutes ?? 60} ${Localizations.localeOf(context).languageCode == 'vi' ? 'phút' : 'mins'}",
                            ),
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              context,
                              icon: AppIcons.star,
                              label: AppLocalizations.of(context)!.status,
                              value: _getLocalizedStatus(
                                context,
                                booking.status ?? 'UNKNOWN',
                              ),
                              valueWidget: _buildStatusBadge(
                                context,
                                booking.status ?? '',
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Contact Info Card
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGrey.withOpacity(0.25),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.contactDetails,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 16.h),
                            _buildInfoRow(
                              context,
                              icon: AppIcons.user,
                              label:
                                  AppLocalizations.of(context)!.fullNameLabel,
                              value:
                                  booking.contactName ??
                                  booking.user?.username ??
                                  '-',
                            ),
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              context,
                              icon: AppIcons.contact,
                              label: AppLocalizations.of(context)!.phoneNumber,
                              value: booking.contactPhone ?? '-',
                            ),
                            if (booking.notes != null &&
                                booking.notes!.isNotEmpty) ...[
                              SizedBox(height: 16.h),
                              Divider(
                                height: 1.h,
                                color: AppColors.secondaryGrey.withOpacity(0.3),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.calendar,
                                    width: 20.sp,
                                    height: 20.sp,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.textSubtitle,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.notes,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSubtitle,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          booking.notes!,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildShimmerDetail() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
    Widget? valueWidget,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 20.sp,
          height: 20.sp,
          colorFilter: const ColorFilter.mode(
            AppColors.textSubtitle,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: AppColors.textSubtitle),
          ),
        ),
        valueWidget ??
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.displayLarge,
              textAlign: TextAlign.end,
            ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color color = _getStatusColor(status);
    String text = _getLocalizedStatus(context, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CONFIRMED':
        return AppColors.primaryGreen;
      case 'PENDING':
        return AppColors.primaryOrange;
      case 'CANCELLED':
        return AppColors.primaryRed;
      case 'COMPLETED':
        return AppColors.primaryBlue;
      default:
        return AppColors.textSubtitle;
    }
  }

  String _getLocalizedStatus(BuildContext context, String status) {
    switch (status) {
      case 'CONFIRMED':
        return AppLocalizations.of(context)!.statusConfirmed;
      case 'PENDING':
        return AppLocalizations.of(context)!.statusPending;
      case 'CANCELLED':
        return AppLocalizations.of(context)!.statusCancelled;
      case 'COMPLETED':
        return AppLocalizations.of(context)!.statusCompleted;
      default:
        return status;
    }
  }
}
