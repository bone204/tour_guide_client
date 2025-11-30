import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/pages/chat_bot.page.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/favorite_destinations_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_state.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/custom_appbar.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/custom_header.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/hotel_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/nearby_destination_list.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/popular_destination_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/restaurant_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/shimmer_widgets.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/voucher_carousel.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // Static method to create page with BlocProvider
  static Widget withProvider() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetDestinationCubit()..getDestinations(),
        ),
        BlocProvider(
          create: (context) => FavoriteDestinationsCubit()..loadFavorites(),
        ),
      ],
      child: const HomePage(),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  DateTime? _lastLoadMoreTime;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Khi scroll gần cuối (còn 500 pixels)
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 500) {
        _loadMoreIfNeeded();
      }
    });
  }

  void _loadMoreIfNeeded() {
    // Debounce: Chỉ load more sau 1 giây từ lần load trước
    final now = DateTime.now();
    if (_lastLoadMoreTime != null &&
        now.difference(_lastLoadMoreTime!).inSeconds < 1) {
      return;
    }

    final cubit = context.read<GetDestinationCubit>();
    final state = cubit.state;

    if (state is GetDestinationLoaded) {
      if (!state.hasReachedEnd && !state.isLoadingMore) {
        _lastLoadMoreTime = now;
        cubit.loadMoreDestinations();
      }
    }
  }

  Future<void> _onRefresh() async {
    // Reload tất cả các API địa điểm
    await Future.wait([
      context.read<GetDestinationCubit>().getDestinations(),
      context.read<FavoriteDestinationsCubit>().loadFavorites(),
    ]);
  }

  List<Widget> _buildContentSlivers(GetDestinationState state) {
    final isLoading = state is GetDestinationLoading ||
        state is GetDestinationInitial;
    
    if (isLoading) {
      return [
        SliverVoucherCarouselShimmer(),
        SliverPopularDestinationListShimmer(),
        SliverNearbyDestinationListShimmer(),
        SliverHotelNearbyDestinationListShimmer(),
        SliverRestaurantNearbyDestinationListShimmer(),
        SliverRestaurantNearbyAttractionListShimmer(),
      ];
    }
    
    return [
      SliverVoucherCarousel(),
      SliverPopularDestinationList(),
      SliverNearbyDestinationList(),
      SliverHotelNearbyDestinationList(),
      SliverRestaurantNearbyDestinationList(),
      SliverRestaurantNearbyAttractionList(),
    ];
  }
  
  List<Widget> _buildSlivers(GetDestinationState state) {
    return [
      SliverPersistentHeader(
        delegate: AnimatedSliverAppBar(
          statusBarHeight: MediaQuery.of(context).padding.top,
          title: AppLocalizations.of(context)!.appTitle,
          subtitle: AppLocalizations.of(context)!.discoverSub,
          hintText: AppLocalizations.of(context)!.search,
        ),
        pinned: true,
      ),
      SliverHeader(),
      ..._buildContentSlivers(state),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: BlocBuilder<GetDestinationCubit, GetDestinationState>(
                builder: (context, state) {
                  return CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    slivers: _buildSlivers(state),
                  );
                },
              ),
            ),
          ),
          // ✅ Lottie animation ở góc dưới phải - Tap để mở chat bot
          Positioned(
            right: 4.w,
            bottom: 0.h,
            child: GestureDetector(
              onTap: () {
                // Mở trang Chat Bot với root navigator (fullscreen)
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => ChatBotPage.withProvider()),
                );
              },
              child: Lottie.asset(
                AppLotties.botFloating,
                width: 140.w,
                height: 140.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.animation,
                      size: 50,
                      color: AppColors.primaryBlue,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
