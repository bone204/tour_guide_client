import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_state.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/contract_card.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/contract_shimmer.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common_libs.dart';

class ContractPage extends StatelessWidget {
  const ContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetContractsCubit>()..getContracts(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.rentalContract,
          showBackButton: false,
        ),
        body: BlocBuilder<GetContractsCubit, GetContractsState>(
          builder: (context, state) {
            if (state.status == GetContractsStatus.loading) {
              return const ContractShimmer();
            }

            if (state.status == GetContractsStatus.error) {
              return Center(
                child: Text(
                  state.message ?? AppLocalizations.of(context)!.errorOccurred,
                ),
              );
            }

            final hasActiveContract = state.contracts.any(
              (c) => ['approved', 'pending'].contains(c.status.toLowerCase()),
            );

            if (state.contracts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 64.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)!.noContracts,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 24.h),
                    PrimaryButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouteConstant.vehicleRentalRegister,
                        );
                      },
                      title: AppLocalizations.of(context)!.registerNow,
                      width: 200.w,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<GetContractsCubit>().getContracts(),
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount:
                    state.contracts.length + (!hasActiveContract ? 1 : 0),
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  if (index == state.contracts.length) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: PrimaryButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRouteConstant.vehicleRentalRegister,
                            );
                          },
                          title: AppLocalizations.of(context)!.registerNow,
                          width: 200.w,
                        ),
                      ),
                    );
                  }
                  final contract = state.contracts[index];
                  return ContractCard(
                    contract: contract,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteConstant.contractDetail,
                        arguments: contract.id,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
