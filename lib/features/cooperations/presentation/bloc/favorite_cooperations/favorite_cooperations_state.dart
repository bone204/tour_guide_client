import 'package:equatable/equatable.dart';

class FavoriteCooperationsState extends Equatable {
  final Set<int> favoriteIds;
  final bool isLoading;
  final bool hasLoaded;
  final String? lastErrorMessage;

  FavoriteCooperationsState({
    required Set<int> favoriteIds,
    required this.isLoading,
    required this.hasLoaded,
    this.lastErrorMessage,
  }) : favoriteIds = Set.unmodifiable(favoriteIds);

  factory FavoriteCooperationsState.initial() {
    return FavoriteCooperationsState(
      favoriteIds: <int>{},
      isLoading: false,
      hasLoaded: false,
      lastErrorMessage: null,
    );
  }

  FavoriteCooperationsState copyWith({
    Set<int>? favoriteIds,
    bool? isLoading,
    bool? hasLoaded,
    String? lastErrorMessage,
    bool resetError = false,
  }) {
    return FavoriteCooperationsState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      lastErrorMessage:
          resetError ? null : lastErrorMessage ?? this.lastErrorMessage,
    );
  }

  String get _favoriteIdsKey {
    if (favoriteIds.isEmpty) return '';
    final sorted = favoriteIds.toList()..sort();
    return sorted.join(',');
  }

  @override
  List<Object?> get props => [
    _favoriteIdsKey,
    isLoading,
    hasLoaded,
    lastErrorMessage,
  ];
}
