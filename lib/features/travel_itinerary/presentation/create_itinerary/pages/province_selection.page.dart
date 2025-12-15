import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/create_itinerary/bloc/get_provinces/get_province_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/create_itinerary/bloc/get_provinces/get_province_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/create_itinerary/widgets/province_card.widget.dart';

class ProvinceSelectionPage extends StatefulWidget {
  const ProvinceSelectionPage({super.key});

  // Static method to create page with BlocProvider
  static Widget withProvider() {
    return BlocProvider(
      create: (context) => GetProvinceCubit()..getProvinces(search: null),
      child: const ProvinceSelectionPage(),
    );
  }

  @override
  State<ProvinceSelectionPage> createState() => _ProvinceSelectionPageState();
}

class _ProvinceSelectionPageState extends State<ProvinceSelectionPage> {
  List<Province> _getProvincesFromState(GetProvinceLoaded state) {
    final provinces = [...state.provinces];
    provinces.sort((a, b) => a.name.compareTo(b.name));
    return provinces;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.selectProvince,
          showBackButton: true,
          onBackPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: BlocBuilder<GetProvinceCubit, GetProvinceState>(
                builder: (context, state) {
                  if (state is GetProvinceLoading) {
                    return _buildProvinceSkeleton();
                  }
                  if (state is GetProvinceError) {
                    return Center(
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
                            AppLocalizations.of(context)!.somethingWentWrong,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.textPrimary),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<GetProvinceCubit>().getProvinces(
                                search: null,
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is GetProvinceLoaded) {
                    final provinces = _getProvincesFromState(state);
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<GetProvinceCubit>().getProvinces(
                          search: null,
                        );
                      },
                      child: _buildProvinceGrid(provinces),
                    );
                  }
                  // Initial state or unknown
                  return _buildProvinceSkeleton();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProvinceSkeleton() {
    // Hiển thị 6 skeleton card loading
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.3,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryGrey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16.r),
          ),
          margin: EdgeInsets.zero,
          child: Center(
            child: Container(
              width: 80.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.secondaryGrey.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.16),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          context.read<GetProvinceCubit>().getProvinces(search: value);
        },
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchProvinceHint,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textSubtitle,
            size: 22.sp,
          ),
          filled: true,
          fillColor: AppColors.backgroundColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.secondaryGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.secondaryGrey.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProvinceGrid(List<Province> provinces) {
    if (provinces.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64.sp,
              color: AppColors.textSubtitle,
            ),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.searchProvinceHint,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSubtitle),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.3,
      ),
      itemCount: provinces.length,
      itemBuilder: (context, index) {
        final province = provinces[index];
        // Lấy locale hiện tại
        final locale = Localizations.localeOf(context).languageCode;
        final displayName =
            (locale == 'vi' ||
                    province.nameEn == null ||
                    province.nameEn!.isEmpty)
                ? province.name
                : province.nameEn!;
        return ProvinceCard(
          province: province,
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRouteConstant.itineraryDestinationSelection,
              arguments: displayName,
            );
          },
        );
      },
    );
  }
}
