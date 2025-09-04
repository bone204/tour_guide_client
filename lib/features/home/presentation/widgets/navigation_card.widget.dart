import 'package:flutter/material.dart';
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
  final double spacing = 16;

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
      {'icon': AppIcons.travel, 'title': AppLocalizations.of(context)!.carRental, 'color': AppColors.primaryOrange},
      {'icon': AppIcons.travel, 'title': AppLocalizations.of(context)!.bikeRental, 'color': AppColors.primaryBlue},
      {'icon': AppIcons.travel, 'title': AppLocalizations.of(context)!.busBooking, 'color': AppColors.primaryGreen},
      {'icon': AppIcons.travel, 'title': AppLocalizations.of(context)!.findRes, 'color': AppColors.primaryYellow},
      {'icon': AppIcons.travel, 'title': AppLocalizations.of(context)!.delivery, 'color': AppColors.primaryRed},
      {'icon': AppIcons.travel, 'title': AppLocalizations.of(context)!.findHotel, 'color': AppColors.primaryBlue},
    ];

    final int totalPages = (navItems.length / itemsPerPage).ceil();
    final int cols = 4;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: Offset(2.w, 2.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.w),
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
                final end = (start + itemsPerPage) > navItems.length
                    ? navItems.length
                    : start + itemsPerPage;
                final pageItems = navItems.sublist(start, end);

                int emptySlots = cols - pageItems.length; 
                return Row(
                  children: [
                    ...pageItems.map((item) => Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              width: cardSize.w,
                              height: cardSize.h,
                              decoration: BoxDecoration(
                                color: item['color'],
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(12.w),
                              child: SvgPicture.asset(
                                item['icon'],
                                colorFilter: ColorFilter.mode(
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
                    )),
                    // thêm Expanded rỗng cho các slot còn thiếu
                    for (int i = 0; i < emptySlots; i++) Expanded(child: SizedBox()),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          // Page indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: currentPage == index ? 16.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: currentPage == index ? AppColors.primaryBlue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
