import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:tour_guide_app/features/map/services/osrm_service.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart'; // Ensure common lib is here just in case

class TrackingMapPage extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final String? startAddress;
  final String? endAddress;

  const TrackingMapPage({
    super.key,
    required this.startLocation,
    required this.endLocation,
    this.startAddress,
    this.endAddress,
  });

  @override
  State<TrackingMapPage> createState() => _TrackingMapPageState();
}

class _TrackingMapPageState extends State<TrackingMapPage>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final OSRMService _osrmService = OSRMService();

  LatLng? _currentPosition;
  double? _currentHeading;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isAutoCenter = true;

  OSRMRoute? _currentRoute;
  bool _isRouteLoading = false;
  double _traveledDistance = 0;
  bool _isFirstLocationUpdate = true;
  MapType _currentMapType = MapType.normal;

  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<CompassEvent>? _compassStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _compassStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage =
              AppLocalizations.of(
                context,
              )!.locationServiceDisabled; // Ensure this key exists or use fallback
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _errorMessage =
              AppLocalizations.of(context)!.locationPermissionDenied;
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final currentLatLng = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _currentPosition = currentLatLng;
          _isLoading = false;
        });
        _startTracking();
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _startTracking() {
    // Compass
    _compassStreamSubscription = FlutterCompass.events?.listen((event) {
      if (mounted && event.heading != null) {
        setState(() {
          _currentHeading = event.heading;
        });
      }
    });

    // Position
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      if (!mounted) return;
      final newDetail = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = newDetail;
      });

      _updateTraveledDistance();

      _updateRouteProgress(newDetail);

      if (_currentRoute == null || _isFirstLocationUpdate) {
        _fetchRoute();
      }

      if (_isAutoCenter) {
        _mapController.move(newDetail, _mapController.camera.zoom);
      }

      _isFirstLocationUpdate = false;
    });
  }

  Future<void> _fetchRoute() async {
    if (_currentPosition == null) return;

    setState(() => _isRouteLoading = true);

    try {
      final route = await _osrmService.getRoute(
        start: _currentPosition!,
        end: widget.endLocation,
        profile: 'car',
      );

      if (mounted) {
        setState(() {
          _currentRoute = route;
          _isRouteLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
      if (mounted) setState(() => _isRouteLoading = false);
    }
  }

  void _updateTraveledDistance() {
    if (_currentPosition == null) return;

    // Calculate from START location (Owner Biz) to CURRENT location
    final distance = const Distance().as(
      LengthUnit.Meter,
      widget.startLocation,
      _currentPosition!,
    );

    if (mounted) {
      setState(() {
        _traveledDistance = distance;
      });
    }
  }

  void _updateRouteProgress(LatLng currentPos) {
    if (_currentRoute == null || _currentRoute!.geometry.isEmpty) {
      return;
    }

    final geometry = _currentRoute!.geometry;
    final distanceCalc = const Distance();

    // 1. Find closest point on route
    int closestIndex = 0;
    double minDistance = double.infinity;
    // Check first 30 points for performance
    final searchRange = math.min(geometry.length, 30);

    for (int i = 0; i < searchRange; i++) {
      final point = geometry[i];
      final d = distanceCalc.as(LengthUnit.Meter, currentPos, point);
      if (d < minDistance) {
        minDistance = d;
        closestIndex = i;
      }
    }

    // 2. Off-route detection (> 50m)
    const double offRouteThreshold = 50.0;
    if (minDistance > offRouteThreshold) {
      // Avoid spamming requests
      if (!_isRouteLoading) {
        debugPrint('Off-route ($minDistance m). Recalculating...');
        // We do NOT trim; we trigger a fetch which will replace _currentRoute
        _fetchRoute();
      }
      return;
    }

    // 3. Trim Route (On-route)
    if (closestIndex > 0) {
      // Keep from closest point onwards
      final remainingGeometry = geometry.sublist(closestIndex);
      // Snap start to current pos for smooth line
      if (remainingGeometry.isNotEmpty) {
        remainingGeometry.insert(0, currentPos);
      } else {
        remainingGeometry.add(currentPos);
      }

      // 4. Recalculate metrics for trimmed route
      // We estimate remaining distance by summing segments of remaining geometry
      double remainingDistance = 0;
      for (int i = 0; i < remainingGeometry.length - 1; i++) {
        remainingDistance += distanceCalc.as(
          LengthUnit.Meter,
          remainingGeometry[i],
          remainingGeometry[i + 1],
        );
      }

      // Estimate remaining time based on remaining distance and average speed (or original proportion)
      // Simpler: Propagate duration based on distance ratio if original distance is known,
      // BUT _currentRoute object is replaced so strictly we lose original total.
      // Better heuristic: Assume average speed from OSRM original prediction or just 30km/h (8.3 m/s) urban avg if simpler.
      // OSRM usually gives good duration. Let's try to infer speed from CURRENT segment? No, too noisy.
      // Let's use the ratio of (remainingDist / oldDist) * oldDuration?
      // Problem: oldDist decreases every update.
      // Solution: Current OSRMRoute doesn't verify validity. We will create a new OSRMRoute object.
      // We will APPROXIMATE duration: speed = dist/time.
      // If we don't have speed, we assume the original route's average speed.
      // However, if we keep trimming, the "original" properties of _currentRoute are the PREVIOUS step's.
      // So Avg Speed = _currentRoute.distance / _currentRoute.duration.

      double avgSpeed = 0;
      if (_currentRoute!.duration > 0 && _currentRoute!.distance > 0) {
        avgSpeed = _currentRoute!.distance / _currentRoute!.duration;
      }
      // If speed is weird (e.g. 0), default to 30km/h ~ 8.33 m/s
      if (avgSpeed <= 0.1) avgSpeed = 8.33;

      final estimatedDuration = remainingDistance / avgSpeed;

      final updatedRoute = OSRMRoute(
        distance: remainingDistance,
        duration: estimatedDuration,
        geometry: remainingGeometry,
        steps: _currentRoute!.steps,
      );

      setState(() {
        _currentRoute = updatedRoute;
      });
    } else {
      // Even if at index 0, snap start to current pos
      if (geometry.isNotEmpty) {
        final newGeo = List<LatLng>.from(geometry);
        newGeo[0] = currentPos;

        // Recalc distance slightly? Maybe negligible for index 0.
        // Just update geometry to keep it visually connected
        final updatedRoute = OSRMRoute(
          distance: _currentRoute!.distance,
          duration: _currentRoute!.duration,
          geometry: newGeo,
          steps: _currentRoute!.steps,
        );
        setState(() {
          _currentRoute = updatedRoute;
        });
      }
    }
  }

  void _recenter() {
    if (_currentPosition != null) {
      setState(() => _isAutoCenter = true);
      _mapController.move(_currentPosition!, 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.map,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    final center = _currentPosition ?? widget.startLocation;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 15.0,
            onPositionChanged: (pos, hasGesture) {
              if (hasGesture && _isAutoCenter) {
                setState(() => _isAutoCenter = false);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: _currentMapType.urlTemplate,
              userAgentPackageName: 'tour_guide_app',
            ),
            // Routing layer
            if (_currentRoute != null && _currentRoute!.geometry.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _currentRoute!.geometry,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                // Start Location
                Marker(
                  point: widget.startLocation,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.store, // Changed icon to verify update
                    color: Colors.green,
                    size: 40,
                  ),
                ),
                // End Location
                Marker(
                  point: widget.endLocation,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                // Current Location
                if (_currentPosition != null)
                  Marker(
                    point: _currentPosition!,
                    width: 60,
                    height: 60,
                    child: _AnimatedTrackingMarker(heading: _currentHeading),
                  ),
              ],
            ),
          ],
        ),

        // Map Type Toggle
        Positioned(
          right: 16.w,
          bottom: 320.h,
          child: FloatingActionButton(
            heroTag: 'map_type_fab',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder:
                    (context) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Text(
                              AppLocalizations.of(context)!.mapType,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          ...MapType.values.map(
                            (type) => ListTile(
                              leading: Icon(type.icon),
                              title: Text(type.getLabel(context)),
                              trailing:
                                  _currentMapType == type
                                      ? const Icon(
                                        Icons.check,
                                        color: AppColors.primaryBlue,
                                      )
                                      : null,
                              onTap: () {
                                setState(() => _currentMapType = type);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
              );
            },
            backgroundColor: Colors.white,
            child: Icon(_currentMapType.icon, color: AppColors.primaryBlue),
          ),
        ),

        // FAB - Repositioned above bottom sheet
        if (_currentPosition != null)
          Positioned(
            right: 16.w,
            bottom: 250.h,
            child: FloatingActionButton(
              heroTag: 'tracking_map_fab',
              onPressed: _recenter,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.my_location,
                color: _isAutoCenter ? AppColors.primaryBlue : Colors.grey,
              ),
            ),
          ),

        // Bottom Sheet Overlay
        Positioned(left: 0, right: 0, bottom: 0, child: _buildTrackingSheet()),
      ],
    );
  }

  Widget _buildTrackingSheet() {
    String timeText = AppLocalizations.of(context)!.updating;
    String distanceText = AppLocalizations.of(context)!.updating;

    if (_isRouteLoading) {
      timeText = AppLocalizations.of(context)!.recalculating;
      distanceText = AppLocalizations.of(context)!.recalculating;
    } else if (_currentRoute != null) {
      final minutes = (_currentRoute!.duration / 60).ceil();
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      timeText =
          hours > 0 ? '${hours}h ${remainingMinutes}m' : '${minutes} min';

      final km = _currentRoute!.distance / 1000;
      distanceText =
          km >= 1
              ? '${km.toStringAsFixed(1)} km'
              : '${_currentRoute!.distance.toInt()} m';
    }

    final traveledKm = _traveledDistance / 1000;
    final traveledText =
        traveledKm >= 1
            ? '${traveledKm.toStringAsFixed(1)} km'
            : '${_traveledDistance.toInt()} m';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrackingItem(
                context,
                icon: Icons.access_time_filled_rounded,
                iconColor: Colors.orange,
                iconBgColor: Colors.orange.withOpacity(0.1),
                value: timeText,
                label: AppLocalizations.of(context)!.estimatedTime,
              ),
              Container(width: 1, height: 40.h, color: Colors.grey[200]),
              _buildTrackingItem(
                context,
                icon: Icons.near_me_rounded,
                iconColor: AppColors.primaryBlue,
                iconBgColor: AppColors.primaryBlue.withOpacity(0.1),
                value: distanceText,
                label: AppLocalizations.of(context)!.remaining,
              ),
              Container(width: 1, height: 40.h, color: Colors.grey[200]),
              _buildTrackingItem(
                context,
                icon: Icons.directions_car_filled_rounded,
                iconColor: Colors.green,
                iconBgColor: Colors.green.withOpacity(0.1),
                value: traveledText,
                label: AppLocalizations.of(context)!.traveled,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSubtitle,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedTrackingMarker extends StatefulWidget {
  final double? heading;
  const _AnimatedTrackingMarker({this.heading});

  @override
  State<_AnimatedTrackingMarker> createState() =>
      __AnimatedTrackingMarkerState();
}

class __AnimatedTrackingMarkerState extends State<_AnimatedTrackingMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 60 * _animation.value,
              height: 60 * _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.3 * (1 - _animation.value)),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: widget.heading ?? 0,
            end: widget.heading ?? 0,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, angle, child) {
            return Transform.rotate(angle: angle * math.pi / 180, child: child);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              widget.heading != null ? Icons.navigation : Icons.circle,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
