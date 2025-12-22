import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class MyVehiclePage extends StatelessWidget {
  const MyVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetContractsCubit>()..getContracts(),
      child: BlocListener<GetContractsCubit, GetContractsState>(
        listener: (context, state) {
          if (state.status == GetContractsStatus.loaded) {
            final hasApprovedContract = state.contracts.any(
              (contract) => contract.status == 'approved',
            );

            if (hasApprovedContract) {
              Navigator.pushReplacementNamed(context, AppRouteConstant.vehicle);
            } else {
              Navigator.pushReplacementNamed(
                context,
                AppRouteConstant.contract,
              );
            }
          }
        },
        child: const Scaffold(body: Center()),
      ),
    );
  }
}
