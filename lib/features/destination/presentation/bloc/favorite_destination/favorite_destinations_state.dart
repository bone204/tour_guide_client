import 'package:equatable/equatable.dart';

class FavoriteDestinationsState extends Equatable {
  final Set<int> favoriteIds;
  final bool isLoading;
  final bool hasLoaded;
  final String? lastErrorMessage;

  FavoriteDestinationsState({
    required Set<int> favoriteIds,
    required this.isLoading,
    required this.hasLoaded,
    this.lastErrorMessage,
  }) : favoriteIds = Set.unmodifiable(favoriteIds);

  factory FavoriteDestinationsState.initial() {
    return FavoriteDestinationsState(
      favoriteIds: <int>{},
      isLoading: false,
      hasLoaded: false,
      lastErrorMessage: null,
    );
  }

  FavoriteDestinationsState copyWith({
    Set<int>? favoriteIds,
    bool? isLoading,
    bool? hasLoaded,
    String? lastErrorMessage,
    bool resetError = false,
  }) {
    return FavoriteDestinationsState(
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
