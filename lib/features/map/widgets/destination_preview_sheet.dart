part of map_page;

class _DestinationPreviewSheet extends StatelessWidget {
  const _DestinationPreviewSheet({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photos = destination.photos ?? const <String>[];
    final imageUrl = photos.isNotEmpty ? photos.first : null;
    final address =
        destination.specificAddress ??
        destination.province ??
        'Unknown location';
    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 3,
        child: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              child: Material(
                color: AppColors.primaryWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 220.h,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (imageUrl != null)
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => _PreviewImageFallback(
                                    destination: destination,
                                  ),
                            )
                          else
                            _PreviewImageFallback(destination: destination),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.35),
                                    Colors.black.withOpacity(0.05),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20.w,
                            right: 20.w,
                            bottom: 18.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination.name,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6.r),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue
                                            .withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        AppIcons.location,
                                        width: 16.w,
                                        height: 16.h,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          SizedBox(height: 12.h),
                          _buildDragHandle(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeaderInfo(context, address),
                                SizedBox(height: 20.h),
                                _buildTabBar(theme),
                                SizedBox(height: 20.h),
                                _buildTabContent(tabController),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 12.h),
      alignment: Alignment.center,
      child: Container(
        width: 40.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: AppColors.textSubtitle.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context, String address) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          destination.name,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(
                AppIcons.location,
                width: 16.w,
                height: 16.h,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                address,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.textSubtitle,
                ),
              ),
            ),
          ],
        ),
        if (destination.rating != null) ...[
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber, size: 20.r),
              SizedBox(width: 4.w),
              Text(
                destination.rating!.toStringAsFixed(1),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (destination.userRatingsTotal != null) ...[
                SizedBox(width: 4.w),
                Text(
                  '(${destination.userRatingsTotal} reviews)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.textSubtitle.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TabBar(
        padding: EdgeInsets.all(4.r),
        indicator: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(8.r),
        ),
        labelColor: AppColors.primaryWhite,
        unselectedLabelColor: AppColors.textSubtitle,
        labelStyle: theme.textTheme.displayMedium,
        unselectedLabelStyle: theme.textTheme.displayMedium,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Reviews'),
          Tab(text: 'Photos'),
        ],
      ),
    );
  }

  Widget _buildTabContent(TabController tabController) {
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        switch (tabController.index) {
          case 0:
            return AboutTab(name: destination.name);
          case 1:
            return const ReviewsTab();
          case 2:
            return PhotosTab(
              photos: destination.photos,
              defaultImage: AppImage.defaultDestination,
            );
          default:
            return AboutTab(name: destination.name);
        }
      },
    );
  }
}

class _PreviewImageFallback extends StatelessWidget {
  const _PreviewImageFallback({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.5),
            theme.colorScheme.primary.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.white.withOpacity(0.85),
          size: 48,
        ),
      ),
    );
  }
}
