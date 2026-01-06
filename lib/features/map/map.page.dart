library map_page;

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_destinations.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/tab_item/about_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/photos_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/reviews_tab.widget.dart';
import 'package:tour_guide_app/features/map/services/osm_service.dart';
import 'package:tour_guide_app/features/map/services/osrm_service.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:shimmer/shimmer.dart';

part 'widgets/search_results_list.dart';
part 'widgets/destination_marker.dart';
part 'widgets/destination_preview_sheet.dart';
part 'widgets/route_tracking_sheet.dart';
part 'map_location.dart';
part 'map_search.dart';
part 'map_route.dart';
part 'map_ui.dart';
part 'map_destination.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  LatLng? _currentPosition;
  double? _currentHeading; // Device heading in degrees (0-360)
  LatLng? _selectedDestinationPosition;
  int? _selectedDestinationId;
  double _currentMapZoom = _defaultZoom;

  bool _isLoading = true;
  String? _errorMessage;
  bool _isMapReady = false;
  LatLng? _pendingMove;
  bool _isFetchingDestinations = false;
  String? _destinationFetchError;

  List<Destination> _destinations = [];
  List<Destination> _filteredDestinations = [];
  double? _pendingZoom;
  AnimationController? _cameraAnimationController;
  bool _isSearchOverlayVisible = false;
  OSRMRoute? _currentRoute;
  bool _isRouteEnabled = false; // Trạng thái bật/tắt route
  Destination? _selectedDestination; // Lưu destination đã chọn
  bool _isRouteLoading = false; // Trạng thái đang tính toán route
  bool _isNavigating = false; // Trạng thái đang điều hướng
  bool _isNavigationOverlayVisible = false; // Hiển thị summary navigation
  String _transportMode = 'car'; // Phương tiện di chuyển (car, foot, bike)
  Timer?
  _transportModeDebounceTimer; // Debounce timer cho transport mode change
  Timer? _searchDebounceTimer; // Debounce timer cho search
  Map<String, OSRMRoute?> _routesByMode =
      {}; // Lưu routes cho từng transport mode
  Set<String> _loadingModes = {}; // Các modes đang được tính toán

  final OSMService _osmService = OSMService();
  final OSRMService _osrmService = OSRMService();
  StreamSubscription<Position>? _positionStreamSubscription;

  static const double _defaultZoom = 15;
  static const double _destinationZoom = 17.5;
  static const LatLng _fallbackCenter = LatLng(21.0285, 105.8542); // Hà Nội

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_handleSearchFocusChange);
    _loadDestinations();
    _initLocation();
  }

  // Methods moved to extensions - see map_location.dart, map_search.dart, map_route.dart, map_ui.dart, map_destination.dart

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _transportModeDebounceTimer?.cancel();
    _searchDebounceTimer?.cancel();
    _mapController.dispose();
    _searchController.dispose();
    _searchFocusNode
      ..removeListener(_handleSearchFocusChange)
      ..dispose();
    _cameraAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorMessage != null;
    final center = _currentPosition ?? _fallbackCenter;

    final showFab =
        !hasError && !_isLoading && !_isNavigating && !_isRouteLoading;

    return Scaffold(
      body: _buildBody(hasError, center),
      floatingActionButton:
          showFab
              ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'my_location',
                    onPressed: _recenterOnUser,
                    child: const Icon(Icons.my_location),
                  ),
                ],
              )
              : null,
    );
  }
}

// Extension methods are in separate part files:
// - map_location.dart: Location services
// - map_search.dart: Search functionality
// - map_route.dart: Route calculation
// - map_ui.dart: UI building
// - map_destination.dart: Destination selection and animation
