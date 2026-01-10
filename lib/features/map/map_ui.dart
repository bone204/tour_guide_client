part of map_page;

// ignore_for_file: invalid_use_of_protected_member
extension MapUIExtension on _MapPageState {
  /// Build search bar
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
                hintText: AppLocalizations.of(context)!.searchFavoritePlaceHint,
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

  /// Build body
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
                child: Text(AppLocalizations.of(context)!.retry),
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
              initialZoom: _MapPageState._defaultZoom,
              minZoom: 3,
              maxZoom: 18,
              onMapReady: _handleMapReady,
              onPositionChanged: (position, _) {
                final zoom = position.zoom;

                // OPTIMIZATION: Only rebuild when crossing the threshold for marker style change
                // This prevents 60fps rebuilding of the whole widget tree during zoom
                const double photoZoomThreshold = 13.0;
                final wasPhoto = _currentMapZoom >= photoZoomThreshold;
                final isPhoto = zoom >= photoZoomThreshold;

                if (wasPhoto != isPhoto) {
                  setState(() {
                    _currentMapZoom = zoom;
                  });
                } else {
                  _currentMapZoom = zoom;
                }
              },
              onTap: (_, __) {
                // Khi đang navigating, không clear destination/route khi tap vào map
                if (!_isNavigating) {
                  _clearSelectedDestination();
                  _dismissSearchOverlay();
                }
              },
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: _currentMapType.urlTemplate,
                userAgentPackageName: 'tour_guide_app',
                panBuffer: 1,
                keepBuffer: 10,
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
                      child: GestureDetector(
                        onTap: () {
                          _openRouteTrackingSheet();
                        },
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
                    ),
                  if (_currentPosition != null)
                    Marker(
                      width: 80,
                      height: 80,
                      point: _currentPosition!,
                      child: _AnimatedLocationMarker(heading: _currentHeading),
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
                    // Ẩn search khi đang navigating
                    if (!_isNavigating) ...[
                      _buildSearchBar(),
                      const SizedBox(height: 8),
                      // Layer Toggle Button - hiển thị ngay dưới thanh search
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildMapTypeButton(),
                      ),
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
                  ],
                ),
              ),
            ),
          ),
          // Loading overlay toàn màn hình khi đang tính toán routes
          if (_isRouteLoading && _loadingModes.isNotEmpty)
            Positioned.fill(
              child: Material(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.calculatingRoute,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          _buildNavigationSummaryOverlay(),
        ],
      ),
    );
  }

  /// Kiểm tra có nên hiển thị search results không
  bool get _shouldShowSearchResults {
    // Hiển thị khi:
    // 1. Search overlay đang visible (có focus hoặc có text)
    // 2. Đang loading
    // 3. Có kết quả
    // 4. Có text trong search box
    return _isSearchOverlayVisible &&
        (_isFetchingDestinations ||
            _filteredDestinations.isNotEmpty ||
            _searchController.text.isNotEmpty);
  }

  /// Build destination markers
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

  Widget _buildNavigationSummaryOverlay() {
    final isVisible = _isNavigationOverlayVisible;

    // Calculate destination position from selected destination
    LatLng? destinationPosition;
    if (_selectedDestination != null &&
        _selectedDestination!.latitude != null &&
        _selectedDestination!.longitude != null) {
      destinationPosition = LatLng(
        _selectedDestination!.latitude!,
        _selectedDestination!.longitude!,
      );
    }

    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedSlide(
        offset: isVisible ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isVisible ? 1 : 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _NavigationSummarySheet(
              key: ValueKey(
                '${_currentPosition?.latitude}_${_currentPosition?.longitude}',
              ),
              route: _currentRoute ?? _routesByMode[_transportMode],
              onStopNavigation: _stopNavigation,
              currentPosition: _currentPosition,
              destination: destinationPosition,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapTypeButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showMapTypeSelector,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.layers_outlined,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showMapTypeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.mapType,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children:
                      MapType.values.map((type) {
                        final isSelected = _currentMapType == type;
                        String label = type.getLabel(context);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _currentMapType = type;
                            });
                            Navigator.pop(context);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  color:
                                      isSelected
                                          ? Theme.of(
                                            context,
                                          ).primaryColor.withOpacity(0.1)
                                          : Colors.white,
                                ),
                                child: Icon(
                                  type.icon,
                                  color:
                                      isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.shade600,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                label,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.shade600,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }
}

/// Animated location marker with pulsing effect
class _AnimatedLocationMarker extends StatefulWidget {
  const _AnimatedLocationMarker({this.heading});

  final double? heading;

  @override
  State<_AnimatedLocationMarker> createState() =>
      _AnimatedLocationMarkerState();
}

class _AnimatedLocationMarkerState extends State<_AnimatedLocationMarker>
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
        // Pulsing ripple effect
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 80 * _animation.value,
              height: 80 * _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.3 * (1 - _animation.value)),
              ),
            );
          },
        ),
        // Main marker with smooth rotation animation
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              widget.heading != null ? Icons.navigation : Icons.my_location,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
