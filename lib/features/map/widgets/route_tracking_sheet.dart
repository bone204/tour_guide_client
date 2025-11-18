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
    // Rebuild khi route thay đổi
    if (oldWidget.route != widget.route || oldWidget.transportMode != widget.transportMode) {
      setState(() {});
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
    print('RouteTrackingSheet build - Mode: ${widget.transportMode}, Route duration: ${route?.duration} seconds');

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
                        if (route != null) _buildRouteInfo(theme, route),
                        if (route == null && (widget.isRouteLoading || widget.isNavigating))
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
    final modes = [
      {'value': 'driving', 'label': 'Lái xe', 'icon': Icons.directions_car},
      {'value': 'walking', 'label': 'Đi bộ', 'icon': Icons.directions_walk},
      {'value': 'cycling', 'label': 'Xe đạp', 'icon': Icons.directions_bike},
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
            child: GestureDetector(
              onTap: () => widget.onTransportChanged(mode['value'] as String),
              child: Container(
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
    final distanceKm = route.distance / 1000;
    final distanceText = distanceKm >= 1
        ? '${distanceKm.toStringAsFixed(1)} km'
        : '${route.distance.toInt()} m';

    return Container(
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
                  '$minutes phút',
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

