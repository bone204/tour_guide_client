import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'My Vehicle',
        showBackButton: false,
      ),
      body: BlocBuilder<GetContractsCubit, GetContractsState>(
        builder: (context, state) {
          // Auto load data khi state còn là Initial
          if (state is GetContractsInitial) {
            // TODO: Get real userId from auth
            context.read<GetContractsCubit>().getContracts(1);
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetContractsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetContractsSuccess) {
            // Kiểm tra có contract approved không
            final approvedContract = state.contracts.firstWhere(
              (contract) => contract.status?.toLowerCase() == 'approved',
              orElse: () => state.contracts.first,
            );
            
            final hasApprovedContract = approvedContract.status?.toLowerCase() == 'approved';
            
            if (hasApprovedContract) {
              // Load vehicles nếu có approved contract
              return BlocBuilder<GetVehiclesCubit, GetVehiclesState>(
                builder: (context, vehicleState) {
                  if (vehicleState is GetVehiclesInitial) {
                    context.read<GetVehiclesCubit>().getVehicles(approvedContract.id);
                    return const Center(child: CircularProgressIndicator());
                  } else if (vehicleState is GetVehiclesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (vehicleState is GetVehiclesSuccess) {
                    return _buildVehiclesList(vehicleState.vehicles, approvedContract.id);
                  } else if (vehicleState is GetVehiclesEmpty) {
                    return _buildApprovedView();
                  } else {
                    return _buildApprovedView();
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
                final result = await Navigator.of(context).pushNamed(
                  AppRouteConstant.addVehicle,
                );
                if (result == true) {
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: 12.h),
            ...vehicles.map((vehicle) => VehicleCard(
              vehicle: vehicle,
              onTap: () {
                // TODO: Navigate to vehicle detail
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovedView() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetContractsCubit>().getContracts(1);
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              // Add Vehicle Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).pushNamed(
                      AppRouteConstant.addVehicle,
                    );
                    // Refresh nếu thêm vehicle thành công
                    if (result == true) {
                      context.read<GetContractsCubit>().getContracts(1);
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
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
        context.read<GetContractsCubit>().getContracts(1);
      },
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: contracts.length,
        itemBuilder: (context, index) {
          return ContractCard(
            contract: contracts[index],
            onTap: () {
              // TODO: Navigate to contract detail
            },
          );
        },
      ),
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
                Icons.directions_car_outlined,
                size: 64.sp,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 24.h),
            // Title
            Text(
              'No Vehicles Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: 12.h),
            // Description
            Text(
              'Start earning by registering your vehicle for rental services',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRouteConstant.vehicleRentalRegister,
                  );
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
                      'Register Vehicle',
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
                  Text(
                    'Benefits of registering your vehicle:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  SizedBox(height: 12.h),
                  _buildBenefitItem(
                    context,
                    icon: Icons.attach_money,
                    text: 'Earn extra income from your vehicle',
                  ),
                  SizedBox(height: 8.h),
                  _buildBenefitItem(
                    context,
                    icon: Icons.verified_user,
                    text: 'Insurance coverage for all rentals',
                  ),
                  SizedBox(height: 8.h),
                  _buildBenefitItem(
                    context,
                    icon: Icons.support_agent,
                    text: '24/7 customer support',
                  ),
                  SizedBox(height: 8.h),
                  _buildBenefitItem(
                    context,
                    icon: Icons.schedule,
                    text: 'Flexible rental schedule',
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
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.primaryRed,
            ),
            SizedBox(height: 16.h),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<GetContractsCubit>().getContracts(1);
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

  Widget _buildBenefitItem(BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppColors.primaryBlue,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSubtitle,
                ),
          ),
        ),
      ],
    );
  }
}
