part of map_page;

// ignore_for_file: invalid_use_of_protected_member

class _SearchWorkerArgs {
  final List<Destination> dbDestinations;
  final List<Destination> osmDestinations;
  final String query;
  final LatLng? userPosition;

  _SearchWorkerArgs({
    required this.dbDestinations,
    required this.osmDestinations,
    required this.query,
    this.userPosition,
  });
}

List<Destination> _searchWorker(_SearchWorkerArgs args) {
  final query = args.query;
  final queryLower = query.toLowerCase();
  final tokens =
      queryLower
          .split(RegExp(r'\s+'))
          .where((token) => token.isNotEmpty)
          .toList();

  // 1. Filter DB results
  final dbResults =
      args.dbDestinations.where((destination) {
        final nameLower = destination.name.toLowerCase();
        return _workerMatchesSearchQuery(nameLower, queryLower, tokens);
      }).toList();

  // 2. Filter OSM results
  // Only filter by matching query if we have many results (>10), otherwise keep them
  var osmResults = args.osmDestinations;
  if (osmResults.length > 10) {
    osmResults =
        osmResults.where((destination) {
          final nameLower = destination.name.toLowerCase();
          if (tokens.isEmpty) {
            return nameLower.contains(queryLower);
          }
          return tokens.any((token) => nameLower.contains(token)) ||
              _workerMatchesSearchQuery(nameLower, queryLower, tokens);
        }).toList();
  }

  // 3. Merge & Deduplicate
  final combinedResults = <Destination>[];
  combinedResults.addAll(dbResults);

  for (final osmDest in osmResults) {
    if (osmDest.name.isEmpty ||
        osmDest.name.length < 2 ||
        osmDest.name == 'Unnamed Place') {
      continue;
    }

    final nameLower = osmDest.name.toLowerCase();
    // Basic noise filtering
    if (RegExp(r'^\d+$').hasMatch(osmDest.name) ||
        (nameLower.contains('km') && nameLower.length < 10) ||
        (nameLower.startsWith('số nhà') && nameLower.length < 15) ||
        (nameLower.contains('house number') && nameLower.length < 20)) {
      continue;
    }

    // Deduplication check
    final isDuplicate = combinedResults.any((dbDest) {
      final dbNameLower = dbDest.name.toLowerCase();
      final osmNameLower = osmDest.name.toLowerCase();

      final dbNameNorm = _removeDiacritics(dbNameLower);
      final osmNameNorm = _removeDiacritics(osmNameLower);

      // Relaxed name matching with normalization
      if (dbNameLower == osmNameLower ||
          dbNameNorm == osmNameNorm ||
          (dbNameNorm.contains(osmNameNorm) && osmNameNorm.length > 3) ||
          (osmNameNorm.contains(dbNameNorm) && dbNameNorm.length > 3)) {
        // Distance check
        if (dbDest.latitude != null &&
            dbDest.longitude != null &&
            osmDest.latitude != null &&
            osmDest.longitude != null) {
          final distance = _workerCalculateDistance(
            dbDest.latitude!,
            dbDest.longitude!,
            osmDest.latitude!,
            osmDest.longitude!,
          );
          return distance <
              0.2; // Reduced to < 200m to be safer with fuzzy name matching
        }
      }
      return false;
    });

    if (!isDuplicate) {
      combinedResults.add(osmDest);
    }
  }

  // 4. Sort / Prioritize
  // Remove strict duplicates by key
  final uniqueResults = <String, Destination>{};
  for (final destination in combinedResults) {
    final key =
        '${destination.name.toLowerCase()}_${destination.latitude}_${destination.longitude}';
    uniqueResults.putIfAbsent(key, () => destination);
  }
  var mergedList = uniqueResults.values.toList();

  final exactMatches =
      mergedList
          .where((dest) => dest.name.toLowerCase() == queryLower)
          .toList();
  final strictMatches =
      mergedList
          .where(
            (dest) => _workerMatchesSearchQuery(
              dest.name.toLowerCase(),
              queryLower,
              tokens,
            ),
          )
          .toList();

  List<Destination> prioritizedResults;
  if (exactMatches.isNotEmpty) {
    final remaining =
        mergedList
            .where((dest) => dest.name.toLowerCase() != queryLower)
            .toList();
    remaining.sort((a, b) => _workerCompareRelevance(a, b, queryLower, tokens));
    prioritizedResults = [...exactMatches, ...remaining];
  } else if (strictMatches.isNotEmpty) {
    strictMatches.sort(
      (a, b) => _workerCompareRelevance(a, b, queryLower, tokens),
    );
    final remaining =
        mergedList.where((dest) => !strictMatches.contains(dest)).toList()
          ..sort((a, b) => _workerCompareRelevance(a, b, queryLower, tokens));
    prioritizedResults = [...strictMatches, ...remaining];
  } else {
    mergedList.sort(
      (a, b) => _workerCompareRelevance(a, b, queryLower, tokens),
    );
    prioritizedResults = mergedList;
  }

  return prioritizedResults;
}

