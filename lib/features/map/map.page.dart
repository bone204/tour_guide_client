import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/domain/usecases/get_destinations.dart';
import 'package:tour_guide_app/service_locator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    super.key,
    required this.destinations,
    required this.onDestinationTap,
    required this.isLoading,
    required this.errorMessage,
  });

  final List<Destination> destinations;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<Destination> onDestinationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const _LoadingState();
    }

    if (errorMessage != null) {
      return _ErrorState(
        message: errorMessage!,
      );
    }

    if (destinations.isEmpty) {
      return const _EmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 6),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: destinations.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
      itemBuilder: (context, index) {
        final destination = destinations[index];
        final hasAddress =
            (destination.specificAddress ?? destination.province)?.isNotEmpty ??
                false;
        return InkWell(
          onTap: () => onDestinationTap(destination),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DestinationAvatar(index: index),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (hasAddress) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                destination.specificAddress ??
                                    destination.province ??
                                    '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 140,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy địa điểm phù hợp.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final Destination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final imageUrl =
        destination.photos != null && destination.photos!.isNotEmpty
            ? destination.photos!.first
            : null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected ? accent : Colors.white,
                width: isSelected ? 3 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0.28 : 0.18),
                  blurRadius: isSelected ? 22 : 14,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: _MarkerImage(url: imageUrl),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              destination.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DestinationPreviewSheet extends StatelessWidget {
  const _DestinationPreviewSheet({
    required this.destination,
    required this.onViewDetail,
  });

  final Destination destination;
  final VoidCallback onViewDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl =
        destination.photos != null && destination.photos!.isNotEmpty
            ? destination.photos!.first
            : null;
    final address =
        destination.specificAddress ?? destination.province ?? 'Đang cập nhật';
    String? description = destination.descriptionViet?.trim();
    if (description == null || description.isEmpty) {
      description = destination.descriptionEng?.trim();
    }

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Material(
          color: theme.colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageUrl != null)
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _PreviewImageFallback(destination: destination),
                      )
                    else
                      _PreviewImageFallback(destination: destination),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.black.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: Colors.amber.shade500, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            destination.rating != null
                                ? destination.rating!.toStringAsFixed(1)
                                : 'Chưa có đánh giá',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (destination.userRatingsTotal != null)
                            Text(
                              '  (${destination.userRatingsTotal} đánh giá)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (destination.categories != null &&
                          destination.categories!.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: destination.categories!
                              .take(6)
                              .map(
                                (category) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    category,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      if (destination.categories != null &&
                          destination.categories!.isNotEmpty)
                        const SizedBox(height: 20),
                      if ((description ?? '').isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Giới thiệu',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade700,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      if (destination.specificAddress != null ||
                          destination.province != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Địa chỉ',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    address,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onViewDetail,
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Xem chi tiết đầy đủ'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewImageFallback extends StatelessWidget {
  const _PreviewImageFallback({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.5),
            theme.colorScheme.primary.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.white.withOpacity(0.85),
          size: 48,
        ),
      ),
    );
  }
}

class _MarkerImage extends StatelessWidget {
  const _MarkerImage({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _MarkerPlaceholder(
        icon: Icons.photo_outlined,
        color: Colors.grey.shade400,
      );
    }

    return Image.network(
      url!,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const _MarkerPlaceholder(
          icon: Icons.photo_size_select_actual_outlined,
          color: Colors.white70,
          isLoading: true,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _MarkerPlaceholder(
          icon: Icons.broken_image_outlined,
          color: Colors.red.shade300,
        );
      },
    );
  }
}

class _MarkerPlaceholder extends StatelessWidget {
  const _MarkerPlaceholder({
    required this.icon,
    required this.color,
    this.isLoading = false,
  });

  final IconData icon;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, color: color, size: 28),
      ),
    );
  }
}

class _DestinationIcon extends StatelessWidget {
  const _DestinationIcon({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final Destination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: isSelected ? 1.1 : 1.0,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? accent
                : theme.colorScheme.primary.withOpacity(0.85),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.place_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationAvatar extends StatelessWidget {
  const _DestinationAvatar({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF4F46E5),
      const Color(0xFF22C55E),
      const Color(0xFFF97316),
      const Color(0xFFEC4899),
      const Color(0xFF14B8A6),
    ];
    final color = colors[index % colors.length];

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.85), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.place_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
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
      DestinationQuery(
        offset: 0,
        limit: 500,
        available: true,
      ),
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
        final availableDestinations = response.items
            .where(
              (destination) =>
                  destination.latitude != null && destination.longitude != null,
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

  void _onSearchChanged(String value) {
    final query = value.trim().toLowerCase();
    List<Destination> results;

    if (query.isEmpty) {
      results = _destinations.take(10).toList();
    } else {
      results = _destinations
          .where(
            (destination) => destination.name.toLowerCase().contains(query),
          )
          .take(10)
          .toList();
    }

    setState(() {
      _filteredDestinations = results;
    });
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
          const SnackBar(
            content: Text('Địa điểm chưa có dữ liệu vị trí.'),
          ),
        );
      }
      return;
    }

    final target = LatLng(latitude, longitude);

    setState(() {
      _selectedDestinationPosition = target;
      _selectedDestinationId = destination.id;
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
      floatingActionButton: hasError || _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _recenterOnUser,
              child: const Icon(Icons.my_location),
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
                }
              },
              onTap: (_, __) => _dismissSearchOverlay(),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'tour_guide_app',
              ),
              MarkerLayer(
                markers: [
                  ..._buildDestinationMarkers(),
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
                      child: _shouldShowSearchResults
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
      final point = LatLng(
        destination.latitude!,
        destination.longitude!,
      );
      final isSelected = destination.id == _selectedDestinationId;

      return Marker(
        width: showPhotoMarkers ? 108 : 40,
        height: showPhotoMarkers ? 124 : 40,
        point: point,
        alignment: Alignment.bottomCenter,
        child: showPhotoMarkers
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
    }).toList();
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
          color: isFocused ? primaryColor.withOpacity(0.35) : Colors.transparent,
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
            child: _searchController.text.isEmpty
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

    final latTween =
        Tween<double>(begin: currentCenter.latitude, end: target.latitude);
    final lngTween =
        Tween<double>(begin: currentCenter.longitude, end: target.longitude);
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
          child: _DestinationPreviewSheet(
            destination: destination,
            onViewDetail: () =>
                _navigateToDestinationDetail(sheetContext, destination.id),
          ),
        );
      },
    );
  }

  void _navigateToDestinationDetail(BuildContext sheetContext, int destinationId) {
    Navigator.of(sheetContext).pop();
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => DestinationDetailPage.withProvider(destinationId: destinationId),
      ),
    );
  }

  void _handleMapReady() {
    _isMapReady = true;
    _currentMapZoom = _mapController.camera.zoom;
    if (_pendingMove != null) {
      final target = _pendingMove!;
      final zoom = _pendingZoom ?? _defaultZoom;
      _pendingMove = null;
      _pendingZoom = null;
      _animateTo(target, zoom: zoom);
    } else if (_selectedDestinationPosition != null) {
      _animateTo(_selectedDestinationPosition!, zoom: _destinationZoom);
    } else if (_currentPosition != null) {
      _animateTo(_currentPosition!, zoom: _defaultZoom);
    }
  }
}