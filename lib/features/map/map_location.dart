part of map_page;

// ignore_for_file: invalid_use_of_protected_member
extension MapLocationExtension on _MapPageState {
  /// Khởi tạo vị trí hiện tại
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
        await _animateTo(currentLatLng, zoom: _MapPageState._defaultZoom);
      } else {
        _pendingMove = currentLatLng;
        _pendingZoom = _MapPageState._defaultZoom;
      }
    } catch (error) {
      setState(() {
        _errorMessage =
            'Không thể lấy vị trí hiện tại. Vui lòng thử lại sau.\n$error';
        _isLoading = false;
      });
    }
  }

  /// Di chuyển bản đồ về vị trí người dùng
  Future<void> _recenterOnUser() async {
    _searchFocusNode.unfocus();
    if (_currentPosition == null) {
      await _initLocation();
      return;
    }
    await _animateTo(_currentPosition!, zoom: _MapPageState._defaultZoom);
  }

  /// Bắt đầu lắng nghe vị trí và hướng di chuyển
  void _startPositionTracking() {
    _positionStreamSubscription?.cancel();
    _compassStreamSubscription?.cancel();

    // Start compass tracking immediately for device heading
    _compassStreamSubscription = FlutterCompass.events?.listen((
      CompassEvent event,
    ) {
      if (!mounted) return;

      // heading is in degrees: 0° = North, 90° = East, 180° = South, 270° = West
      if (event.heading != null) {
        setState(() {
          _currentHeading = event.heading;
        });
      }
    });

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Update every 5 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      if (!mounted) return;

      final newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = newPosition;
        // Don't use GPS heading anymore, we use compass heading instead

        // Update route geometry to follow user
        if (_isNavigating) {
          _updateRouteProgress(newPosition);
        }
      });
    });
  }

  /// Dừng lắng nghe vị trí
  void _stopPositionTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _compassStreamSubscription?.cancel();
    _compassStreamSubscription = null;
  }
}
