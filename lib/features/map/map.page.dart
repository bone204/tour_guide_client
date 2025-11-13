library map_page;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/home/domain/usecases/get_destinations.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/tab_item/about_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/photos_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/reviews_tab.widget.dart';
import 'package:tour_guide_app/features/map/services/osm_service.dart';
import 'package:tour_guide_app/features/map/services/osrm_service.dart';

part 'widgets/search_results_list.dart';
part 'widgets/destination_marker.dart';
part 'widgets/destination_preview_sheet.dart';

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
  
  final OSMService _osmService = OSMService();
  final OSRMService _osrmService = OSRMService();

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

  Future<void> _initLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Dịch vụ định vị đang tắt. Vui lòng bật GPS.';
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
              'Ứng dụng cần quyền truy cập vị trí để hiển thị bản đồ.';
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final currentLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = currentLatLng;
        _isLoading = false;
      });

      if (_isMapReady) {
        await _animateTo(currentLatLng, zoom: _defaultZoom);
      } else {
        _pendingMove = currentLatLng;
        _pendingZoom = _defaultZoom;
      }
    } catch (error) {
      setState(() {
        _errorMessage =
            'Không thể lấy vị trí hiện tại. Vui lòng thử lại sau.\n$error';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDestinations() async {
    setState(() {
      _isFetchingDestinations = true;
      _destinationFetchError = null;
    });

    final result = await sl<GetDestinationUseCase>().call(
      DestinationQuery(offset: 0, limit: 500, available: true),
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _isFetchingDestinations = false;
          _destinationFetchError = failure.message;
        });
      },
      (response) {
        final availableDestinations =
            response.items
                .where(
                  (destination) =>
                      destination.latitude != null &&
                      destination.longitude != null,
                )
                .toList();

        setState(() {
          _destinations = availableDestinations;
          _filteredDestinations = availableDestinations.take(10).toList();
          _isFetchingDestinations = false;
        });
      },
    );
  }

  void _handleSearchFocusChange() {
    setState(() {
      _isSearchOverlayVisible = _searchFocusNode.hasFocus;
    });
  }

  void _onSearchChanged(String value) async {
    final query = value.trim();
    final queryLower = query.toLowerCase();
    final tokens = queryLower
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList();
    
    if (query.isEmpty) {
      setState(() {
        _filteredDestinations = _destinations.take(10).toList();
        _isFetchingDestinations = false;
      });
      return;
    }

    setState(() {
      _isFetchingDestinations = true;
    });

    // Tìm kiếm trong database destinations
    final dbResults = _destinations
        .where((destination) {
          final nameLower = destination.name.toLowerCase();
          if (tokens.isEmpty) {
            return nameLower.contains(queryLower);
          }
          return _matchesTokens(nameLower, tokens);
        })
        .toList();

    // Tìm kiếm trong OSM nếu query đủ dài (>= 3 ký tự để có kết quả tốt hơn)
    List<Destination> osmResults = [];
    if (query.length >= 3) {
      try {
        // Tìm kiếm với limit hợp lý
        final osmPOIs = await _osmService.searchPlaces(query, limit: 10);
        osmResults = osmPOIs
            .where((poi) => 
                poi.position != null && 
                poi.name != null && 
                poi.name!.isNotEmpty &&
                poi.name != 'Unnamed Place' &&
                poi.name!.length >= 2)
            .map((poi) => Destination.fromOSMPOI(
                  poi.id ?? '',
                  poi.name!,
                  poi.latitude!,
                  poi.longitude!,
                  poi.type,
                ))
            .where((destination) {
              final nameLower = destination.name.toLowerCase();
              if (tokens.isEmpty) {
                return nameLower.contains(queryLower);
              }
              return _matchesTokens(nameLower, tokens);
            })
            .toList();
      } catch (e) {
        print('Error searching OSM: $e');
      }
    }

    // Kết hợp kết quả: DB destinations trước, sau đó OSM
    final combinedResults = <Destination>[];
    combinedResults.addAll(dbResults);
    
    // Thêm OSM results nhưng loại bỏ trùng lặp và lọc kỹ hơn
    for (final osmDest in osmResults) {
      // Kiểm tra tên hợp lệ
      if (osmDest.name.isEmpty || 
          osmDest.name.length < 2 ||
          osmDest.name == 'Unnamed Place') {
        continue;
      }
      
      // Loại bỏ các tên không phù hợp
      final nameLower = osmDest.name.toLowerCase();
      if (RegExp(r'^\d+$').hasMatch(osmDest.name) ||
          nameLower.contains('km') ||
          nameLower.startsWith('đường') ||
          nameLower.startsWith('phố') ||
          nameLower.startsWith('ngõ') ||
          nameLower.startsWith('hẻm') ||
          nameLower.contains('số nhà') ||
          nameLower.contains('house number')) {
        continue;
      }
      
      // Kiểm tra trùng lặp với DB destinations
      final isDuplicate = combinedResults.any((dbDest) {
        final dbNameLower = dbDest.name.toLowerCase();
        final osmNameLower = osmDest.name.toLowerCase();
        
        // So sánh tên (tương đối)
        if (dbNameLower == osmNameLower ||
            dbNameLower.contains(osmNameLower) ||
            osmNameLower.contains(dbNameLower)) {
          // Kiểm tra nếu vị trí gần nhau (trong vòng 200m)
          if (dbDest.latitude != null && dbDest.longitude != null &&
              osmDest.latitude != null && osmDest.longitude != null) {
            final distance = _calculateDistance(
              dbDest.latitude!,
              dbDest.longitude!,
              osmDest.latitude!,
              osmDest.longitude!,
            );
            return distance < 0.2; // ~200m
          }
        }
        return false;
      });
      
      if (!isDuplicate) {
        combinedResults.add(osmDest);
      }
    }

    // Loại bỏ trùng lặp dựa trên khóa tên + tọa độ
    final uniqueResults = <String, Destination>{};
    for (final destination in combinedResults) {
      final key = '${destination.name.toLowerCase()}_${destination.latitude}_${destination.longitude}';
      uniqueResults.putIfAbsent(key, () => destination);
    }
    var mergedList = uniqueResults.values.toList();

    // Ưu tiên các kết quả khớp chính xác hoặc khớp toàn bộ tokens
    final exactMatches = mergedList
        .where((dest) => dest.name.toLowerCase() == queryLower)
        .toList();
    final strictMatches = mergedList
        .where((dest) => _matchesTokens(dest.name.toLowerCase(), tokens))
        .toList();

    List<Destination> prioritizedResults;
    if (exactMatches.isNotEmpty) {
      final remaining = mergedList
          .where((dest) => dest.name.toLowerCase() != queryLower)
          .toList();
      remaining.sort((a, b) =>
          _compareDestinationsByRelevance(a, b, queryLower, tokens));
      prioritizedResults = [...exactMatches, ...remaining];
    } else if (strictMatches.isNotEmpty) {
      strictMatches.sort((a, b) =>
          _compareDestinationsByRelevance(a, b, queryLower, tokens));
      final remaining = mergedList
          .where((dest) => !strictMatches.contains(dest))
          .toList()
        ..sort((a, b) =>
            _compareDestinationsByRelevance(a, b, queryLower, tokens));
      prioritizedResults = [...strictMatches, ...remaining];
    } else {
      mergedList.sort((a, b) =>
          _compareDestinationsByRelevance(a, b, queryLower, tokens));
      prioritizedResults = mergedList;
    }

    if (mounted) {
      setState(() {
        _filteredDestinations = prioritizedResults.take(20).toList();
        _isFetchingDestinations = false;
      });
    }
  }

  // Tính khoảng cách giữa 2 điểm (đơn vị: km)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
    FocusScope.of(context).requestFocus(_searchFocusNode);
  }

  void _dismissSearchOverlay() {
    final wasFocused = _searchFocusNode.hasFocus;
    if (wasFocused) {
      _searchFocusNode.unfocus();
    }

    if (_isSearchOverlayVisible || wasFocused) {
      setState(() {
        _isSearchOverlayVisible = false;
      });
    }
  }

  Future<void> _handleMarkerTap(Destination destination) async {
    await _selectDestination(destination);
    if (!mounted) {
      return;
    }
    _openDestinationBottomSheet(destination);
  }

  Future<void> _selectDestination(Destination destination) async {
    final latitude = destination.latitude;
    final longitude = destination.longitude;

    if (latitude == null || longitude == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Địa điểm chưa có dữ liệu vị trí.')),
        );
      }
      return;
    }

    final target = LatLng(latitude, longitude);

    setState(() {
      _selectedDestinationPosition = target;
      _selectedDestinationId = destination.id;
      _selectedDestination = destination;
      _isRouteEnabled = false; // Không tự động bật route
      _currentRoute = null; // Xóa route cũ khi chọn địa điểm mới
      _isRouteLoading = false;
      if (!_isMapReady) {
        _pendingMove = target;
        _pendingZoom = _destinationZoom;
      }
      _filteredDestinations = [];
      _isSearchOverlayVisible = false;
    });

    _searchController.text = destination.name;
    FocusScope.of(context).unfocus();

    if (_isMapReady) {
      await _animateTo(target, zoom: _destinationZoom);
    }
  }
  
  Future<void> _showRoute() async {
    if (_selectedDestination == null || _currentPosition == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn một địa điểm và đảm bảo đã bật vị trí.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    
    if (_isRouteLoading) {
      return;
    }
    
    final destination = _selectedDestination!;
    final latitude = destination.latitude;
    final longitude = destination.longitude;
    
    if (latitude == null || longitude == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Địa điểm chưa có dữ liệu vị trí.')),
        );
      }
      return;
    }
    
    final target = LatLng(latitude, longitude);
    
    setState(() {
      _isRouteLoading = true;
      _isRouteEnabled = false;
      _currentRoute = null;
    });
    
    await _calculateRoute(_currentPosition!, target);
    
    if (mounted) {
      setState(() {
        _isRouteLoading = false;
      });
    }
  }
  
  void _clearRoute({bool resetLoading = true}) {
    if (!_isRouteEnabled && _currentRoute == null && !_isRouteLoading) {
      return;
    }
    setState(() {
      _isRouteEnabled = false;
      if (resetLoading) {
        _isRouteLoading = false;
      }
      _currentRoute = null;
    });
  }
  
  void _clearSelectedDestination({bool clearRoute = true, bool resetSearchField = false}) {
    if (_selectedDestination == null &&
        _selectedDestinationId == null &&
        _selectedDestinationPosition == null) {
      return;
    }
    if (clearRoute) {
      _clearRoute();
    }
    setState(() {
      _selectedDestination = null;
      _selectedDestinationId = null;
      _selectedDestinationPosition = null;
    });
    if (resetSearchField) {
      _searchController.clear();
    }
  }
  
  Future<void> _calculateRoute(LatLng start, LatLng end) async {
    try {
      final route = await _osrmService.getRoute(start: start, end: end);
      if (mounted) {
        if (route != null && route.geometry.isNotEmpty) {
          setState(() {
            _currentRoute = route;
            _isRouteEnabled = true;
          });
        } else {
          setState(() {
            _currentRoute = null;
            _isRouteEnabled = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không tìm thấy tuyến đường phù hợp.')),
            );
          }
        }
      }
    } catch (e) {
      print('Error calculating route: $e');
      if (mounted) {
        setState(() {
          _isRouteEnabled = false;
          _currentRoute = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tính toán tuyến đường. Vui lòng thử lại.')),
        );
      }
    }
  }
  
  Future<void> _recenterOnUser() async {
    if (_currentPosition == null) {
      await _initLocation();
      return;
    }
    await _animateTo(_currentPosition!, zoom: _defaultZoom);
  }

  @override
  void dispose() {
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

    return Scaffold(
      body: _buildBody(hasError, center),
      floatingActionButton:
          hasError || _isLoading
              ? null
              : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Nút tìm đường đi - hiện ngay khi đã chọn địa điểm
                  if (_selectedDestination != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: FloatingActionButton.extended(
                        heroTag: 'route_button',
                        onPressed: (_isRouteLoading || _currentPosition == null)
                            ? null
                            : () {
                                if (_isRouteEnabled && _currentRoute != null) {
                                  _clearRoute();
                                } else {
                                  _showRoute();
                                }
                              },
                        backgroundColor: _isRouteEnabled && _currentRoute != null
                            ? Colors.redAccent
                            : (_currentPosition == null 
                                ? Colors.grey 
                                : Colors.green),
                        icon: _isRouteLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Icon(
                                _isRouteEnabled && _currentRoute != null
                                    ? Icons.close_rounded
                                    : Icons.directions,
                                color: Colors.white,
                              ),
                        label: Text(
                          _isRouteLoading
                              ? 'Đang tính đường...'
                              : _currentPosition == null
                                  ? 'Cần vị trí GPS'
                                  : _isRouteEnabled && _currentRoute != null
                                      ? 'Hủy tuyến'
                                      : 'Tìm đường',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  // Nút vị trí hiện tại
                  FloatingActionButton(
                    heroTag: 'my_location',
                    onPressed: _recenterOnUser,
                    child: const Icon(Icons.my_location),
                  ),
                ],
              ),
    );
  }

  Widget _buildBody(bool hasError, LatLng center) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initLocation,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _dismissSearchOverlay,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: _defaultZoom,
              minZoom: 3,
              maxZoom: 18,
              onMapReady: _handleMapReady,
              onPositionChanged: (position, _) {
                final zoom = position.zoom;
                if ((zoom - _currentMapZoom).abs() > 0.01) {
                  setState(() {
                    _currentMapZoom = zoom;
                  });
                  // Không load OSM POIs tự động, chỉ hiển thị khi được search và chọn
                  // _loadOSMPOIs(position.center);
                }
              },
              onTap: (_, __) {
                _clearSelectedDestination();
                _dismissSearchOverlay();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'tour_guide_app',
              ),
              // Routing layer - chỉ hiển thị khi route được bật
              if (_isRouteEnabled && 
                  _currentRoute != null && 
                  _currentRoute!.geometry.isNotEmpty)
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
                  ..._buildDestinationMarkers(),
                  // Không hiển thị OSM POIs tự động, chỉ hiển thị khi được search và chọn
                  // Marker cho địa điểm đã chọn từ OSM (không có trong DB)
                  if (_selectedDestination != null &&
                      !_selectedDestination!.isFromDatabase &&
                      _selectedDestination!.latitude != null &&
                      _selectedDestination!.longitude != null)
                    Marker(
                      width: 48,
                      height: 48,
                      point: LatLng(
                        _selectedDestination!.latitude!,
                        _selectedDestination!.longitude!,
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                    ),
                  if (_currentPosition != null)
                    Marker(
                      width: 32,
                      height: 32,
                      point: _currentPosition!,
                      child: const Icon(
                        Icons.my_location,
                        size: 28,
                        color: Colors.blueAccent,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 140),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child:
                          _shouldShowSearchResults
                              ? _SearchResultsList(
                                key: const ValueKey('search-results'),
                                destinations: _filteredDestinations,
                                isLoading: _isFetchingDestinations,
                                errorMessage: _destinationFetchError,
                                onDestinationTap: _selectDestination,
                              )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _shouldShowSearchResults {
    if (!_isSearchOverlayVisible) {
      return false;
    }

    if (_destinationFetchError != null || _isFetchingDestinations) {
      return true;
    }

    return _filteredDestinations.isNotEmpty ||
        _searchController.text.isNotEmpty;
  }

  List<Marker> _buildDestinationMarkers() {
    const photoZoomThreshold = 13.0;
    final showPhotoMarkers = _currentMapZoom >= photoZoomThreshold;

    return _destinations
        .where(
          (destination) =>
              destination.latitude != null && destination.longitude != null,
        )
        .map((destination) {
          final point = LatLng(destination.latitude!, destination.longitude!);
          final isSelected = destination.id == _selectedDestinationId;

          return Marker(
            width: showPhotoMarkers ? 108 : 40,
            height: showPhotoMarkers ? 124 : 40,
            point: point,
            alignment: Alignment.bottomCenter,
            child:
                showPhotoMarkers
                    ? _DestinationMarker(
                      destination: destination,
                      isSelected: isSelected,
                      onTap: () => _handleMarkerTap(destination),
                    )
                    : _DestinationIcon(
                      destination: destination,
                      isSelected: isSelected,
                      onTap: () => _handleMarkerTap(destination),
                    ),
          );
        })
        .toList();
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final isFocused =
        _searchFocusNode.hasFocus || _searchController.text.isNotEmpty;
    final primaryColor = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              isFocused ? primaryColor.withOpacity(0.35) : Colors.transparent,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isFocused ? 0.14 : 0.07),
            blurRadius: isFocused ? 22 : 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: isFocused ? primaryColor : Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Tìm kiếm địa điểm yêu thích...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child:
                _searchController.text.isEmpty
                    ? const SizedBox(width: 0)
                    : GestureDetector(
                      key: const ValueKey('clear-search'),
                      onTap: _clearSearch,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: primaryColor,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Future<void> _animateTo(LatLng target, {double? zoom}) async {
    if (!_isMapReady) {
      _pendingMove = target;
      _pendingZoom = zoom;
      return;
    }

    final camera = _mapController.camera;
    final currentCenter = camera.center;
    final currentZoom = camera.zoom;
    final targetZoom = zoom ?? currentZoom;

    if (_isSamePosition(currentCenter, target) &&
        (currentZoom - targetZoom).abs() < 0.01) {
      _mapController.move(target, targetZoom);
      return;
    }

    _pendingMove = null;
    _pendingZoom = null;

    _cameraAnimationController?.stop();
    _cameraAnimationController?.dispose();

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    final curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    final latTween = Tween<double>(
      begin: currentCenter.latitude,
      end: target.latitude,
    );
    final lngTween = Tween<double>(
      begin: currentCenter.longitude,
      end: target.longitude,
    );
    final zoomTween = Tween<double>(begin: currentZoom, end: targetZoom);

    curve.addListener(() {
      final lat = latTween.evaluate(curve);
      final lng = lngTween.evaluate(curve);
      final z = zoomTween.evaluate(curve);
      _mapController.move(LatLng(lat, lng), z);
    });

    curve.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
        if (identical(_cameraAnimationController, controller)) {
          _cameraAnimationController = null;
        }
      }
    });

    _cameraAnimationController = controller;
    await controller.forward();
  }

  bool _isSamePosition(LatLng a, LatLng b) {
    const epsilon = 0.000001;
    return (a.latitude - b.latitude).abs() < epsilon &&
        (a.longitude - b.longitude).abs() < epsilon;
  }

  void _openDestinationBottomSheet(Destination destination) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.78,
          child: _DestinationPreviewSheet(destination: destination),
        );
      },
    );
  }

  void _handleMapReady() async {
    _isMapReady = true;
    _currentMapZoom = _mapController.camera.zoom;
    if (_pendingMove != null) {
      final target = _pendingMove!;
      final zoom = _pendingZoom ?? _defaultZoom;
      _pendingMove = null;
      _pendingZoom = null;
      await _animateTo(target, zoom: zoom);
    } else if (_selectedDestinationPosition != null) {
      await _animateTo(_selectedDestinationPosition!, zoom: _destinationZoom);
    } else if (_currentPosition != null) {
      await _animateTo(_currentPosition!, zoom: _defaultZoom);
    }
  }

  bool _matchesTokens(String nameLower, List<String> tokens) {
    if (tokens.isEmpty) {
      return nameLower.isNotEmpty;
    }

    final matches = tokens.where((token) => nameLower.contains(token)).length;

    if (tokens.length == 1 && tokens.first.length < 3) {
      return matches > 0;
    }

    return matches == tokens.length;
  }

  int _compareDestinationsByRelevance(
    Destination a,
    Destination b,
    String queryLower,
    List<String> tokens,
  ) {
    final scoreA = _calculateRelevanceScore(a.name, queryLower, tokens);
    final scoreB = _calculateRelevanceScore(b.name, queryLower, tokens);

    if (scoreA != scoreB) {
      return scoreA.compareTo(scoreB);
    }

    // Ưu tiên tên ngắn hơn và theo thứ tự alphabet nếu điểm bằng nhau
    if (a.name.length != b.name.length) {
      return a.name.length.compareTo(b.name.length);
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  }

  int _calculateRelevanceScore(
    String name,
    String queryLower,
    List<String> tokens,
  ) {
    final nameLower = name.toLowerCase();
    int score = 1000;

    if (nameLower == queryLower) {
      return 0;
    }

    if (nameLower.startsWith(queryLower)) {
      score -= 200;
    } else if (nameLower.contains(queryLower)) {
      score -= 100;
    }

    for (final token in tokens) {
      if (nameLower.startsWith(token)) {
        score -= 60;
      } else if (nameLower.contains(' $token')) {
        score -= 40;
      } else if (nameLower.contains(token)) {
        score -= 30;
      } else {
        score += 25;
      }
    }

    score += nameLower.length;
    return score;
  }
}
