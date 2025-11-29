import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_vehicles/get_vehicles_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_vehicles/get_vehicles_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/contract_card.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/vehicle_card.widget.dart';

class MyVehiclePage extends StatefulWidget {
  const MyVehiclePage({super.key});

  @override
  State<MyVehiclePage> createState() => _MyVehiclePageState();
}

class _MyVehiclePageState extends State<MyVehiclePage> {
  StreamSubscription? _contractEventSubscription;
  StreamSubscription? _vehicleEventSubscription;
  int? _currentContractId; // Track contractId hiện tại

  // Custom AppBar widget that uses BlocBuilder
  PreferredSizeWidget _buildDynamicAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 1),
      child: BlocBuilder<GetContractsCubit, GetContractsState>(
        builder: (context, state) => _buildAppBar(context, state),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Lắng nghe event contract registered
    _contractEventSubscription = eventBus.on<ContractRegisteredEvent>().listen((
      event,
    ) {
      if (mounted) {
        // Reset contractId để force reload vehicles với contract mới
        _currentContractId = null;
        // Refresh contracts khi có contract mới
        context.read<GetContractsCubit>().getContracts();
      }
    });

    // Lắng nghe event vehicle added
    _vehicleEventSubscription = eventBus.on<VehicleAddedEvent>().listen((
      event,
    ) {
      if (mounted) {
        // Reset GetVehiclesCubit về initial để trigger reload
        context.read<GetVehiclesCubit>().reset();
        // Refresh contracts để lấy contractId và totalVehicles mới nhất
        context.read<GetContractsCubit>().getContracts();
      }
    });
  }

  @override
  void dispose() {
    _contractEventSubscription?.cancel();
    _vehicleEventSubscription?.cancel();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, GetContractsState state) {
    // Tìm contract approved để hiển thị nút xem chi tiết
    int? approvedContractId;
    if (state is GetContractsSuccess && state.contracts.isNotEmpty) {
      final approvedContract = state.contracts.firstWhere(
        (contract) => contract.status == RentalContractStatus.approved,
        orElse: () => state.contracts.first,
      );
      if (approvedContract.status == RentalContractStatus.approved) {
        approvedContractId = approvedContract.id;
      }
    }

    return CustomAppBar(
      title: 'My Vehicle',
      showBackButton: false,
      actions: approvedContractId != null
          ? [
              IconButton(
                icon: Icon(
                  Icons.description_outlined,
                  color: AppColors.primaryBlue,
                  size: 24.sp,
                ),
                tooltip: 'Xem chi tiết hợp đồng',
                onPressed: () => _openContractDetail(approvedContractId!),
              ),
            ]
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildDynamicAppBar(),
      body: BlocBuilder<GetContractsCubit, GetContractsState>(
        builder: (context, state) {
          // Auto load data khi state còn là Initial
          if (state is GetContractsInitial) {
            // TODO: Get real userId from auth
            context.read<GetContractsCubit>().getContracts();
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetContractsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetContractsSuccess) {
            // Kiểm tra có contract approved không
            final approvedContract = state.contracts.firstWhere(
              (contract) => contract.status == RentalContractStatus.approved,
              orElse: () => state.contracts.first,
            );

            final hasApprovedContract =
                approvedContract.status == RentalContractStatus.approved;

            if (hasApprovedContract) {
              // Kiểm tra nếu contractId thay đổi thì reset vehicles
              if (_currentContractId != null &&
                  _currentContractId != approvedContract.id) {
                // ContractId đã thay đổi, cần reload vehicles
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    context.read<GetVehiclesCubit>().reset();
                  }
                });
              }
              // Cập nhật contractId hiện tại
              _currentContractId = approvedContract.id;

              // Load vehicles nếu có approved contract
              return BlocBuilder<GetVehiclesCubit, GetVehiclesState>(
                builder: (context, vehicleState) {
                  if (vehicleState is GetVehiclesInitial) {
                    // ✅ Load với contractId mới nhất từ API get contracts
                    context.read<GetVehiclesCubit>().getVehicles(
                      approvedContract.id,
                    );
                    return const Center(child: CircularProgressIndicator());
                  } else if (vehicleState is GetVehiclesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (vehicleState is GetVehiclesSuccess) {
                    return _buildVehiclesList(
                      vehicleState.vehicles,
                      approvedContract.id,
                    );
                  } else if (vehicleState is GetVehiclesEmpty) {
                    return _buildApprovedView(approvedContract.id);
                  } else {
                    return _buildApprovedView(approvedContract.id);
                  }
                },
              );
            } else {
              return _buildContractsList(state.contracts);
            }
          } else if (state is GetContractsFailure) {
            return _buildErrorView(state.errorMessage);
          } else {
            // GetContractsEmpty
            return _buildEmptyView();
          }
        },
      ),
    );
  }

  Widget _buildVehiclesList(vehicles, contractId) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetVehiclesCubit>().getVehicles(contractId);
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add Vehicle Button
            ElevatedButton(
              onPressed: () async {
                // ✅ Dùng root navigator để mở fullscreen (lên cả bottom bar)
                final result = await Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(
                  AppRouteConstant.addVehicle,
                  arguments: contractId, // ✅ Truyền contractId thật
                );
                if (mounted && result == true) {
                  context.read<GetVehiclesCubit>().getVehicles(contractId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primaryWhite,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Add Vehicle',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Vehicles list
            Text(
              'Your Vehicles',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            ...vehicles
                .map(
                  (vehicle) => VehicleCard(
                    vehicle: vehicle,
                    onTap: () => _openVehicleDetail(vehicle.licensePlate),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovedView(int contractId) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetVehiclesCubit>().getVehicles(contractId);
      },
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_road,
                  size: 64.sp,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(height: 24.h),
              // Title
              Text(
                'Ready to Add Vehicles',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.h),
              // Description
              Text(
                'Your contract has been approved! Start adding your vehicles to earn money from rentals.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              // Add Vehicle Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // ✅ Dùng root navigator để mở fullscreen (lên cả bottom bar)
                    final result = await Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(
                      AppRouteConstant.addVehicle,
                      arguments: contractId, // ✅ Truyền contractId thật
                    );
                    // Refresh nếu thêm vehicle thành công
                    if (mounted && result == true) {
                      context.read<GetVehiclesCubit>().getVehicles(contractId);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primaryWhite,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Add Vehicle',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Information card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.secondaryGrey,
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.verified,
                            color: AppColors.primaryGreen,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Contract Approved!',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'What you can do now:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.add_circle_outline,
                      text: 'Add unlimited vehicles to your account',
                    ),
                    SizedBox(height: 8.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.camera_alt_outlined,
                      text: 'Upload clear photos and documentation',
                    ),
                    SizedBox(height: 8.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.attach_money,
                      text: 'Set your own rental prices',
                    ),
                    SizedBox(height: 8.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.visibility_outlined,
                      text: 'Your vehicles will be visible to customers',
                    ),
                    SizedBox(height: 8.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.trending_up,
                      text: 'Start earning from the first rental',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContractsList(contracts) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetContractsCubit>().getContracts();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: contracts.length,
        itemBuilder: (context, index) {
          return ContractCard(
            contract: contracts[index],
            onTap: () => _openContractDetail(contracts[index].id),
          );
        },
      ),
    );
  }

  Future<void> _openContractDetail(int contractId) async {
    await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(
      AppRouteConstant.contractDetail,
      arguments: contractId,
    );
  }

  Future<void> _openVehicleDetail(String licensePlate) async {
    await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(
      AppRouteConstant.vehicleDetail,
      arguments: licensePlate,
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 64.sp,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 24.h),
            // Title
            Text(
              'No Rental Contract Yet',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            // Description
            Text(
              'Register a rental contract before listing your vehicles for rent.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(AppRouteConstant.vehicleRentalRegister);
                  if (mounted && result == true) {
                    // Event bus già xử lý refresh
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: AppColors.primaryWhite,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Register Rental Contract',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Information card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why register a rental contract first?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildBenefitItem(
                    context,
                    icon: Icons.edit_document,
                    text: 'Provide owner information once and reuse it later',
                  ),
                  SizedBox(height: 8.h),
                  _buildBenefitItem(
                    context,
                    icon: Icons.security,
                    text: 'Enable Traveline to verify payouts and legal docs',
                  ),
                  SizedBox(height: 8.h),
                  _buildBenefitItem(
                    context,
                    icon: Icons.garage_outlined,
                    text: 'Unlock the ability to list unlimited vehicles',
                  ),
                  SizedBox(height: 8.h),
                  _buildBenefitItem(
                    context,
                    icon: Icons.support_agent,
                    text: 'Get dedicated support for future rentals',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.primaryRed),
            SizedBox(height: 16.h),
            Text(
              'Error',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            Text(
              errorMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<GetContractsCubit>().getContracts();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Retry',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primaryBlue),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
          ),
        ),
      ],
    );
  }
}
