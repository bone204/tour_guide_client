part of map_page;

// ignore_for_file: invalid_use_of_protected_member
extension MapRouteExtension on _MapPageState {
  /// Tính toán route cho một transport mode cụ thể
  Future<void> _calculateRouteForMode(LatLng start, LatLng end, String mode) async {
    try {
      print('Calculating route for mode: $mode');
      final route = await _osrmService.getRoute(
        start: start,
        end: end,
        profile: mode,
      );
      if (mounted) {
        setState(() {
          _routesByMode[mode] = route;
          if (route != null) {
            print('Route calculated for $mode: ${route.duration} seconds, ${route.distance} meters');
          } else {
            print('Route is null for $mode');
          }
          if (mode == _transportMode) {
            _currentRoute = route;
          }
        });
      }
    } catch (e) {
      print('Error calculating route for $mode: $e');
      if (mounted) {
        setState(() {
          _routesByMode[mode] = null;
          if (mode == _transportMode) {
            _currentRoute = null;
          }
        });
      }
    }
  }

  void _stopNavigation() {
    if (!_isNavigating) return;
    setState(() {
      _isNavigating = false;
      _isRouteEnabled = false;
      _isNavigationOverlayVisible = false;
    });
  }

  void _scheduleNavigationOverlayReveal() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted || !_isNavigating) return;
      setState(() {
        _isNavigationOverlayVisible = true;
      });
    });
  }

  /// Xóa route
  void _clearRoute({bool resetLoading = true}) {
    if (!_isRouteEnabled && _currentRoute == null && !_isRouteLoading) {
      return;
    }
    setState(() {
      _isRouteEnabled = false;
      if (resetLoading) {
        _isRouteLoading = false;
        _loadingModes.clear();
      }
      _currentRoute = null;
      _routesByMode.clear(); // Clear tất cả routes khi clear
    });
  }

  /// Mở route tracking sheet
  Future<void> _openRouteTrackingSheet({bool skipRouteCalculation = false}) async {
    _searchFocusNode.unfocus();
    if (_isNavigating) {
      return;
    }
    if (_selectedDestination == null || _currentPosition == null) {
      return;
    }
    
    final destination = _selectedDestination!;
    if (destination.latitude == null || destination.longitude == null) {
      return;
    }
    
    final target = LatLng(destination.latitude!, destination.longitude!);
    // OSRM sử dụng profile names: car, foot, bike (không phải driving, walking, cycling)
    const transportModes = ['car', 'foot', 'bike'];
    
    // Debug: in ra thông tin tính toán route
    print('Opening route tracking sheet for: ${destination.name}');
    print('From: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
    print('To: ${target.latitude}, ${target.longitude}');
    print('Current routes count: ${_routesByMode.length}');
    
    // Chỉ tính toán routes nếu chưa có hoặc không skip
    if (!skipRouteCalculation) {
      // Hiển thị loading trước khi tính toán
      setState(() {
        _isRouteLoading = true;
        _loadingModes = transportModes.toSet();
      });
      
      // Tính toán routes cho tất cả modes song song
      // Luôn tính toán lại để đảm bảo route đúng với địa điểm hiện tại
      print('Calculating routes for all modes...');
      await Future.wait(transportModes.map((mode) async {
        await _calculateRouteForMode(_currentPosition!, target, mode);
      }));
      
      // Debug: in ra tất cả routes đã tính toán
      print('All routes calculated:');
      for (final mode in transportModes) {
        final route = _routesByMode[mode];
        if (route != null) {
          print('  $mode: ${route.duration} seconds (${(route.duration / 60).ceil()} min), ${route.distance} meters (${(route.distance / 1000).toStringAsFixed(1)} km)');
        } else {
          print('  $mode: null');
        }
      }
      
      // Chỉ mở bottom sheet sau khi đã load xong
      if (!mounted) return;
      
      setState(() {
        _isRouteLoading = false;
        _loadingModes.clear();
        // Set route hiện tại theo transport mode
        _currentRoute = _routesByMode[_transportMode];
      });
    } else {
      // Nếu skip calculation, chỉ set route hiện tại
      if (mounted) {
        setState(() {
          _currentRoute = _routesByMode[_transportMode];
        });
      }
    }
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            // Lấy route mới nhất từ state - đảm bảo lấy đúng route cho transport mode hiện tại
            // Luôn lấy từ _routesByMode để đảm bảo route đúng với mode hiện tại
            // Lấy lại mỗi lần builder rebuild để đảm bảo route luôn mới nhất
            final currentMode = _transportMode;
            final routeForDisplay = _routesByMode[currentMode];
            
            // Debug: in ra để kiểm tra
            print('RouteTrackingSheet builder - Mode: $currentMode, Route: ${routeForDisplay?.duration}s, ${routeForDisplay?.distance}m');
            if (routeForDisplay == null) {
              print('WARNING: Route is null for mode $currentMode');
              print('Available routes: ${_routesByMode.keys.toList()}');
            }
            
            void closeSheet() {
              if (_isNavigating) {
                return;
              }
              setState(() {
                _isNavigating = false;
                _isRouteEnabled = false;
              });
              Navigator.of(context).pop();
            }

            return FractionallySizedBox(
              heightFactor: 0.46,
              child: _RouteTrackingSheet(
                destination: _selectedDestination!,
                currentPosition: _currentPosition,
                route: routeForDisplay,
                onStartNavigation: () async {
                  final navigator = Navigator.of(context);
                  // Khi bấm "Bắt đầu", đợi route load xong rồi mới hiển thị trên map
                  if (_routesByMode[_transportMode] == null && !_loadingModes.contains(_transportMode)) {
                    setState(() {
                      _isRouteLoading = true;
                      _loadingModes.add(_transportMode);
                    });

                    await _calculateRouteForMode(_currentPosition!, target, _transportMode);

                    if (mounted) {
                      setState(() {
                        _isRouteLoading = false;
                        _loadingModes.remove(_transportMode);
                        _currentRoute = _routesByMode[_transportMode];
                        _isNavigating = true;
                        _isRouteEnabled = true; // Hiển thị route trên map
                        _isNavigationOverlayVisible = false;
                      });
                    }
                  } else {
                    setState(() {
                      _isNavigating = true;
                      _isRouteEnabled = true; // Hiển thị route trên map
                      _currentRoute = _routesByMode[_transportMode];
                      _isNavigationOverlayVisible = false;
                    });
                  }
                  navigator.pop();
                  await _recenterOnUser();
                  _scheduleNavigationOverlayReveal();
                },
                onStopNavigation: () {
                  _stopNavigation();
                  Navigator.of(context).pop();
                },
                isNavigating: _isNavigating,
                isRouteLoading: false, // Không loading nữa vì đã load xong
                onCalculateRoute: () async {
                  // Không cần nữa vì đã pre-load
                },
                onTransportChanged: (String mode) {
                  // Chỉ switch giữa các routes đã load, không tính toán lại
                  final newRoute = _routesByMode[mode];

                  // Debug
                  print('Transport changed to: $mode');
                  print('Route for $mode: ${newRoute?.duration}s, ${newRoute?.distance}m');
                  print('All available routes:');
                  _routesByMode.forEach((key, value) {
                    print('  $key: ${value?.duration}s, ${value?.distance}m');
                  });

                  // Update state trước
                  setState(() {
                    _transportMode = mode;
                    _currentRoute = newRoute;
                    // Đảm bảo không hiển thị route trên map khi đổi tab (trừ khi đang navigating)
                    if (!_isNavigating) {
                      _isRouteEnabled = false;
                    } else {
                      // Nếu đang navigating, cập nhật route ngay lập tức
                      _isRouteEnabled = true;
                    }
                  });

                  // Rebuild bottom sheet ngay lập tức để hiển thị route mới cho mode đã chọn
                  // setSheetState sẽ trigger builder rebuild, và routeForDisplay sẽ được lấy lại từ _routesByMode với mode mới
                  setSheetState(() {
                    // Builder sẽ được gọi lại và lấy route mới từ _routesByMode[_transportMode]
                  });
                },
                transportMode: _transportMode,
                onClose: closeSheet,
              ),
            );
          },
        );
      },
    );
  }

  /// Hiển thị route và mở sheet
  Future<void> _showRouteAndOpenSheet() async {
    // Chỉ mở tracking sheet, không tính route
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
    
    // Mở bottom sheet route tracking ngay, không tính route trước
    _openRouteTrackingSheet();
  }
}

