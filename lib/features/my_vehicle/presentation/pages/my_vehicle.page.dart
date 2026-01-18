import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/vehicle.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/contract.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/vehicle_list_shimmer.dart';
import 'package:tour_guide_app/service_locator.dart';

class MyVehiclePage extends StatelessWidget {
  const MyVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetContractsCubit>()..getContracts(),
      child: BlocBuilder<GetContractsCubit, GetContractsState>(
        builder: (context, state) {
          if (state.status == GetContractsStatus.loading) {
            return const Scaffold(body: VehicleListShimmer());
          }

          if (state.status == GetContractsStatus.loaded) {
            final hasApprovedContract = state.contracts.any(
              (contract) => contract.status.toLowerCase() == 'approved',
            );

            if (hasApprovedContract) {
              return const VehiclePage();
            } else {
              // Reuse the existing cubit for ContractView
              return const ContractView();
            }
          }

          // Error or initial state -> show ContractView (it handles errors too) or error
          return const ContractView();
        },
      ),
    );
  }
}
