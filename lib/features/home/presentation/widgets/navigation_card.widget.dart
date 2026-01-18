// ignore_for_file: deprecated_member_use

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class NavigationCard extends StatefulWidget {
  const NavigationCard({super.key});

  @override
  State<NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {
  final double cardSize = 50;
  final int itemsPerPage = 4;

  late final PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {
        'icon': AppIcons.car,
        'title': AppLocalizations.of(context)!.carRental,
        'route': AppRouteConstant.carRental,
        'color': AppColors.primaryOrange,
      },
      {
        'icon': AppIcons.bike,
        'title': AppLocalizations.of(context)!.bikeRental,
        'route': AppRouteConstant.motorbikeRental,
        'color': AppColors.primaryBlue,
      },
      {
        'icon': Icons.map_rounded,
        'title': AppLocalizations.of(context)!.itinerary,
        'route': AppRouteConstant.myItinerary,
        'color': AppColors.primaryBlue,
        'isIconData': true,
      },
      {
        'icon': Icons.change_circle_sharp,
        'title': AppLocalizations.of(context)!.mappingAddress,
        'route': AppRouteConstant.mappingAddress,
        'color': AppColors.primaryGreen,
        'isIconData': true,
      },
      {
        'icon': AppIcons.hotel,
        'title': AppLocalizations.of(context)!.findHotel,
        'route': AppRouteConstant.hotelSearch,
        'color': AppColors.primaryPurple,
      },
      {
        'icon': AppIcons.restaurant,
        'title': AppLocalizations.of(context)!.findRes,
        'route': AppRouteConstant.findRestaurant,
        'color': AppColors.primaryYellow,
      },
      {
        'icon': AppIcons.bus,
        'title': AppLocalizations.of(context)!.busBooking,
        'route': AppRouteConstant.busBooking,
        'color': AppColors.primaryGreen,
      },
      {
        'icon': AppIcons.delivery,
        'title': AppLocalizations.of(context)!.delivery,
        'route': AppRouteConstant.fastDelivery,
        'color': AppColors.primaryRed,
      },
      {
        'icon': AppIcons.flight,
        'title': AppLocalizations.of(context)!.flight,
        'route': AppRouteConstant.flightBooking,
        'color': AppColors.primaryBlue,
      },
      {
        'icon': AppIcons.train,
        'title': AppLocalizations.of(context)!.train,
        'route': AppRouteConstant.trainBooking,
        'color': AppColors.primaryRed,
      },
      {
        'icon': Icons.fastfood_rounded,
        'title': AppLocalizations.of(context)!.famousEateries,
        'route': AppRouteConstant.eateryList,
        'color': AppColors.primaryOrange,
        'isIconData': true,
      },
    ];

    final int totalPages = (navItems.length / itemsPerPage).ceil();
    final int cols = 4;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.4),
            blurRadius: 4.r,
            offset: Offset(2.w, 2.h),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: cardSize.h + 8.h + 20.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              onPageChanged: (index) => setState(() => currentPage = index),
              itemBuilder: (context, pageIndex) {
                final start = pageIndex * itemsPerPage;
                final end =
                    (start + itemsPerPage) > navItems.length
                        ? navItems.length
                        : start + itemsPerPage;
                final pageItems = navItems.sublist(start, end);

                int emptySlots = cols - pageItems.length;
                return Row(
                  children: [
                    ...pageItems.map(
                      (item) => Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamed(item['route']);
                              },
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                width: cardSize.w,
                                height: cardSize.h,
                                decoration: BoxDecoration(
                                  color: item['color'],
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(12.w),
                                child:
                                    item['isIconData'] == true
                                        ? Icon(
                                          item['icon'] as IconData,
                                          color: Colors.white,
                                          size: 24.sp,
                                        )
                                        : SvgPicture.asset(
                                          item['icon'] as String,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    for (int i = 0; i < emptySlots; i++)
                      Expanded(child: const SizedBox()),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: currentPage == index ? 16.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color:
                        currentPage == index
                            ? AppColors.primaryBlue
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
