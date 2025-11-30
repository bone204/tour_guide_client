import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_state.dart';

class ProvinceSelectionPage extends StatefulWidget {
  const ProvinceSelectionPage({super.key});

  // Static method to create page with BlocProvider
  static Widget withProvider() {
    return BlocProvider(
      create: (context) => GetDestinationCubit()..getDestinations(
        query: DestinationQuery(offset: 0, limit: 200),
      ),
      child: const ProvinceSelectionPage(),
    );
  }

  @override
  State<ProvinceSelectionPage> createState() => _ProvinceSelectionPageState();
}

class _ProvinceSelectionPageState extends State<ProvinceSelectionPage> {
  String _searchQuery = '';
  
  // Map province names to icons and colors
  final Map<String, Map<String, dynamic>> _provinceStyles = {
    'Đà Nẵng': {'icon': Icons.beach_access, 'color': const Color(0xFF007BFF)},
    'Hà Nội': {'icon': Icons.account_balance, 'color': const Color(0xFFFF7029)},
    'Thành phố Hồ Chí Minh': {'icon': Icons.location_city, 'color': const Color(0xFF800080)},
    'Hồ Chí Minh': {'icon': Icons.location_city, 'color': const Color(0xFF800080)},
    'Nha Trang': {'icon': Icons.pool, 'color': const Color(0xFF4DA6FF)},
    'Hội An': {'icon': Icons.lightbulb, 'color': const Color(0xFFFFD336)},
    'Huế': {'icon': Icons.castle, 'color': const Color(0xFF77CC00)},
    'Phú Quốc': {'icon': Icons.wb_sunny, 'color': const Color(0xFF007BFF)},
    'Đà Lạt': {'icon': Icons.local_florist, 'color': const Color(0xFFFF69B4)},
    'Sa Pa': {'icon': Icons.terrain, 'color': const Color(0xFF77CC00)},
    'Vũng Tàu': {'icon': Icons.sailing, 'color': const Color(0xFF4DA6FF)},
    'Hạ Long': {'icon': Icons.directions_boat, 'color': const Color(0xFF007BFF)},
    'Ninh Bình': {'icon': Icons.landscape, 'color': const Color(0xFF77CC00)},
    'Quy Nhơn': {'icon': Icons.surfing, 'color': const Color(0xFF4DA6FF)},
    'Cần Thơ': {'icon': Icons.agriculture, 'color': const Color(0xFF77CC00)},
  };

  List<String> _getProvincesFromDestinations(GetDestinationLoaded state) {
    final provinces = <String>{};
    for (var destination in state.destinations) {
      if (destination.province != null && destination.province!.isNotEmpty) {
        provinces.add(destination.province!);
      }
    }
    return provinces.toList()..sort();
  }

  List<Map<String, dynamic>> _buildProvinceList(List<String> provinces) {
    return provinces.map((province) {
      // Try to find matching style, or use default
      final style = _provinceStyles[province] ?? 
                    _provinceStyles.entries.firstWhere(
                      (entry) => province.contains(entry.key) || entry.key.contains(province),
                      orElse: () => MapEntry('', {'icon': Icons.place, 'color': AppColors.primaryBlue}),
                    ).value;
      
      return {
        'name': province,
        'icon': style['icon'] as IconData,
        'color': style['color'] as Color,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _filterProvinces(List<Map<String, dynamic>> provinces) {
    if (_searchQuery.isEmpty) return provinces;
    return provinces
        .where((p) => (p['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.selectProvince,
        showBackButton: true,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: BlocBuilder<GetDestinationCubit, GetDestinationState>(
        builder: (context, state) {
          if (state is GetDestinationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetDestinationError) {
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
                    'Không thể tải danh sách tỉnh/thành phố',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GetDestinationCubit>().getDestinations(
                        query: DestinationQuery(offset: 0, limit: 200),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          if (state is GetDestinationLoaded) {
            final provinces = _getProvincesFromDestinations(state);
            final provinceList = _buildProvinceList(provinces);

            return Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: _buildProvinceGrid(provinceList),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm tỉnh/thành phố...',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSubtitle,
          ),
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
            borderSide: BorderSide(
              color: AppColors.secondaryGrey.withOpacity(0.3),
            ),
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

  Widget _buildProvinceGrid(List<Map<String, dynamic>> provinces) {
    final filteredProvinces = _filterProvinces(provinces);

    if (filteredProvinces.isEmpty) {
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
              'Không tìm thấy tỉnh/thành phố',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSubtitle,
              ),
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
      itemCount: filteredProvinces.length,
      itemBuilder: (context, index) {
        final province = filteredProvinces[index];
        return _ProvinceCard(
          name: province['name'] as String,
          icon: province['icon'] as IconData,
          color: province['color'] as Color,
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRouteConstant.itineraryDestinationSelection,
              arguments: province['name'],
            );
          },
        );
      },
    );
  }
}

class _ProvinceCard extends StatelessWidget {
  const _ProvinceCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryWhite,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primaryWhite,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


