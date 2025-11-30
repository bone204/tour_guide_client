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
                if ((zoom - _currentMapZoom).abs() > 0.01) {
                  setState(() {
                    _currentMapZoom = zoom;
                  });
                  // Không load OSM POIs tự động, chỉ hiển thị khi được search và chọn
                  // _loadOSMPOIs(position.center);
                }
              },
              onTap: (_, __) {
                // Khi đang navigating, không clear destination/route khi tap vào map
                if (!_isNavigating) {
                  _clearSelectedDestination();
                  _dismissSearchOverlay();
                }
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
                    // Ẩn search khi đang navigating
                    if (!_isNavigating) ...[
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
                          'Đang tính toán tuyến đường...',
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
    return _isSearchOverlayVisible && (
      _isFetchingDestinations ||
      _filteredDestinations.isNotEmpty ||
      _searchController.text.isNotEmpty
    );
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
              route: _currentRoute ?? _routesByMode[_transportMode],
              onStopNavigation: _stopNavigation,
            ),
          ),
        ),
      ),
    );
  }
}

