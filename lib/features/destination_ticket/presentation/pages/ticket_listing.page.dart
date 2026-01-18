import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination_ticket/presentation/bloc/ticket_listing/ticket_listing_cubit.dart';
import 'package:tour_guide_app/features/destination_ticket/presentation/bloc/ticket_listing/ticket_listing_state.dart';
import 'package:tour_guide_app/features/destination_ticket/presentation/widgets/ticket_card.widget.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:shimmer/shimmer.dart';

class TicketListingPage extends StatefulWidget {
  const TicketListingPage({super.key});

  @override
  State<TicketListingPage> createState() => _TicketListingPageState();
}

class _TicketListingPageState extends State<TicketListingPage> {
  late TicketListingCubit _cubit;
  String? _selectedProvince;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = sl<TicketListingCubit>();
    _fetchTickets();
  }

  void _fetchTickets() {
    _cubit.getTickets(
      province: _selectedProvince,
      q: _searchController.text.isNotEmpty ? _searchController.text : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: "Vé tham quan",
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: BlocBuilder<TicketListingCubit, TicketListingState>(
                builder: (context, state) {
                  if (state is TicketListingLoading) {
                    return _buildShimmerLoading();
                  }
                  if (state is TicketListingFailure) {
                    return Center(child: Text(state.message));
                  }
                  if (state is TicketListingSuccess) {
                    final destinations = state.destinations;
                    if (destinations.isEmpty) {
                      return const Center(
                        child: Text("Không tìm thấy địa điểm bán vé"),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async => _fetchTickets(),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.w),
                        child: MasonryGridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12.h,
                          crossAxisSpacing: 12.w,
                          itemCount: destinations.length,
                          itemBuilder: (context, index) {
                            final dest = destinations[index];
                            return TicketCard(
                              name: dest.name,
                              location: dest.province ?? '',
                              price: dest.ticketPrice ?? 0,
                              rating: dest.rating,
                              openTime: dest.openTime,
                              closeTime: dest.closeTime,
                              imageUrl:
                                  (dest.photos != null &&
                                      dest.photos!.isNotEmpty)
                                  ? dest.photos!.first
                                  : "https://via.placeholder.com/150",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouteConstant.ticketBooking,
                                  arguments: dest,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.primaryWhite,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onSubmitted: (_) => _fetchTickets(),
            decoration: InputDecoration(
              hintText: "Tìm kiếm điểm tham quan...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.primaryGrey.withOpacity(0.1),
            ),
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(null, "Tất cả"),
                _buildFilterChip("Hồ Chí Minh", "TP. HCM"),
                _buildFilterChip("Hà Nội", "Hà Nội"),
                _buildFilterChip("Đà Nẵng", "Đà Nẵng"),
                _buildFilterChip("Lâm Đồng", "Đà Lạt"),
                _buildFilterChip("Kiên Giang", "Phú Quốc"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String? value, String label) {
    final isSelected = _selectedProvince == value;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedProvince = value;
            });
            _fetchTickets();
          }
        },
        selectedColor: AppColors.primaryOrange,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primaryWhite : AppColors.primaryBlack,
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
