part of map_page;

// ignore_for_file: invalid_use_of_protected_member
extension MapRouteExtension on _MapPageState {
  /// Tính toán route cho một transport mode cụ thể
  Future<void> _calculateRouteForMode(
    LatLng start,
    LatLng end,
    String mode,
  ) async {
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
            print(
              'Route calculated for $mode: ${route.duration} seconds, ${route.distance} meters',
            );
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
    _stopPositionTracking(); // Stop tracking heading
    setState(() {
      _isNavigating = false;
      _isRouteEnabled = false;
      _isNavigationOverlayVisible = false;
      _currentHeading = null; // Reset heading to show location dot
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
  Future<void> _openRouteTrackingSheet({
    bool skipRouteCalculation = false,
  }) async {
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
    print(
      'From: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
    );
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
      await Future.wait(
        transportModes.map((mode) async {
          await _calculateRouteForMode(_currentPosition!, target, mode);
        }),
      );

      // Debug: in ra tất cả routes đã tính toán
      print('All routes calculated:');
      for (final mode in transportModes) {
        final route = _routesByMode[mode];
        if (route != null) {
          print(
            '  $mode: ${route.duration} seconds (${(route.duration / 60).ceil()} min), ${route.distance} meters (${(route.distance / 1000).toStringAsFixed(1)} km)',
          );
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
            print(
              'RouteTrackingSheet builder - Mode: $currentMode, Route: ${routeForDisplay?.duration}s, ${routeForDisplay?.distance}m',
            );
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
              heightFactor: 0.6, // Increased from 0.46 to 0.6 (60% of screen)
              child: _RouteTrackingSheet(
                destination: _selectedDestination!,
                currentPosition: _currentPosition,
                route: routeForDisplay,
                onStartNavigation: () async {
                  final navigator = Navigator.of(context);
                  // Khi bấm "Bắt đầu", đợi route load xong rồi mới hiển thị trên map
                  if (_routesByMode[_transportMode] == null &&
                      !_loadingModes.contains(_transportMode)) {
                    setState(() {
                      _isRouteLoading = true;
                      _loadingModes.add(_transportMode);
                    });

                    await _calculateRouteForMode(
                      _currentPosition!,
                      target,
                      _transportMode,
                    );

                    if (mounted) {
                      setState(() {
                        _isRouteLoading = false;
                        _loadingModes.remove(_transportMode);
                        _currentRoute = _routesByMode[_transportMode];
                        _isNavigating = true;
                        _isRouteEnabled = true; // Hiển thị route trên map
                        _isNavigationOverlayVisible = false;
                      });
                      _startPositionTracking(); // Start tracking heading
                    }
                  } else {
                    setState(() {
                      _isNavigating = true;
                      _isRouteEnabled = true; // Hiển thị route trên map
                      _currentRoute = _routesByMode[_transportMode];
                      _isNavigationOverlayVisible = false;
                    });
                    _startPositionTracking(); // Start tracking heading
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
                  print(
                    'Route for $mode: ${newRoute?.duration}s, ${newRoute?.distance}m',
                  );
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

  /// Mở route tracking sheet
  Future<void> _showRouteAndOpenSheet() async {
    // Chỉ mở tracking sheet, không tính route
    if (_selectedDestination == null || _currentPosition == null) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: AppLocalizations.of(context)!.pleaseSelectLocation,
          type: SnackbarType.warning,
        );
      }
      return;
    }

    // Mở bottom sheet route tracking ngay, không tính route trước
    _openRouteTrackingSheet();
  }

  /// Cập nhật tiến độ di chuyển trên route
  void _updateRouteProgress(LatLng currentPos) {
    if (!_isNavigating ||
        _currentRoute == null ||
        _currentRoute!.geometry.isEmpty) {
      return;
    }

    // Ensure destination is valid for rerouting
    if (_selectedDestination == null ||
        _selectedDestination!.latitude == null ||
        _selectedDestination!.longitude == null) {
      return;
    }

    final geometry = _currentRoute!.geometry;
    final distance = const Distance();

    // Tìm điểm gần nhất trên route
    int closestIndex = 0;
    double minDistance = double.infinity;

    // Tìm trong toàn bộ geometry để phát hiện off-route chính xác hơn
    // Tuy nhiên để tối ưu, nếu route quá dài có thể giới hạn lại
    // Nhưng để tính off-route thì nên kiểm tra đoạn gần user nhất
    // Ở đây ta check 30 điểm đầu tiên (hoặc toàn bộ nếu ít hơn)
    final searchRange = math.min(geometry.length, 30);

    for (int i = 0; i < searchRange; i++) {
      final point = geometry[i];
      final d = distance.as(LengthUnit.Meter, currentPos, point);
      if (d < minDistance) {
        minDistance = d;
        closestIndex = i;
      }
    }

    // OFF-ROUTE DETECTION
    // Nếu điểm gần nhất cách xa hơn ngưỡng cho phép (ví dụ 50m)
    // Và chúng ta không đang loading route mới
    const double offRouteThreshold = 50.0; // meters
    if (minDistance > offRouteThreshold) {
      if (!_isRouteLoading && !_loadingModes.contains(_transportMode)) {
        print('User is off-route ($minDistance m). Recalculating...');

        // Target destination
        final target = LatLng(
          _selectedDestination!.latitude!,
          _selectedDestination!.longitude!,
        );

        // Trigger reroute
        // Lưu ý: hàm này async nhưng chúng ta gọi fire-and-forget ở đây
        // Nó sẽ tự update state khi xong

        // Set loading state để tránh spam request
        setState(() {
          _isRouteLoading = true;
          _loadingModes.add(_transportMode);
        });

        _calculateRouteForMode(currentPos, target, _transportMode).then((_) {
          if (mounted) {
            setState(() {
              _isRouteLoading = false;
              _loadingModes.remove(_transportMode);
              // Update current route
              _currentRoute = _routesByMode[_transportMode];
            });
          }
        });
      }
      return; // Không trim route cũ nếu đang off-route/rerouting
    }

    // TRIM ROUTE (Snap & Cut)
    // Nếu điểm gần nhất không phải là điểm đầu tiên, hoặc user đã đi xa hơn điểm đầu
    // Cắt bỏ các điểm đã đi qua
    if (closestIndex > 0) {
      // Giữ lại từ điểm gần nhất trở đi
      final remainingGeometry = geometry.sublist(closestIndex);
      // Thêm vị trí hiện tại vào đầu để line liền mạch
      remainingGeometry.insert(0, currentPos);

      final updatedRoute = OSRMRoute(
        distance: _currentRoute!.distance, // Giữ nguyên hoặc tính lại nếu cần
        duration: _currentRoute!.duration,
        geometry: remainingGeometry,
        steps: _currentRoute!.steps,
      );

      setState(() {
        _currentRoute = updatedRoute;
        _routesByMode[_transportMode] = updatedRoute;
      });
    } else {
      // Ngay cả khi chưa qua điểm nào (closestIndex == 0),
      // cập nhật điểm đầu tiên thành vị trí hiện tại để line "bám" vào icon
      final remainingGeometry = List<LatLng>.from(geometry);
      if (remainingGeometry.isNotEmpty) {
        remainingGeometry[0] = currentPos;
      } else {
        remainingGeometry.add(currentPos);
      }

      final updatedRoute = OSRMRoute(
        distance: _currentRoute!.distance,
        duration: _currentRoute!.duration,
        geometry: remainingGeometry,
        steps: _currentRoute!.steps,
      );

      setState(() {
        _currentRoute = updatedRoute;
        _routesByMode[_transportMode] = updatedRoute;
      });
    }
  }
}
