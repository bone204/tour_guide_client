import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/usecases/get_hotel_rooms_usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/find_hotel/find_hotel_state.dart';

class FindHotelCubit extends Cubit<FindHotelState> {
  final GetHotelRoomsUseCase _getHotelRoomsUseCase;

  FindHotelCubit(this._getHotelRoomsUseCase) : super(FindHotelInitial());

  Future<void> findHotels(HotelRoomSearchRequest request) async {
    if (isClosed) return;
    emit(FindHotelLoading());
    final result = await _getHotelRoomsUseCase(request);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(FindHotelFailure(failure.message));
      },
      (hotels) {
        if (!isClosed) emit(FindHotelSuccess(hotels));
      },
    );
  }
}