// Standalone helper functions for Worker
bool _workerMatchesSearchQuery(
  String nameLower,
  String queryLower,
  List<String> tokens,
) {
  if (nameLower == queryLower) return true;
  if (nameLower.startsWith(queryLower)) return true;
  if (nameLower.contains(' $queryLower ') ||
      nameLower.contains(' $queryLower') ||
      nameLower.endsWith(' $queryLower')) {
    return true;
  }
  if (nameLower.contains(queryLower)) return true;

  if (tokens.isNotEmpty) {
    final allTokensMatch = tokens.every((token) => nameLower.contains(token));
    if (allTokensMatch) return true;
    if (queryLower.length <= 3 &&
        tokens.any((token) => nameLower.contains(token))) {
      return true;
    }
  }
  return false;
}

double _workerCalculateDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  // OPTIMIZATION: Bounding box check before heavy trig
  // 0.01 degrees is roughly 1.1km. We care about < 0.5km.
  if ((lat1 - lat2).abs() > 0.01 || (lon1 - lon2).abs() > 0.01) {
    return 10.0; // Return a value > 0.5
  }

  const double earthRadius = 6371; // km
  final dLat = (lat2 - lat1) * (math.pi / 180);
  final dLon = (lon2 - lon1) * (math.pi / 180);

  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * (math.pi / 180)) *
          math.cos(lat2 * (math.pi / 180)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  final c = 2 * math.asin(math.sqrt(a));
  return earthRadius * c;
}

int _workerCompareRelevance(
  Destination a,
  Destination b,
  String queryLower,
  List<String> tokens,
) {
  final scoreA = _workerCalculateScore(a.name, queryLower, tokens);
  final scoreB = _workerCalculateScore(b.name, queryLower, tokens);

  if (scoreA != scoreB) {
    return scoreA.compareTo(scoreB);
  }
  if (a.name.length != b.name.length) {
    return a.name.length.compareTo(b.name.length);
  }
  return a.name.toLowerCase().compareTo(b.name.toLowerCase());
}

