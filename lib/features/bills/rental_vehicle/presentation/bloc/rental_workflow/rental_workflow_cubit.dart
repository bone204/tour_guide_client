import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/user_pickup.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/user_return_request.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/rental_workflow/rental_workflow_state.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/user_pickup_params.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/user_return_request_params.dart';

class RentalWorkflowCubit extends Cubit<RentalWorkflowState> {
  final UserPickupUseCase userPickupUseCase;
  final UserReturnRequestUseCase userReturnRequestUseCase;

  RentalWorkflowCubit({
    required this.userPickupUseCase,
    required this.userReturnRequestUseCase,
  }) : super(const RentalWorkflowState());

  Future<void> pickupVehicle(int id, File selfie) async {
    if (isClosed) return;
    emit(state.copyWith(status: RentalWorkflowStatus.loading));
    final result = await userPickupUseCase(
      UserPickupParams(id: id, selfie: selfie),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RentalWorkflowStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: RentalWorkflowStatus.success,
          action: RentalWorkflowAction.pickup,
          successMessage: null,
        ),
      ),
    );
  }

  Future<void> returnRequest(
    int id,
    List<File> photos,
    double lat,
    double long,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: RentalWorkflowStatus.loading));
    final result = await userReturnRequestUseCase(
      UserReturnRequestParams(
        id: id,
        photos: photos,
        latitude: lat,
        longitude: long,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RentalWorkflowStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: RentalWorkflowStatus.success,
          action: RentalWorkflowAction.returnRequest,
          successMessage: null,
        ),
      ),
    );
  }
}
