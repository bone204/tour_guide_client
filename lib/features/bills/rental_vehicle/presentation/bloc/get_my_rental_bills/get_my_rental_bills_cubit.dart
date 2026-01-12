import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/get_my_rental_bills_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_my_rental_bills/rental_bill_list_state.dart';

class GetMyRentalBillsCubit extends Cubit<RentalBillListState> {
  final GetMyRentalBillsUseCase _getMyRentalBillsUseCase;

  final List<StreamSubscription> _subscriptions = [];

  GetMyRentalBillsCubit(this._getMyRentalBillsUseCase)
    : super(const RentalBillListState()) {
    _subscriptions.add(
      eventBus.on<RentalBillUpdatedEvent>().listen((event) {
        loadMyBills();
      }),
    );
    _subscriptions.add(
      eventBus.on<RentalSocketNotificationReceivedEvent>().listen((event) {
        loadMyBills();
      }),
    );
  }

  @override
  Future<void> close() {
    for (var s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  Future<void> loadMyBills({RentalBillStatus? status}) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: RentalBillListStatus.loading,
        filterStatus: status,
      ),
    );

    final result = await _getMyRentalBillsUseCase(status);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RentalBillListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (bills) => emit(
        state.copyWith(status: RentalBillListStatus.success, bills: bills),
      ),
    );
  }
}
