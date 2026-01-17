import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/get_my_hotel_bills_usecase.dart';
import 'dart:async';
import 'package:tour_guide_app/core/events/app_events.dart';

part 'get_my_hotel_bills_state.dart';

class GetMyHotelBillsCubit extends Cubit<GetMyHotelBillsState> {
  final GetMyHotelBillsUseCase getMyHotelBillsUseCase;
  StreamSubscription? _subscription;
  HotelBillStatus? _currentStatus;

  GetMyHotelBillsCubit(this.getMyHotelBillsUseCase)
    : super(GetMyHotelBillsInitial()) {
    _subscription = eventBus.on<HotelBillCancelledEvent>().listen((event) {
      getMyBills(status: _currentStatus);
    });

    // Listen to bill updates (e.g., payment success)
    eventBus.on<HotelBillUpdatedEvent>().listen((event) {
      getMyBills(status: _currentStatus);
    });
  }

  Future<void> getMyBills({HotelBillStatus? status}) async {
    if (isClosed) return;
    // Update local status tracking if a status is explicitly provided
    // If status is passed as null, it might mean "fetch all" OR "reload current".
    // For now, if status is provided, we update _currentStatus.
    // If we want to support "switching to All", we might need to handle that carefully.
    // Assuming calling with null means "All" or "Default".
    _currentStatus = status;

    emit(GetMyHotelBillsLoading());
    final result = await getMyHotelBillsUseCase(status: status);
    if (isClosed) return;
    result.fold(
      (failure) => emit(GetMyHotelBillsFailure(_mapFailureToMessage(failure))),
      (bills) => emit(GetMyHotelBillsSuccess(bills)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return "Unexpected Error";
  }
}
