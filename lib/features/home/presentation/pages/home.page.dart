import 'package:flutter/material.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/custom_appbar.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/custom_header.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/hotel_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/nearby_destination_list.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/popular_destination_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/restaurant_list.widget.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/voucher_carousel.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              delegate: AnimatedSliverAppBar(
                statusBarHeight: MediaQuery.of(context).padding.top,
                title: 'Traveline - Vietnam in your mind',
                subtitle: AppLocalizations.of(context)!.discoverSub,
                hintText: AppLocalizations.of(context)!.search,
              ),
              pinned: true, 
            ),
            SliverHeader(),
            SliverVoucherCarousel(),
            SliverPopularDestinationList(),
            SliverNearbyDestinationList(),
            SliverHotelNearbyDestinationList(),
            SliverRestaurantNearbyDestinationList(),
            SliverRestaurantNearbyAttractionList(),
          ],
        ),
      ),
    );
  }
}
