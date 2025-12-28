import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/eatery/presentation/bloc/get_eateries/get_eateries_cubit.dart';
import 'package:tour_guide_app/features/eatery/presentation/widgets/eatery_card.widget.dart';
import 'package:tour_guide_app/features/eatery/presentation/widgets/eatery_list_shimmer.widget.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';

class EateryListPage extends StatefulWidget {
  const EateryListPage({super.key});

  @override
  State<EateryListPage> createState() => _EateryListPageState();
}

class _EateryListPageState extends State<EateryListPage> {
  late final GetEateriesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<GetEateriesCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(AppLocalizations.of(context)!.detectingLocation),
                ),
              ],
            ),
          );
        },
      );
      // Simulate delay then close dialog
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context); // Close dialog
        _cubit.getEateries();
      }
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.famousEateries,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
          actions: [
            BlocBuilder<GetEateriesCubit, GetEateriesState>(
              bloc: _cubit, // Using the local instance
              builder: (context, state) {
                if (state is GetEateriesSuccess && state.eateries.isNotEmpty) {
                  return IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteConstant.eateryWheel,
                        arguments: state.eateries,
                      );
                    },
                    icon: Icon(
                      Icons.settings_suggest_outlined,
                      color: AppColors.primaryBlack,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<GetEateriesCubit, GetEateriesState>(
          builder: (context, state) {
            if (state is GetEateriesLoading) {
              return const EateryListShimmer();
            } else if (state is GetEateriesFailure) {
              return Center(child: Text(state.message));
            } else if (state is GetEateriesSuccess) {
              if (state.eateries.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noEateriesFound),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(24.w),
                itemCount: state.eateries.length,
                itemBuilder: (context, index) {
                  return EateryCard(
                    eatery: state.eateries[index],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteConstant.eateryDetail,
                        arguments: state.eateries[index].id,
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
