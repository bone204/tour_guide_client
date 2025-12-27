import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_destination_by_id.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/get_destination_by_id_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetDestinationByIdCubit extends Cubit<GetDestinationByIdState> {
  GetDestinationByIdCubit() : super(GetDestinationByIdInitial());

  Future<Either<Failure, Destination>> getDestinationById(int id) async {
    emit(GetDestinationByIdLoading());

    final result = await sl<GetDestinationByIdUseCase>().call(id);

    result.fold(
      (failure) => emit(GetDestinationByIdError(failure.message)),
      (destination) => emit(GetDestinationByIdLoaded(destination)),
    );

    return result;
  }

  @override
  void emit(GetDestinationByIdState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
