import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/voucher/domain/usecases/get_vouchers_use_case.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_vouchers/get_vouchers_state.dart';

class GetVouchersCubit extends Cubit<GetVouchersState> {
  final GetVouchersUseCase getVouchersUseCase;

  GetVouchersCubit(this.getVouchersUseCase) : super(GetVouchersInitial());

  Future<void> getVouchers() async {
    emit(GetVouchersLoading());
    final result = await getVouchersUseCase(NoParams());
    result.fold(
      (failure) => emit(GetVouchersError(failure.message)),
      (vouchers) => emit(GetVouchersLoaded(vouchers)),
    );
  }
}