int _workerCalculateScore(String name, String queryLower, List<String> tokens) {
  final nameLower = name.toLowerCase();
  int score = 1000;

  if (nameLower == queryLower) return 0;

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

extension MapSearchExtension on _MapPageState {
  /// Xử lý thay đổi focus của search
  void _handleSearchFocusChange() {
    final shouldShow = _searchFocusNode.hasFocus;
    if (_isSearchOverlayVisible != shouldShow) {
      setState(() {
        _isSearchOverlayVisible = shouldShow;
      });
    }

    if (_searchFocusNode.hasFocus &&
        _searchController.text.isNotEmpty &&
        !_isFetchingDestinations) {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        _performSearch(query);
      }
    }
  }

  /// Xử lý thay đổi text trong search box với debounce
  void _onSearchChanged(String value) {
    _searchDebounceTimer?.cancel();

    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        _filteredDestinations = _destinations.take(10).toList();
        _isFetchingDestinations = false;
        _isSearchOverlayVisible = _searchFocusNode.hasFocus;
      });
      return;
    }

    if (_searchFocusNode.hasFocus && !_isSearchOverlayVisible) {
      setState(() {
        _isSearchOverlayVisible = true;
      });
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  /// Thực hiện tìm kiếm
  Future<void> _performSearch(String query) async {
    final queryTrimmed = query.trim();
    if (queryTrimmed.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isFetchingDestinations = true;
      });
    }

    // OPTIMIZATION: Phase 1 - Instant Local Search
    // Filter DB results immediately on main thread for instant feedback
    try {
      final queryLower = queryTrimmed.toLowerCase();
      final tokens =
          queryLower.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

      final localResults =
          _destinations
              .where((destination) {
                final nameLower = destination.name.toLowerCase();
                return _workerMatchesSearchQuery(nameLower, queryLower, tokens);
              })
              .take(15)
              .toList(); /* Take slightly more than display limit */

      if (mounted && _searchController.text.trim() == queryTrimmed) {
        setState(() {
          _filteredDestinations = localResults;
          // Don't turn off loading yet, waiting for OSM
        });
      }
    } catch (e) {
      print('Error in local search phase: $e');
    }

    try {
      // Phase 2: Fetch OSM results (Async/IO)
      List<Destination> osmResults = [];
      if (queryTrimmed.length >= 2) {
        try {
          final osmPOIs = await _osmService.searchPlaces(
            queryTrimmed,
            limit: 25,
          );

          osmResults =
              osmPOIs
                  .where(
                    (poi) =>
                        poi.position != null &&
                        poi.name != null &&
                        poi.name!.isNotEmpty &&
                        poi.name != 'Unnamed Place' &&
                        poi.name!.length >= 2,
                  )
                  .map(
                    (poi) => Destination.fromOSMPOI(
                      poi.id ?? '',
                      poi.name!,
                      poi.latitude!,
                      poi.longitude!,
                      poi.type,
                    ),
                  )
                  .toList();
        } catch (e) {
          print('Error searching OSM: $e');
        }
      }

      if (!mounted || _searchController.text.trim() != queryTrimmed) {
        return;
      }

      // Phase 3: Merge & Deduplicate (Heavy CPU -> Isolate)
      final results = await compute(
        _searchWorker,
        _SearchWorkerArgs(
          dbDestinations: _destinations,
          osmDestinations: osmResults,
          query: queryTrimmed,
          userPosition: _currentPosition,
        ),
      );

      if (mounted && _searchController.text.trim() == queryTrimmed) {
        setState(() {
          _filteredDestinations = results.take(20).toList();
          _isFetchingDestinations = false;
          // Ensure overlay is visible if we have results
          if (!_isSearchOverlayVisible &&
              (results.isNotEmpty || _searchFocusNode.hasFocus)) {
            _isSearchOverlayVisible = true;
          }
        });
      }
    } catch (e) {
      print('Error in properties search: $e');
      if (mounted && _searchController.text.trim() == queryTrimmed) {
        setState(() {
          _isFetchingDestinations = false;
        });
      }
    }
  }

  /// Xóa search
  void _clearSearch() {
    _searchDebounceTimer?.cancel();
    _searchController.clear();
    setState(() {
      _filteredDestinations = _destinations.take(10).toList();
      _isFetchingDestinations = false;
      _isSearchOverlayVisible = _searchFocusNode.hasFocus;
    });
    FocusScope.of(context).requestFocus(_searchFocusNode);
  }

  /// Đóng search overlay
  void _dismissSearchOverlay() {
    if (_searchController.text.isEmpty) {
      final wasFocused = _searchFocusNode.hasFocus;
      if (wasFocused) {
        _searchFocusNode.unfocus();
      }

      if (_isSearchOverlayVisible) {
        setState(() {
          _isSearchOverlayVisible = false;
        });
      }
    }
  }

  /// Load destinations từ server
  Future<void> _loadDestinations() async {
    setState(() {
      _isFetchingDestinations = true;
      _destinationFetchError = null;
    });

    try {
      final result = await sl<GetDestinationUseCase>().call(
        DestinationQuery(offset: 0, limit: 500, available: true),
      );

      if (!mounted) {
        return;
      }

      result.fold(
        (failure) {
          print(
            'Warning: Failed to load destinations from server: ${failure.message}',
          );
          setState(() {
            _isFetchingDestinations = false;
            _destinationFetchError = null;
            _destinations = [];
            _filteredDestinations = [];
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
            _destinationFetchError = null;
          });
        },
      );
    } catch (e) {
      print('Error loading destinations: $e');
      if (mounted) {
        setState(() {
          _isFetchingDestinations = false;
          _destinationFetchError = null;
          _destinations = [];
          _filteredDestinations = [];
        });
      }
    }
  }
}

String _removeDiacritics(String str) {
  var withDiacritics =
      'áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệóòỏõọôốồổỗộơớờởỡợíìỉĩịúùủũụưứừửữựýỳỷỹỵđ';
  var withoutDiacritics =
      'aaaaaaaaaaaaaaaaaeeeeeeeeeeeooooooooooooooooiiiiiuuuuuuuuuuuyyyyyd';

  for (int i = 0; i < withDiacritics.length; i++) {
    str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
  }
  return str;
}
