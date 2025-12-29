import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_owner_rental_bills.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_owner_rental_bills/get_owner_rental_bills_state.dart';

class GetOwnerRentalBillsCubit extends Cubit<GetOwnerRentalBillsState> {
  final GetOwnerRentalBillsUseCase _getOwnerRentalBillsUseCase;

  GetOwnerRentalBillsCubit(this._getOwnerRentalBillsUseCase)
    : super(const GetOwnerRentalBillsState());

  Future<void> getBills({String? status}) async {
    emit(state.copyWith(status: GetOwnerRentalBillsStatus.loading));

    final result = await _getOwnerRentalBillsUseCase(status);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GetOwnerRentalBillsStatus.error,
          message: failure.message,
        ),
      ),
      (bills) => emit(
        state.copyWith(status: GetOwnerRentalBillsStatus.loaded, bills: bills),
      ),
    );
  }
}
