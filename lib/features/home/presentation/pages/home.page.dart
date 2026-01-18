import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/pages/chat_bot.page.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/favorite_destination/favorite_destinations_cubit.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destinations/get_destination_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destinations/get_destination_state.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_recommend_destinations/get_recommend_destinations_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_recommend_destinations/get_recommend_destinations_state.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_vouchers/get_vouchers_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_list/cooperation_list_cubit.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/hotel_rooms_search/hotel_rooms_search_cubit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tour_guide_app/features/notifications/data/models/notification.dart';
import 'package:tour_guide_app/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/custom_appbar.widget.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/custom_header.widget.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/anniversary/bloc/anniversary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/anniversary/bloc/anniversary_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/anniversary/pages/anniversary.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/anniversary_check_response.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/hotel_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/rating_destination_list.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/popular_destination_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/restaurant_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/shimmer_widgets.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/voucher_carousel.widget.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/search_restaurant_tables/search_restaurant_tables_cubit.dart';

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
        BlocProvider(
          create:
              (context) =>
                  GetRecommendDestinationsCubit()..getRecommendDestinations(
                    query: DestinationQuery(limit: 10, offset: 0),
                  ),
        ),
        BlocProvider(
          create: (context) => sl<GetVouchersCubit>()..getVouchers(),
        ),
        BlocProvider(
          create:
              (context) =>
                  sl<
                    CooperationListCubit
                  >(), // No longer auto-fetching cooperation restaurants
        ),
        BlocProvider(
          create: (context) => sl<FavoriteCooperationsCubit>()..loadFavorites(),
        ),
        BlocProvider(create: (context) => sl<HotelRoomsSearchCubit>()),
        BlocProvider(create: (context) => sl<SearchRestaurantTablesCubit>()),
        BlocProvider(
          create: (context) => sl<NotificationCubit>()..getNotifications(),
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
    _searchNearbyHotels();
    _searchNearbyRestaurants();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnniversaryCubit>().checkAnniversaries();
    });
  }

  Future<void> _searchNearbyHotels() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        context.read<HotelRoomsSearchCubit>().searchHotels(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      // Silently fail if location not available
    }
  }

  Future<void> _searchNearbyRestaurants() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        context.read<SearchRestaurantTablesCubit>().searchRestaurants(
          RestaurantTableSearchRequest(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }
    } catch (e) {
      // Silently fail if location not available
    }
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
    final recommendCubit = context.read<GetRecommendDestinationsCubit>();
    final state = cubit.state;

    if (state is GetDestinationLoaded) {
      if (!state.hasReachedEnd && !state.isLoadingMore) {
        _lastLoadMoreTime = now;
        cubit.loadMoreDestinations();
      }
    }

    // Load more for recommended destinations
    final recommendState = recommendCubit.state;
    if (recommendState is GetRecommendDestinationsLoaded) {
      if (!recommendState.hasReachedEnd && !recommendState.isLoadingMore) {
        _lastLoadMoreTime = now;
        recommendCubit.loadMoreRecommendDestinations();
      }
    }
  }

  Future<void> _onRefresh() async {
    // Reload tất cả các API địa điểm
    await Future.wait([
      context.read<GetDestinationCubit>().getDestinations(),
      context.read<FavoriteDestinationsCubit>().loadFavorites(),
      context.read<GetRecommendDestinationsCubit>().getRecommendDestinations(
        query: DestinationQuery(limit: 10, offset: 0),
      ),
      context.read<GetVouchersCubit>().getVouchers(),
      // context.read<CooperationListCubit>().getCooperations(), // Removed
      context.read<FavoriteCooperationsCubit>().loadFavorites(),
      _searchNearbyHotels(),
      _searchNearbyRestaurants(),
    ]);
  }

  List<Widget> _buildContentSlivers(GetDestinationState state) {
    final isLoading =
        state is GetDestinationLoading || state is GetDestinationInitial;

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
      SliverRatingDestinationList(),
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
    return MultiBlocListener(
      listeners: [
        BlocListener<AnniversaryCubit, AnniversaryState>(
          listener: (context, state) {
            if (state is AnniversaryDetailLoaded) {
              final route = AnniversaryCheckRoute(
                id: state.detail.routeId,
                name: state.detail.name,
                period: state.detail.period,
                userName: '', // Can be filled if available
                aggregatedMedia: state.detail.media,
              );
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => AnniversaryPage(routes: [route]),
                ),
              );
            } else if (state is AnniversaryFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: GestureDetector(
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
            // Anniversary FAB
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoaded) {
                  try {
                    final anniversaryNotif =
                        state.notifications.where((n) {
                          return n.type == NotificationType.anniversary &&
                              n.data != null;
                        }).firstOrNull;

                    if (anniversaryNotif != null) {
                      final route = AnniversaryCheckRoute.fromJson(
                        Map<String, dynamic>.from(anniversaryNotif.data),
                      );

                      return Positioned(
                        bottom: 90.h + 56.h + 16.h,
                        right: 16.w,
                        child: FloatingActionButton(
                          heroTag: 'anniversary_fab',
                          onPressed: () {
                            context
                                .read<AnniversaryCubit>()
                                .getAnniversaryDetail(route.id);
                          },
                          backgroundColor: Colors.white,
                          child: Lottie.asset(
                            AppLotties.anniversary,
                            width: 40.w,
                            height: 40.w,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    // Ignore parsing errors
                  }
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned(
              bottom: 0.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (_) => ChatBotPage.withProvider(),
                    ),
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
      ),
    );
  }
}
