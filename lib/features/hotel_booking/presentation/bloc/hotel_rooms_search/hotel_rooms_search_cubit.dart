import 'package:bloc/bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/usecases/get_hotel_rooms_usecase.dart';
import 'hotel_rooms_search_state.dart';

class HotelRoomsSearchCubit extends Cubit<HotelRoomsSearchState> {
  final GetHotelRoomsUseCase getHotelRoomsUseCase;

  HotelRoomsSearchCubit(this.getHotelRoomsUseCase)
    : super(HotelRoomsSearchInitial());

  Future<void> searchHotels({
    required double latitude,
    required double longitude,
  }) async {
    if (isClosed) return;

    emit(HotelRoomsSearchLoading());

    final request = HotelRoomSearchRequest(
      latitude: latitude,
      longitude: longitude,
    );

    final result = await getHotelRoomsUseCase(request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(HotelRoomsSearchFailure(_mapFailureToMessage(failure))),
      (hotels) => emit(HotelRoomsSearchSuccess(hotels)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return "Unexpected Error";
  }
}
