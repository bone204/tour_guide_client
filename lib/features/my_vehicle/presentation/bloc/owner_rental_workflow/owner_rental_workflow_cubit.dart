import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/owner_confirm_return.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/owner_delivered.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/owner_delivering.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/owner_rental_workflow/owner_rental_workflow_state.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/owner_delivered_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/owner_confirm_return_params.dart';

class OwnerRentalWorkflowCubit extends Cubit<OwnerRentalWorkflowState> {
  final OwnerDeliveringUseCase ownerDeliveringUseCase;
  final OwnerDeliveredUseCase ownerDeliveredUseCase;
  final OwnerConfirmReturnUseCase ownerConfirmReturnUseCase;

  OwnerRentalWorkflowCubit({
    required this.ownerDeliveringUseCase,
    required this.ownerDeliveredUseCase,
    required this.ownerConfirmReturnUseCase,
  }) : super(const OwnerRentalWorkflowState());

  Future<void> startDelivering(int id) async {
    if (isClosed) return;
    emit(state.copyWith(status: OwnerRentalWorkflowStatus.loading));
    final result = await ownerDeliveringUseCase(id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OwnerRentalWorkflowStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: OwnerRentalWorkflowStatus.success,
          action: OwnerRentalWorkflowAction.startDelivering,
          successMessage: null,
        ),
      ),
    );
  }

  Future<void> confirmDelivered(int id, List<File> photos) async {
    if (isClosed) return;
    emit(state.copyWith(status: OwnerRentalWorkflowStatus.loading));
    final result = await ownerDeliveredUseCase(
      OwnerDeliveredParams(id: id, photos: photos),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OwnerRentalWorkflowStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: OwnerRentalWorkflowStatus.success,
          action: OwnerRentalWorkflowAction.confirmDelivered,
          successMessage: null,
        ),
      ),
    );
  }

  Future<void> confirmReturn(
    int id,
    List<File> photos,
    double lat,
    double long,
    bool? overtimeFeeAccepted,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: OwnerRentalWorkflowStatus.loading));
    final result = await ownerConfirmReturnUseCase(
      OwnerConfirmReturnParams(
        id: id,
        photos: photos,
        latitude: lat,
        longitude: long,
        overtimeFeeAccepted: overtimeFeeAccepted,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OwnerRentalWorkflowStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: OwnerRentalWorkflowStatus.success,
          action: OwnerRentalWorkflowAction.confirmReturn,
          successMessage: null,
        ),
      ),
    );
  }
}
