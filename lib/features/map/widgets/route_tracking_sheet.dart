part of map_page;

class _RouteTrackingSheet extends StatefulWidget {
  const _RouteTrackingSheet({
    required this.destination,
    required this.currentPosition,
    required this.route,
    required this.onStartNavigation,
    required this.onStopNavigation,
    required this.isNavigating,
    required this.onTransportChanged,
    required this.transportMode,
    this.onCalculateRoute,
    this.isRouteLoading = false,
    this.onClose,
  });

  final Destination destination;
  final LatLng? currentPosition;
  final OSRMRoute? route;
  final Future<void> Function() onStartNavigation;
  final VoidCallback onStopNavigation;
  final bool isNavigating;
  final Function(String) onTransportChanged;
  final String transportMode;
  final Future<void> Function()? onCalculateRoute;
  final bool isRouteLoading;
  final VoidCallback? onClose;

  @override
  State<_RouteTrackingSheet> createState() => _RouteTrackingSheetState();
}

class _RouteTrackingSheetState extends State<_RouteTrackingSheet> {
  @override
  void didUpdateWidget(_RouteTrackingSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild khi route hoặc transport mode thay đổi
    final routeChanged = oldWidget.route != widget.route;
    final modeChanged = oldWidget.transportMode != widget.transportMode;
    final loadingChanged = oldWidget.isRouteLoading != widget.isRouteLoading;
    
    // So sánh route chi tiết hơn để đảm bảo phát hiện thay đổi
    final routeDurationChanged = oldWidget.route?.duration != widget.route?.duration;
    final routeDistanceChanged = oldWidget.route?.distance != widget.route?.distance;
    
    if (routeChanged || modeChanged || loadingChanged || routeDurationChanged || routeDistanceChanged) {
      // Debug
      if (routeChanged || modeChanged || routeDurationChanged || routeDistanceChanged) {
        print('RouteTrackingSheet didUpdateWidget - Mode: ${widget.transportMode}');
        print('  Old route: ${oldWidget.route?.duration}s, ${oldWidget.route?.distance}m');
        print('  New route: ${widget.route?.duration}s, ${widget.route?.distance}m');
      }
      // Luôn rebuild khi có thay đổi để đảm bảo UI được cập nhật
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final route = widget.route;
    final destination = widget.destination;
    final address = destination.specificAddress ??
        destination.province ??
        'Unknown location';
    
    // Debug: in ra để kiểm tra route hiện tại
    print('RouteTrackingSheet build - Mode: ${widget.transportMode}, Route: ${route?.duration}s, ${route?.distance}m');

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
         child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle - ẩn khi đang navigating
                  if (!widget.isNavigating)
                    Container(
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
                    )
                  else
                    SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chỉ hiển thị tên và địa chỉ khi chưa navigating
                        if (!widget.isNavigating) ...[
                          // Destination name
                          Text(
                            destination.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Address
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 16.sp,
                                color: AppColors.textSubtitle,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  address,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSubtitle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          // Transport mode selector - chỉ hiển thị khi chưa navigating
                          _buildTransportSelector(theme),
                          SizedBox(height: 20.h),
                        ],
                        // Route info - luôn hiển thị
                        // Sử dụng AnimatedSwitcher để cập nhật mượt mà khi route thay đổi
                        if (route != null) 
                          _buildRouteInfo(theme, route)
                        else if (widget.isRouteLoading || widget.isNavigating)
                          _buildLoadingRoute(theme),
                        SizedBox(height: 20.h),
                        // Action button
                        _buildActionButton(theme),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
              if (!widget.isNavigating && widget.onClose != null)
                Positioned(
                  top: 8.h,
                  right: 12.w,
                  child: IconButton(
                    tooltip: 'Đóng',
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.textSubtitle,
                    ),
                    splashRadius: 20.r,
                    onPressed: widget.onClose,
                  ),
                ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransportSelector(ThemeData theme) {
    // OSRM sử dụng profile: car, foot, bike
    final modes = [
      {'value': 'car', 'label': 'Lái xe', 'icon': Icons.directions_car},
      {'value': 'foot', 'label': 'Đi bộ', 'icon': Icons.directions_walk},
      {'value': 'bike', 'label': 'Xe máy', 'icon': Icons.two_wheeler},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.textSubtitle.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: modes.map((mode) {
          final isSelected = widget.transportMode == mode['value'];
          return Expanded(
            child: InkWell(
              onTap: () {
                // Gọi callback ngay lập tức để update route
                widget.onTransportChanged(mode['value'] as String);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      mode['icon'] as IconData,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSubtitle,
                      size: 24.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      mode['label'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSubtitle,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRouteInfo(ThemeData theme, OSRMRoute route) {
    final minutes = (route.duration / 60).ceil();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    // Format thời gian: hiển thị giờ nếu > 60 phút
    final timeText = hours > 0 
        ? '${hours} giờ ${remainingMinutes} phút'
        : '$minutes phút';
    
    final distanceKm = route.distance / 1000;
    final distanceText = distanceKm >= 1
        ? '${distanceKm.toStringAsFixed(1)} km'
        : '${route.distance.toInt()} m';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Container(
        key: ValueKey('${widget.transportMode}_${route.distance}_${route.duration}'),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.route,
              color: AppColors.primaryBlue,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    distanceText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingRoute(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.textSubtitle.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Đang tính toán tuyến đường...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSubtitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    final isNavigating = widget.isNavigating;
    final hasRoute = widget.route != null;
    final isLoading = widget.isRouteLoading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (hasRoute || isNavigating) && !isLoading
            ? () async {
                if (isNavigating) {
                  widget.onStopNavigation();
                } else if (hasRoute) {
                  await widget.onStartNavigation();
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isNavigating
              ? Colors.redAccent
              : AppColors.primaryBlue,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                isNavigating ? 'Kết thúc' : 'Bắt đầu',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

