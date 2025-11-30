part of map_page;

// ignore_for_file: invalid_use_of_protected_member
extension MapDestinationExtension on _MapPageState {
  /// Xử lý khi tap vào marker
  Future<void> _handleMarkerTap(Destination destination) async {
    if (_isNavigating) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.navigatingCannotSelect)),
        );
      }
      return;
    }
    _searchFocusNode.unfocus();
    await _selectDestination(destination);
    if (!mounted) {
      return;
    }
    _openDestinationBottomSheet(destination);
  }

  /// Chọn destination
  Future<void> _selectDestination(Destination destination) async {
    final latitude = destination.latitude;
    final longitude = destination.longitude;

    if (latitude == null || longitude == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.locationNoData)),
        );
      }
      return;
    }

    final target = LatLng(latitude, longitude);

    // Unfocus trước để tránh trigger _handleSearchFocusChange
    _searchFocusNode.unfocus();
    
    // Debug: in ra thông tin địa điểm mới
    print('Selecting new destination: ${destination.name} at ${target.latitude}, ${target.longitude}');
    if (_selectedDestination != null) {
      print('Previous destination: ${_selectedDestination!.name}');
    }
    
    setState(() {
      _selectedDestinationPosition = target;
      _selectedDestinationId = destination.id;
      _selectedDestination = destination;
      _isRouteEnabled = false; // Không tự động bật route
      _currentRoute = null; // Xóa route cũ khi chọn địa điểm mới
      _isRouteLoading = false;
      _routesByMode.clear(); // Clear tất cả routes cũ khi chọn địa điểm mới
      _loadingModes.clear(); // Clear loading modes
      if (!_isMapReady) {
        _pendingMove = target;
        _pendingZoom = _MapPageState._destinationZoom;
      }
      // Ẩn search overlay khi chọn destination
      _isSearchOverlayVisible = false;
    });
    
    print('Routes cleared. _routesByMode is now empty: ${_routesByMode.isEmpty}');

    _searchController.text = destination.name;

    if (_isMapReady) {
      await _animateTo(target, zoom: _MapPageState._destinationZoom);
    }
  }
  
  /// Xóa destination đã chọn
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
      _routesByMode.clear(); // Clear routes khi clear destination
    });
    if (resetSearchField) {
      _searchController.clear();
    }
  }

  /// Mở destination bottom sheet
  void _openDestinationBottomSheet(Destination destination) {
    if (_isNavigating) {
      return;
    }
    _searchFocusNode.unfocus();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.78,
          child: _DestinationPreviewSheet(
            destination: destination,
            onNavigate: () async {
              Navigator.of(sheetContext).pop();
              // Chọn destination và tính route, sau đó mở tracking sheet
              await _selectDestination(destination);
              if (_currentPosition != null && mounted) {
                // Tính route và mở tracking sheet
                await _showRouteAndOpenSheet();
              }
            },
          ),
        );
      },
    );
  }
}

extension MapAnimationExtension on _MapPageState {
  /// Animate map to target position
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

  /// Kiểm tra 2 vị trí có giống nhau không
  bool _isSamePosition(LatLng a, LatLng b) {
    const epsilon = 0.000001;
    return (a.latitude - b.latitude).abs() < epsilon &&
        (a.longitude - b.longitude).abs() < epsilon;
  }

  /// Xử lý khi map ready
  void _handleMapReady() async {
    _isMapReady = true;
    _currentMapZoom = _mapController.camera.zoom;
    if (_pendingMove != null) {
      final target = _pendingMove!;
      final zoom = _pendingZoom ?? _MapPageState._defaultZoom;
      _pendingMove = null;
      _pendingZoom = null;
      await _animateTo(target, zoom: zoom);
    } else if (_selectedDestinationPosition != null) {
      await _animateTo(_selectedDestinationPosition!, zoom: _MapPageState._destinationZoom);
    } else if (_currentPosition != null) {
      await _animateTo(_currentPosition!, zoom: _MapPageState._defaultZoom);
    }
  }
}

