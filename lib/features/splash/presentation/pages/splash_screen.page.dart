import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common/bloc/auth/auth_state_cubit.dart';
import 'package:tour_guide_app/common/bloc/auth/auth_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _progressController;

  // Animations
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _progressAnimation;

  // Connectivity
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation (fade in + scale)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Progress bar animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  void _startSplashSequence() async {
    // Sequence the animations
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    // Animate to 98%
    _progressController.animateTo(
      0.98,
      duration: const Duration(milliseconds: 9700),
      curve: Curves.easeInOut,
    );

    // Wait for animation to reach 98%
    await Future.delayed(const Duration(milliseconds: 9700));

    // Check network connection at 98%
    if (mounted) {
      await _checkConnectionAndProceed();
    }
  }

  Future<void> _checkConnectionAndProceed() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (hasConnection) {
      // Has network - complete to 100% and navigate
      if (mounted) {
        await _progressController.animateTo(
          1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _navigateToNextScreen();
      }
    } else {
      // No network - show retry dialog
      if (mounted) {
        _showRetryDialog();
      }
    }
  }

  void _showRetryDialog() {
    showAppDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      titleWidget: Row(
        children: [
          Icon(Icons.wifi_off, color: AppColors.primaryBlue, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            'Không có kết nối',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlack,
            ),
          ),
        ],
      ),
      contentWidget: Text(
        'Vui lòng kiểm tra kết nối mạng của bạn và thử lại.',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF6B7280),
          height: 1.5,
        ),
      ),
      actionsAlignment: CrossAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await _retryConnection();
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Thử lại',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _retryConnection() async {
    if (!mounted) return;

    _progressController.stop();

    await _progressController.animateTo(
      0.80,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    await _progressController.animateTo(
      0.98,
      duration: const Duration(milliseconds: 3000),
      curve: Curves.easeInOut,
    );

    if (mounted) {
      await _checkConnectionAndProceed();
    }
  }

  void _navigateToNextScreen() {
    final authState = context.read<AuthStateCubit>().state;

    debugPrint('🚀 Navigating based on auth state: ${authState.runtimeType}');

    if (authState is Authenticated) {
      debugPrint('✅ User is authenticated, navigating to main screen');
      Navigator.pushReplacementNamed(context, AppRouteConstant.mainScreen);
    } else {
      debugPrint('❌ User is not authenticated, navigating to login');
      Navigator.pushReplacementNamed(context, AppRouteConstant.signIn);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          debugPrint('✅ Auth State: Authenticated');
        } else if (state is UnAuthenticated) {
          debugPrint('❌ Auth State: UnAuthenticated');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Main content
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120.h),
                  _buildLogoAndTitle(),
                  SizedBox(height: 40.h),
                  _buildLottieAnimation(),
                  const Spacer(),
                ],
              ),

              // Progress bar at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 60.h,
                child: _buildProgressBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 8),
                spreadRadius: 3,
              ),
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo icon
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.primaryBlue.withOpacity(0.7),
                      AppColors.primaryBlue.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.explore,
                    size: 45.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // App title
              Text(
                'Traveline',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 8.h),

              // Subtitle
              Text(
                'Tour Guide App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),

              SizedBox(height: 12.h),

              // Tagline
              Text(
                'Khám phá thế giới\nHành trình của bạn, phong cách của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: child,
        );
      },
      child: SizedBox(
        width: 200.w,
        height: 200.h,
        child: Lottie.asset(
          AppLotties.splashAnimation,
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
          // Nếu file không tồn tại, hiển thị placeholder
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.animation,
                    size: 60.sp,
                    color: AppColors.primaryBlue.withOpacity(0.3),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Thêm file Lottie\nvào assets/lottie/',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.primaryBlue.withOpacity(0.5),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            children: [
              Text(
                'Đang khởi động...',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 20.h),
              // Progress bar
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryBlue,
                            AppColors.primaryBlue.withOpacity(0.8),
                            AppColors.primaryBlue.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Percentage text
              Text(
                '${(_progressAnimation.value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
