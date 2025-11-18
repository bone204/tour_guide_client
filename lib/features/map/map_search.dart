part of map_page;

// ignore_for_file: invalid_use_of_protected_member
extension MapSearchExtension on _MapPageState {
  /// Xử lý thay đổi focus của search
  void _handleSearchFocusChange() {
    // Chỉ hiện search overlay khi có focus HOẶC (có text VÀ đang focus)
    // Không tự động hiện khi chỉ có text mà không có focus
    final shouldShow = _searchFocusNode.hasFocus;
    if (_isSearchOverlayVisible != shouldShow) {
      setState(() {
        _isSearchOverlayVisible = shouldShow;
      });
    }
    
    // Khi focus vào search box và có text, search lại để đảm bảo kết quả đúng
    if (_searchFocusNode.hasFocus && 
        _searchController.text.isNotEmpty && 
        !_isFetchingDestinations) {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        // Search ngay lập tức khi focus (không debounce vì đây là hành động của user)
        // Điều này đảm bảo kết quả luôn được refresh khi user focus lại
        _performSearch(query);
      }
    }
  }

  /// Xử lý thay đổi text trong search box với debounce
  void _onSearchChanged(String value) {
    // Hủy timer cũ nếu có
    _searchDebounceTimer?.cancel();
    
    final query = value.trim();
    
    // Nếu query rỗng, xử lý ngay lập tức
    if (query.isEmpty) {
      setState(() {
        _filteredDestinations = _destinations.take(10).toList();
        _isFetchingDestinations = false;
        _isSearchOverlayVisible = _searchFocusNode.hasFocus;
      });
      return;
    }

    // Chỉ hiện search overlay nếu đang focus vào search box
    if (_searchFocusNode.hasFocus && !_isSearchOverlayVisible) {
      setState(() {
        _isSearchOverlayVisible = true;
      });
    }

    // Debounce search - đợi 400ms sau khi user ngừng gõ
    _searchDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  /// Thực hiện tìm kiếm
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      return;
    }

    final queryLower = query.toLowerCase();
    final tokens = queryLower
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList();

    // Hiển thị loading state
    if (mounted) {
      setState(() {
        _isFetchingDestinations = true;
      });
    }

    try {
      // Tìm kiếm trong database destinations (nếu có) - đồng bộ, nhanh
      final dbResults = _destinations
          .where((destination) {
            final nameLower = destination.name.toLowerCase();
            return _matchesSearchQuery(nameLower, queryLower, tokens);
          })
          .toList();

      // Tìm kiếm trong OSM - bất đồng bộ, chỉ khi query >= 2 ký tự
      List<Destination> osmResults = [];
      if (query.length >= 2) {
        try {
          // Tìm kiếm với limit lớn hơn để có nhiều kết quả
          final osmPOIs = await _osmService.searchPlaces(query, limit: 25);
          print('OSM search returned ${osmPOIs.length} results for query: $query');
          
          // Chuyển đổi tất cả POIs thành Destinations, không filter ngay
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
              .toList();
          
          print('OSM results after basic filtering: ${osmResults.length}');
          
          // Chỉ filter bằng matching query nếu có nhiều kết quả (>10)
          // Nếu ít kết quả, hiển thị tất cả để user có thể chọn
          if (osmResults.length > 10) {
            osmResults = osmResults
                .where((destination) {
                  final nameLower = destination.name.toLowerCase();
                  // Nới lỏng matching - chỉ cần chứa ít nhất một token
                  if (tokens.isEmpty) {
                    return nameLower.contains(queryLower);
                  }
                  // Nếu có tokens, chỉ cần một token khớp
                  return tokens.any((token) => nameLower.contains(token)) ||
                         _matchesSearchQuery(nameLower, queryLower, tokens);
                })
                .toList();
            print('OSM results after query matching: ${osmResults.length}');
          }
        } catch (e) {
          // Log lỗi nhưng không chặn việc hiển thị kết quả từ DB
          print('Error searching OSM: $e');
          // Vẫn tiếp tục với kết quả từ DB nếu có
        }
      }

      // Kiểm tra nếu query đã thay đổi trong lúc search (race condition)
      if (!mounted || _searchController.text.trim() != query) {
        return;
      }

      // Kết hợp kết quả: DB destinations trước, sau đó OSM
      final combinedResults = <Destination>[];
      combinedResults.addAll(dbResults);
      
      // Thêm OSM results nhưng loại bỏ trùng lặp (nới lỏng filter)
      for (final osmDest in osmResults) {
        // Kiểm tra tên hợp lệ (đã được filter ở trên)
        if (osmDest.name.isEmpty || 
            osmDest.name.length < 2 ||
            osmDest.name == 'Unnamed Place') {
          continue;
        }
        
        // Chỉ loại bỏ các tên rõ ràng không phù hợp
        final nameLower = osmDest.name.toLowerCase();
        if (RegExp(r'^\d+$').hasMatch(osmDest.name) ||
            (nameLower.contains('km') && nameLower.length < 10) ||
            (nameLower.startsWith('số nhà') && nameLower.length < 15) ||
            (nameLower.contains('house number') && nameLower.length < 20)) {
          continue;
        }
        
        // Kiểm tra trùng lặp với DB destinations (nới lỏng hơn)
        final isDuplicate = combinedResults.any((dbDest) {
          final dbNameLower = dbDest.name.toLowerCase();
          final osmNameLower = osmDest.name.toLowerCase();
          
          // So sánh tên (tương đối) - nới lỏng hơn
          if (dbNameLower == osmNameLower ||
              (dbNameLower.contains(osmNameLower) && osmNameLower.length > 5) ||
              (osmNameLower.contains(dbNameLower) && dbNameLower.length > 5)) {
            // Kiểm tra nếu vị trí gần nhau (trong vòng 500m - nới lỏng hơn)
            if (dbDest.latitude != null && dbDest.longitude != null &&
                osmDest.latitude != null && osmDest.longitude != null) {
              final distance = _calculateDistance(
                dbDest.latitude!,
                dbDest.longitude!,
                osmDest.latitude!,
                osmDest.longitude!,
              );
              return distance < 0.5; // ~500m (nới lỏng từ 200m)
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
          .where((dest) => _matchesSearchQuery(dest.name.toLowerCase(), queryLower, tokens))
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

      // Kiểm tra lại query trước khi update state
      if (mounted && _searchController.text.trim() == query) {
        setState(() {
          _filteredDestinations = prioritizedResults.take(20).toList();
          _isFetchingDestinations = false;
          // Đảm bảo search overlay luôn hiển thị khi có kết quả hoặc đang loading
          if (!_isSearchOverlayVisible && (prioritizedResults.isNotEmpty || _isFetchingDestinations)) {
            _isSearchOverlayVisible = true;
          }
        });
      }
    } catch (e) {
      // Xử lý lỗi
      print('Error in search: $e');
      if (mounted && _searchController.text.trim() == query) {
        setState(() {
          _isFetchingDestinations = false;
        });
      }
    }
  }

  /// Tính khoảng cách giữa 2 điểm (đơn vị: km)
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

  /// Kiểm tra xem tên có khớp với query không (cải thiện thuật toán)
  bool _matchesSearchQuery(String nameLower, String queryLower, List<String> tokens) {
    // Khớp chính xác
    if (nameLower == queryLower) {
      return true;
    }
    
    // Bắt đầu bằng query
    if (nameLower.startsWith(queryLower)) {
      return true;
    }
    
    // Chứa query như một từ hoàn chỉnh
    if (nameLower.contains(' $queryLower ') || 
        nameLower.contains(' $queryLower') ||
        nameLower.endsWith(' $queryLower')) {
      return true;
    }
    
    // Chứa query
    if (nameLower.contains(queryLower)) {
      return true;
    }
    
    // Nếu có tokens, kiểm tra khớp tokens
    if (tokens.isNotEmpty) {
      // Tất cả tokens phải có trong tên
      final allTokensMatch = tokens.every((token) => nameLower.contains(token));
      if (allTokensMatch) {
        return true;
      }
      
      // Ít nhất một token khớp (cho query ngắn)
      if (queryLower.length <= 3 && tokens.any((token) => nameLower.contains(token))) {
        return true;
      }
    }
    
    return false;
  }

  // Removed _matchesTokens - no longer used, replaced by _matchesSearchQuery

  /// So sánh destinations theo độ liên quan
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

  /// Tính điểm liên quan
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
    // Chỉ đóng nếu không có text trong search box
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
          // Không chặn search OSM khi server lỗi, chỉ log lỗi
          print('Warning: Failed to load destinations from server: ${failure.message}');
          setState(() {
            _isFetchingDestinations = false;
            // Không set error để vẫn có thể search OSM
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
      // Xử lý lỗi không mong đợi, vẫn cho phép search OSM
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

