import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/like_itinerary_usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/unlike_itinerary_usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/like_itinerary/like_itinerary_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class LikeItineraryCubit extends Cubit<LikeItineraryState> {
  final LikeItineraryUseCase _likeUseCase = sl<LikeItineraryUseCase>();
  final UnlikeItineraryUseCase _unlikeUseCase = sl<UnlikeItineraryUseCase>();

  LikeItineraryCubit() : super(LikeItineraryInitial());

  void init(int itineraryId, bool isLiked, int likeCount) {
    if (isClosed) return;
    emit(
      LikeItineraryUpdate(
        itineraryId: itineraryId,
        isLiked: isLiked,
        likeCount: likeCount,
      ),
    );
  }

  Future<void> toggleLike(
    int itineraryId,
    bool isLiked,
    int currentCount,
  ) async {
    if (isClosed) return;
    // Optimistic Update
    final newIsLiked = !isLiked;
    final newCount = newIsLiked ? currentCount + 1 : currentCount - 1;

    emit(
      LikeItineraryUpdate(
        itineraryId: itineraryId,
        isLiked: newIsLiked,
        likeCount: newCount,
      ),
    );

    final result =
        newIsLiked
            ? await _likeUseCase(itineraryId)
            : await _unlikeUseCase(itineraryId);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        // Revert on failure
        emit(
          LikeItineraryUpdate(
            itineraryId: itineraryId,
            isLiked: isLiked,
            likeCount: currentCount,
          ),
        );
        emit(LikeItineraryFailure(message: failure.message));
      },
      (success) {
        // Success - State is already optimistically updated
      },
    );
  }
}
