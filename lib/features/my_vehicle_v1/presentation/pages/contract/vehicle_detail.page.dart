import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/data/models/vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/presentation/bloc/vehicle_detail/vehicle_detail_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/presentation/bloc/vehicle_detail/vehicle_detail_state.dart';

class VehicleDetailPage extends StatefulWidget {
  final String licensePlate;

  const VehicleDetailPage({super.key, required this.licensePlate});

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  final _priceFormat = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleDetailCubit>().fetchVehicle(widget.licensePlate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.vehicleTitle(widget.licensePlate),
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: BlocBuilder<VehicleDetailCubit, VehicleDetailState>(
        builder: (context, state) {
          if (state is VehicleDetailLoading || state is VehicleDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleDetailFailure) {
            return _buildError(state.message);
          } else if (state is VehicleDetailSuccess) {
            return _buildDetail(state.vehicle);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_filled,
              size: 56.sp,
              color: AppColors.primaryRed,
            ),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.cannotLoadVehicleInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed:
                  () => context.read<VehicleDetailCubit>().fetchVehicle(
                    widget.licensePlate,
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.primaryWhite,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(Vehicle vehicle) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(vehicle),
          SizedBox(height: 20.h),
          _buildSection(AppLocalizations.of(context)!.vehicleInfo, [
            _InfoTile(
              label: AppLocalizations.of(context)!.vehicleType,
              value: _titleCase(vehicle.vehicleCatalog?.type ?? '—'),
              icon: Icons.directions_car_filled_outlined,
            ),
            _InfoTile(
              label: AppLocalizations.of(context)!.brandAndModel,
              value: _vehicleName(vehicle),
              icon: Icons.badge_outlined,
            ),
            _InfoTile(
              label: AppLocalizations.of(context)!.color,
              value: vehicle.vehicleCatalog?.color ?? '—',
              icon: Icons.palette_outlined,
            ),
            _InfoTile(
              label: AppLocalizations.of(context)!.numberOfSeats,
              value: vehicle.vehicleCatalog?.seatingCapacity?.toString() ?? '—',
              icon: Icons.event_seat_outlined,
            ),
          ]),
          _buildSection(AppLocalizations.of(context)!.priceAndPerformance, [
            _InfoTile(
              label: AppLocalizations.of(context)!.pricePerHour,
              value: _formatPrice(vehicle.pricePerHour),
              icon: Icons.access_time,
            ),
            _InfoTile(
              label: AppLocalizations.of(context)!.pricePerDay,
              value: _formatPrice(vehicle.pricePerDay),
              icon: Icons.calendar_month_outlined,
            ),
            _InfoTile(
              label: AppLocalizations.of(context)!.totalRentals,
              value: '${vehicle.totalRentals}',
              icon: Icons.swap_horiz_rounded,
            ),
            _InfoTile(
              label: AppLocalizations.of(context)!.averageRating,
              value: vehicle.averageRating.toStringAsFixed(1),
              icon: Icons.star_rate_rounded,
            ),
          ]),
          _buildSection(AppLocalizations.of(context)!.statusAndRequirements, [
            _InfoTile(
              label: AppLocalizations.of(context)!.approvalStatus,
              value: _statusLabel(vehicle.status),
              icon: Icons.verified_outlined,
            ),
            _InfoTile(
              label: AppLocalizations.of(context)!.available,
              value: _availabilityLabel(vehicle.availability),
              icon: Icons.shield_moon_outlined,
            ),
            if (vehicle.requirements?.isNotEmpty ?? false)
              _InfoTile(
                label: AppLocalizations.of(context)!.requirements,
                value: vehicle.requirements!,
                icon: Icons.fact_check_outlined,
              ),
            if (vehicle.rejectedReason?.isNotEmpty ?? false)
              _InfoTile(
                label: AppLocalizations.of(context)!.rejectionReasonLabel,
                value: vehicle.rejectedReason!,
                icon: Icons.report_problem_outlined,
              ),
            _InfoTile(
              label: AppLocalizations.of(context)!.lastUpdated,
              value: _formatDate(vehicle.updatedAt ?? vehicle.createdAt),
              icon: Icons.schedule_outlined,
            ),
          ]),
          if (vehicle.description?.isNotEmpty ?? false)
            _buildSection(AppLocalizations.of(context)!.description, [
              Text(
                vehicle.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ]),
        ],
      ),
    );
  }

  Widget _buildHeader(Vehicle vehicle) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  vehicle.vehicleCatalog?.type == 'car'
                      ? Icons.directions_car_filled
                      : Icons.two_wheeler,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.licensePlate,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _vehicleName(vehicle),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 10.h,
            children: [
              _StatusChip(
                label: _statusLabel(vehicle.status),
                background: _statusColor(vehicle.status),
              ),
              _StatusChip(
                label: _availabilityLabel(vehicle.availability),
                background: _availabilityColor(vehicle.availability),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16.h),
          ...children
              .expand((widget) => [widget, SizedBox(height: 14.h)])
              .toList()
            ..removeLast(),
        ],
      ),
    );
  }

  String _vehicleName(Vehicle vehicle) {
    final parts =
        [vehicle.vehicleCatalog?.brand, vehicle.vehicleCatalog?.model]
            .whereType<String>()
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList();
    final composed = parts.join(' ').trim();
    return composed.isEmpty
        ? AppLocalizations.of(context)!.rentalVehicleDefault
        : composed;
  }

  String _formatPrice(double price) {
    if (price <= 0) return '—';
    return '${_priceFormat.format(price)} đ';
  }

  String _titleCase(String value) {
    if (value.isEmpty || value == '—') return value.isEmpty ? '—' : value;
    return value[0].toUpperCase() + value.substring(1);
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '—';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _statusLabel(RentalVehicleApprovalStatus status) {
    switch (status) {
      case RentalVehicleApprovalStatus.approved:
        return AppLocalizations.of(context)!.approved;
      case RentalVehicleApprovalStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case RentalVehicleApprovalStatus.rejected:
        return AppLocalizations.of(context)!.rejected;
      case RentalVehicleApprovalStatus.inactive:
        return AppLocalizations.of(context)!.locked;
    }
  }

  Color _statusColor(RentalVehicleApprovalStatus status) {
    switch (status) {
      case RentalVehicleApprovalStatus.approved:
        return AppColors.primaryGreen;
      case RentalVehicleApprovalStatus.pending:
        return AppColors.primaryOrange;
      case RentalVehicleApprovalStatus.rejected:
        return AppColors.primaryRed;
      case RentalVehicleApprovalStatus.inactive:
        return AppColors.primaryGrey;
    }
  }

  String _availabilityLabel(RentalVehicleAvailabilityStatus status) {
    switch (status) {
      case RentalVehicleAvailabilityStatus.available:
        return AppLocalizations.of(context)!.available;
      case RentalVehicleAvailabilityStatus.rented:
        return AppLocalizations.of(context)!.rented;
      case RentalVehicleAvailabilityStatus.maintenance:
        return AppLocalizations.of(context)!.maintenance;
    }
  }

  Color _availabilityColor(RentalVehicleAvailabilityStatus status) {
    switch (status) {
      case RentalVehicleAvailabilityStatus.available:
        return AppColors.primaryBlue;
      case RentalVehicleAvailabilityStatus.rented:
        return AppColors.primaryOrange;
      case RentalVehicleAvailabilityStatus.maintenance:
        return AppColors.primaryGrey;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.background});

  final String label;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
              ),
              SizedBox(height: 4.h),
              Text(
                value.isEmpty ? '—' : value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
