import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/vehicle_detail/vehicle_detail_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/vehicle_detail/vehicle_detail_state.dart';
// Reuse contract detail shimmer for now or create specific one
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/contract_detail_shimmer.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:intl/intl.dart';

class VehicleDetailPage extends StatelessWidget {
  final String licensePlate;

  const VehicleDetailPage({super.key, required this.licensePlate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<VehicleDetailCubit>()..getVehicleDetail(licensePlate),
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.vehicleDetail,
          showBackButton: true,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocBuilder<VehicleDetailCubit, VehicleDetailState>(
          builder: (context, state) {
            if (state.status == VehicleDetailStatus.loading) {
              return const ContractDetailShimmer();
            }

            if (state.status == VehicleDetailStatus.error) {
              return Center(
                child: Text(
                  state.message ?? AppLocalizations.of(context)!.errorOccurred,
                ),
              );
            }

            if (state.vehicle == null) {
              return const ContractDetailShimmer();
            }

            final vehicle = state.vehicle!;

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<VehicleDetailCubit>().getVehicleDetail(
                  licensePlate,
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Section
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vehicle.licensePlate,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  if (vehicle.createdAt.isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      _formatDate(vehicle.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey[500]),
                                    ),
                                  ],
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    vehicle.status,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: _getStatusColor(
                                      vehicle.status,
                                    ).withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(context, vehicle.status),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: _getStatusColor(vehicle.status),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (vehicle.status == 'rejected' &&
                              vehicle.rejectedReason != null)
                            Padding(
                              padding: EdgeInsets.only(top: 12.h),
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: AppColors.primaryRed.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: AppColors.primaryRed,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        vehicle.rejectedReason!,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.primaryRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Pricing Info
                    _buildSection(
                      context,
                      title: AppLocalizations.of(context)!.price,
                      children: [
                        _buildDetailRow(
                          context,
                          AppLocalizations.of(context)!.hourlyRent,
                          '${_formatCurrency(vehicle.pricePerHour)} đ',
                        ),
                        _buildDetailRow(
                          context,
                          AppLocalizations.of(context)!.dailyRent,
                          '${_formatCurrency(vehicle.pricePerDay)} đ',
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Vehicle Info
                    _buildSection(
                      context,
                      title: AppLocalizations.of(context)!.vehicleInfo,
                      children: [
                        if (vehicle.requirements != null &&
                            vehicle.requirements!.isNotEmpty)
                          _buildDetailRow(
                            context,
                            AppLocalizations.of(context)!.requirements,
                            vehicle.requirements!,
                          ),
                        if (vehicle.description != null &&
                            vehicle.description!.isNotEmpty)
                          _buildDetailRow(
                            context,
                            AppLocalizations.of(context)!.description,
                            vehicle.description!,
                          ),
                        if (vehicle.vehicleRegistrationFront != null &&
                            vehicle.vehicleRegistrationFront!.isNotEmpty)
                          _buildImageRow(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.vehicleRegistrationFrontPhoto,
                            vehicle.vehicleRegistrationFront!,
                          ),
                        if (vehicle.vehicleRegistrationBack != null &&
                            vehicle.vehicleRegistrationBack!.isNotEmpty)
                          _buildImageRow(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.vehicleRegistrationBackPhoto,
                            vehicle.vehicleRegistrationBack!,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
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
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.primaryGreen),
          ),
          Divider(height: 36.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(color: Colors.grey[600]),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageRow(BuildContext context, String label, String imageUrl) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              if (imageUrl.isNotEmpty) {
                showDialog(
                  context: context,
                  builder:
                      (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.zero,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            InteractiveViewer(
                              panEnabled: true,
                              boundaryMargin: const EdgeInsets.all(20),
                              minScale: 0.5,
                              maxScale: 4,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              top: 40,
                              right: 20,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      ),
                );
              }
            },
            child: Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.primaryGreen;
      case 'rejected':
        return AppColors.primaryRed;
      case 'pending':
        return AppColors.primaryOrange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppLocalizations.of(context)!.approved;
      case 'rejected':
        return AppLocalizations.of(context)!.rejected;
      case 'pending':
        return AppLocalizations.of(context)!.pending;
      default:
        return status;
    }
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty) return '';
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(amount);
  }
}
