import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_search_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_state.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_card.widget.dart';

class HomeSearchPage extends StatefulWidget {
  const HomeSearchPage({super.key});

  // Static method to create with BlocProvider
  static Widget withProvider() {
    return BlocProvider(
      create: (context) => GetDestinationCubit(),
      child: const HomeSearchPage(),
    );
  }

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(value.trim());
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      return;
    }

    // Call API with search query
    context.read<GetDestinationCubit>().getDestinations(
      query: DestinationQuery(
        q: query,
        offset: 0,
        limit: 20,
        available: true,
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchAppBar(
        hintText: "Tìm kiếm địa điểm...",
        controller: _controller,
        onBack: () => Navigator.of(context).pop(),
        onSearchChanged: _onSearchChanged,
      ),
      body: BlocBuilder<GetDestinationCubit, GetDestinationState>(
        builder: (context, state) {
          if (state is GetDestinationLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            );
          }

          if (state is GetDestinationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.r,
                    color: AppColors.primaryRed,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is GetDestinationLoaded) {
            final destinations = state.destinations;

            if (destinations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64.r,
                      color: AppColors.textSubtitle.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      _controller.text.isEmpty
                          ? "Nhập từ khóa để tìm kiếm"
                          : "Không tìm thấy kết quả",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search result header
                  Text(
                    'Tìm thấy ${destinations.length} kết quả',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Grid of attraction cards
                  MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 16.w,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => DestinationDetailPage.withProvider(
                                destinationId: destination.id,
                              ),
                            ),
                          );
                        },
                        child: AttractionCard(
                          imageUrl: destination.photos?.isNotEmpty == true
                              ? destination.photos!.first
                              : AppImage.defaultDestination,
                          title: destination.name,
                          location: destination.province ?? "Unknown",
                          rating: destination.rating ?? 0.0,
                          reviews: destination.userRatingsTotal ?? 0,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          // Initial state - show search hint
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 64.r,
                  color: AppColors.textSubtitle.withOpacity(0.3),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Tìm kiếm địa điểm du lịch",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Nhập tên địa điểm, tỉnh thành...",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSubtitle.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
