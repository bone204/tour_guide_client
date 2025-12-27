import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/add_stop_media.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_stop_detail.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_stop_media.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_state.dart';

class StopMediaCubit extends Cubit<StopMediaState> {
  final AddStopMediaUseCase _addStopMediaUseCase;
  final GetStopDetailUseCase _getStopDetailUseCase;
  final DeleteStopMediaUseCase _deleteStopMediaUseCase;

  StopMediaCubit(
    this._addStopMediaUseCase,
    this._getStopDetailUseCase,
    this._deleteStopMediaUseCase,
  ) : super(StopMediaInitial());

  Future<void> loadStop(int itineraryId, int stopId) async {
    emit(StopMediaLoading());
    final result = await _getStopDetailUseCase(
      GetStopDetailParams(itineraryId: itineraryId, stopId: stopId),
    );
    result.fold(
      (failure) => emit(StopMediaFailure(failure.message)),
      (stop) => emit(StopMediaLoaded(stop)),
    );
  }

  Future<void> uploadMedia({
    required int itineraryId,
    required int stopId,
    List<String> imagePaths = const [],
    List<String> videoPaths = const [],
  }) async {
    emit(StopMediaLoading());
    final result = await _addStopMediaUseCase(
      itineraryId: itineraryId,
      stopId: stopId,
      imagePaths: imagePaths,
      videoPaths: videoPaths,
    );

    result.fold(
      (failure) => emit(StopMediaFailure(failure.message)),
      (stop) => emit(StopMediaUploaded(stop)),
    );
  }

  Future<void> deleteMedia({
    required int itineraryId,
    required int stopId,
    List<String> images = const [],
    List<String> videos = const [],
  }) async {
    emit(StopMediaLoading());
    final result = await _deleteStopMediaUseCase(
      itineraryId: itineraryId,
      stopId: stopId,
      images: images,
      videos: videos,
    );

    result.fold(
      (failure) => emit(StopMediaFailure(failure.message)),
      (stop) => emit(StopMediaUploaded(stop)),
    );
  }

  MediaType _currentType = MediaType.image;
  List<String> get media =>
      _currentType == MediaType.image
          ? (state is StopMediaLoaded
              ? (state as StopMediaLoaded).stop.images
              : (state is StopMediaUploaded
                  ? (state as StopMediaUploaded).stop.images
                  : []))
          : (state is StopMediaLoaded
              ? (state as StopMediaLoaded).stop.videos
              : (state is StopMediaUploaded
                  ? (state as StopMediaUploaded).stop.videos
                  : []));

  void init(Stop stop, MediaType type) {
    _currentType = type;
    emit(StopMediaLoaded(stop));
  }

  @override
  void emit(StopMediaState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}

enum MediaType { image, video }
