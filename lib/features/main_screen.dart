// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:tour_guide_app/common/constants/app_icon.constant.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/features/home/presentation/pages/home.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/my_vehicle.page.dart';
import 'package:tour_guide_app/features/settings/presentation/pages/settings.page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('News Page'));
  }
}

class _MainScreenState extends State<MainScreen> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<PersistentTabConfig> _tabs = [
    PersistentTabConfig(
      screen: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: HomePage.withProvider(),
      ),
      item: ItemConfig(
        icon: const Icon(Icons.home_filled),
        title: '',
        activeForegroundColor: AppColors.primaryBlue,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: const NewsPage(),
      ),
      item: ItemConfig(
        icon: const Icon(Icons.newspaper),
        title: '',
        activeForegroundColor: AppColors.primaryBlue,
        inactiveForegroundColor: AppColors.primaryGrey,
      ),
    ),
    PersistentTabConfig(
      screen: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: const NewsPage(),
      ),
      item: ItemConfig(
        icon: const Icon(Icons.newspaper),
        title: '',
        activeForegroundColor: AppColors.primaryBlue,
        inactiveForegroundColor: AppColors.primaryGrey,
      ),
    ),
    PersistentTabConfig(
      screen: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: const MyVehiclePage(),
      ),
      item: ItemConfig(
        icon: const Icon(Icons.explore),
        title: '',
        activeForegroundColor: AppColors.primaryBlue,
        inactiveForegroundColor: AppColors.primaryGrey,
      ),
    ),
    PersistentTabConfig(
      screen: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: const SettingsPage(),
      ),
      item: ItemConfig(
        icon: const Icon(Icons.settings),
        title: '',
        activeForegroundColor: AppColors.primaryBlue,
        inactiveForegroundColor: AppColors.primaryGrey,
      ),
    ),
  ];

  Future<bool> _showExitConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thoát ứng dụng?'),
        content: const Text('Bạn có chắc chắn muốn thoát ứng dụng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Hủy',
              style: TextStyle(color: AppColors.primaryGrey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Thoát',
              style: TextStyle(color: AppColors.primaryRed),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Kiểm tra xem đang ở tab đầu tiên không
          if (_controller.index == 0) {
            // Nếu đang ở tab đầu, hiển thị dialog xác nhận thoát
            final shouldExit = await _showExitConfirmDialog(context);
            if (shouldExit) {
              SystemNavigator.pop();
            }
          } else {
            // Nếu không ở tab đầu, chuyển về tab đầu
            _controller.jumpToTab(0);
          }
        }
      },
      child: PersistentTabView(
        controller: _controller,
        tabs: _tabs,
        navBarBuilder: (navBarConfig) {
      final selectedIndex = navBarConfig.selectedIndex;
      return Container(
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          border: Border(
            top: BorderSide(color: AppColors.secondaryGrey, width: 0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navBarConfig.items.length, (index) {
            final isSelected = index == selectedIndex;
    
            String svgPath;
            switch (index) {
              case 0:
                svgPath = isSelected ? AppIcons.homeActive : AppIcons.homeInactive;
                break;
              case 1:
                svgPath = isSelected ? AppIcons.notificationsActive : AppIcons.notificationsInactive;
                break;
              case 2:
                svgPath = isSelected ? AppIcons.communityActive : AppIcons.communityInactive;
                break;
              case 3:
                svgPath = isSelected ? AppIcons.universityActive : AppIcons.universityInactive;
                break;
              case 4:
                svgPath = isSelected ? AppIcons.barActive : AppIcons.barInactive;
                break;
              default:
                svgPath = AppIcons.homeInactive;
            }
    
            return Expanded(
              child: GestureDetector(
                onTap: () => navBarConfig.onItemSelected(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      svgPath,
                      width: 28,
                      height: 28,
                      color: isSelected ? AppColors.primaryBlue : AppColors.primaryBlack,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
      ),
    );
  }
}
