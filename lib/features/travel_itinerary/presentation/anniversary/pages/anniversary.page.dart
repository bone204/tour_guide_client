import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common/constants/app_lotties.constant.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/anniversary_check_response.dart';

class AnniversaryPage extends StatefulWidget {
  final List<AnniversaryCheckRoute> routes;
  const AnniversaryPage({super.key, required this.routes});

  @override
  State<AnniversaryPage> createState() => _AnniversaryPageState();
}

class _AnniversaryPageState extends State<AnniversaryPage> {
  @override
  Widget build(BuildContext context) {
    return _AnniversaryPageContent(routes: widget.routes);
  }
}

class _AnniversaryPageContent extends StatefulWidget {
  final List<AnniversaryCheckRoute> routes;
  const _AnniversaryPageContent({required this.routes});

  @override
  State<_AnniversaryPageContent> createState() =>
      _AnniversaryPageContentState();
}

class _AnniversaryPageContentState extends State<_AnniversaryPageContent>
    with TickerProviderStateMixin {
  int _currentRouteIndex = 0;
  int _currentMediaIndex = 0;
  late AnimationController _progressController;
  Timer? _pageTimer;
  List<AnniversaryCheckRoute> _routes = [];

  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _routes = widget.routes;
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextMedia();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages(_routes);
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageTimer?.cancel();
    super.dispose();
  }

  Future<void> _preloadImages(List<AnniversaryCheckRoute> routes) async {
    final List<Future<void>> futures = [];
    for (var route in routes) {
      for (var media in route.aggregatedMedia) {
        if (media.url.isNotEmpty) {
          futures.add(precacheImage(NetworkImage(media.url), context));
        }
      }
    }
    await Future.wait(futures);
    if (mounted) {
      setState(() {
        _imagesLoaded = true;
        _startStory();
      });
    }
  }

  void _startStory() {
    _progressController.stop();
    _progressController.reset();
    _progressController.forward();
  }

  void _nextMedia() {
    if (_routes.isEmpty) return;

    final currentRoute = _routes[_currentRouteIndex];
    final mediaCount =
        currentRoute.aggregatedMedia.isEmpty
            ? 1
            : currentRoute.aggregatedMedia.length;

    if (_currentMediaIndex < mediaCount - 1) {
      setState(() {
        _currentMediaIndex++;
      });
      _startStory();
    } else {
      if (_currentRouteIndex < _routes.length - 1) {
        setState(() {
          _currentRouteIndex++;
          _currentMediaIndex = 0;
        });
        _startStory();
      } else {
        // End of all stories
        Navigator.pop(context);
      }
    }
  }

  void _previousMedia() {
    if (_routes.isEmpty) return;

    if (_currentMediaIndex > 0) {
      setState(() {
        _currentMediaIndex--;
      });
      _startStory();
    } else {
      if (_currentRouteIndex > 0) {
        setState(() {
          _currentRouteIndex--;
          final prevRoute = _routes[_currentRouteIndex];
          _currentMediaIndex =
              prevRoute.aggregatedMedia.isEmpty
                  ? 0
                  : prevRoute.aggregatedMedia.length - 1;
        });
        _startStory();
      } else {
        _startStory(); // Restart first story
      }
    }
  }

  void _onTapDown(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    if (tapPosition < screenWidth / 3) {
      _previousMedia();
    } else {
      _nextMedia();
    }
  }

  void _onLongPressStart() {
    setState(() {});
    _progressController.stop();
  }

  void _onLongPressEnd() {
    setState(() {});
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          !_imagesLoaded
              ? Center(
                child: Lottie.asset(
                  AppLotties.anniversary,
                  width: 200.w,
                  height: 200.h,
                ),
              )
              : _routes.isEmpty
              ? _buildEmptyState(context)
              : _buildStoryView(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AppLotties.empty, width: 200.w, height: 200.h),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.noMemoriesToday,
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
          SizedBox(height: 24.h),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryView(BuildContext context) {
    final route = _routes[_currentRouteIndex];
    final mediaList = route.aggregatedMedia;
    final hasMedia = mediaList.isNotEmpty;
    final currentMedia = hasMedia ? mediaList[_currentMediaIndex] : null;

    return GestureDetector(
      onTapDown: _onTapDown,
      onLongPressStart: (_) => _onLongPressStart(),
      onLongPressEnd: (_) => _onLongPressEnd(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background/Media Layer with Ken Burns Effect
          if (hasMedia && currentMedia != null)
            _KenBurnsView(
              key: ValueKey('${route.id}_$_currentMediaIndex'),
              imageUrl: currentMedia.url,
            )
          else
            _buildFallbackBackground(),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.2, 0.7, 1.0],
              ),
            ),
          ),

          // User Info (Progress bar removed)
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primaryBlue,
                        child: Text(
                          route.userName.isNotEmpty
                              ? route.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              route.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              route.period,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Content
          Positioned(
            bottom: 40.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.memoryLane,
                    style: TextStyle(
                      fontFamily: 'Cursive',
                      color: Colors.white,
                      fontSize: 40.sp,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context)!.sinceYouCompleted,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade900,
            Colors.purple.shade900,
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white24,
          size: 100.w,
        ),
      ),
    );
  }
}

class _KenBurnsView extends StatefulWidget {
  final String imageUrl;
  const _KenBurnsView({super.key, required this.imageUrl});

  @override
  State<_KenBurnsView> createState() => _KenBurnsViewState();
}

class _KenBurnsViewState extends State<_KenBurnsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..forward();

    // Randomize initial scale/direction
    final random = Random();
    final bool zoomIn = random.nextBool();

    _scaleAnimation = Tween<double>(
      begin: zoomIn ? 1.0 : 1.2,
      end: zoomIn ? 1.2 : 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Slight translation for dynamic feel
    _translateAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(random.nextDouble() * 0.05, random.nextDouble() * 0.05),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _translateAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                  ),
                );
              },
              errorBuilder:
                  (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }
}
