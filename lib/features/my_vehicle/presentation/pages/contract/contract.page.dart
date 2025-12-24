import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
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
      child: const _ContractView(),
    );
  }
}

class _ContractView extends StatefulWidget {
  const _ContractView();

  @override
  State<_ContractView> createState() => _ContractViewState();
}

class _ContractViewState extends State<_ContractView> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = eventBus.on<ContractRegisteredEvent>().listen((event) {
      if (mounted) {
        context.read<GetContractsCubit>().getContracts();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetContractsCubit, GetContractsState>(
      listener: (context, state) {
        if (state.status == GetContractsStatus.loaded) {
          final hasApprovedContract = state.contracts.any(
            (contract) => contract.status.toLowerCase() == 'approved',
          );

          if (hasApprovedContract) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushReplacementNamed(AppRouteConstant.vehicle);
          }
        }
      },
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
              return RefreshIndicator(
                onRefresh:
                    () => context.read<GetContractsCubit>().getContracts(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              AppLotties.empty,
                              width: 300.w,
                              height: 200.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              AppLocalizations.of(context)!.noContracts,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 24.h),
                            PrimaryButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamed(AppRouteConstant.createContract);
                              },
                              title: AppLocalizations.of(context)!.registerNow,
                              width: 200.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamed(AppRouteConstant.createContract);
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
                      Navigator.of(context, rootNavigator: true).pushNamed(
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
