import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_details_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_reorder_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_time_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/edit_stop_details.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/edit_stop_reorder.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/edit_stop_time.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/edit_stop/edit_stop_state.dart';

class EditStopCubit extends Cubit<EditStopState> {
  final EditStopTimeUseCase _editStopTimeUseCase;
  final EditStopReorderUseCase _editStopReorderUseCase;
  final EditStopDetailsUseCase _editStopDetailsUseCase;

  EditStopCubit(
    this._editStopTimeUseCase,
    this._editStopReorderUseCase,
    this._editStopDetailsUseCase,
  ) : super(EditStopInitial());

  // This function attempts to update all changed fields.
  // For now, we will assume sequential updates if multiple fields are changed,
  // or the UI can call specific methods.
  // Let's implement a comprehensive update method that the UI can call.
  Future<void> updateStop({
    required int itineraryId,
    required Stop originalStop,
    String? newStartTime,
    String? newEndTime,
    String? newNotes,
    int? newDayOrder,
    int? newSequence,
  }) async {
    emit(EditStopLoading());

    Stop updatedStop = originalStop;
    String successMessages = '';

    // 1. Update Time if changed
    if (newStartTime != null &&
        newEndTime != null &&
        (newStartTime != originalStop.startTime ||
            newEndTime != originalStop.endTime)) {
      final result = await _editStopTimeUseCase(
        EditStopTimeParams(
          itineraryId: itineraryId,
          stopId: originalStop.id,
          request: EditStopTimeRequest(
            startTime: newStartTime,
            endTime: newEndTime,
          ),
        ),
      );

      final failureOrStop = result.fold((l) => l, (r) => r);
      if (failureOrStop is Stop) {
        updatedStop = failureOrStop;
        successMessages += 'Time updated. ';
      } else {
        // If time update fails, we might still want to try others or stop.
        // For simplicity, let's stop and error out.
        emit(
          EditStopFailure(
            message: 'Failed to update time: ${failureOrStop.toString()}',
          ),
        );
        return;
      }
    }

    // 2. Update Reorder if changed
    if ((newDayOrder != null && newDayOrder != originalStop.dayOrder) ||
        (newSequence != null && newSequence != originalStop.sequence)) {
      // Note: using updatedStop to carry over previous changes if any
      // But wait, reorder endpoint might return new Stop structure.

      final day = newDayOrder ?? updatedStop.dayOrder;
      final seq = newSequence ?? updatedStop.sequence;

      final result = await _editStopReorderUseCase(
        EditStopReorderParams(
          itineraryId: itineraryId,
          stopId: updatedStop.id,
          request: EditStopReorderRequest(dayOrder: day, sequence: seq),
        ),
      );

      final failureOrStop = result.fold((l) => l, (r) => r);
      if (failureOrStop is Stop) {
        updatedStop = failureOrStop;
        successMessages += 'Order updated. ';
      } else {
        emit(
          EditStopFailure(
            message: 'Failed to update order: ${failureOrStop.toString()}',
          ),
        );
        return;
      }
    }

    // 3. Update Details if changed
    if (newNotes != null && newNotes != originalStop.notes) {
      final result = await _editStopDetailsUseCase(
        EditStopDetailsParams(
          itineraryId: itineraryId,
          stopId: updatedStop.id,
          request: EditStopDetailsRequest(notes: newNotes),
        ),
      );

      final failureOrStop = result.fold((l) => l, (r) => r);
      if (failureOrStop is Stop) {
        updatedStop = failureOrStop;
        successMessages += 'Notes updated. ';
      } else {
        emit(
          EditStopFailure(
            message: 'Failed to update notes: ${failureOrStop.toString()}',
          ),
        );
        return;
      }
    }

    if (successMessages.isEmpty) {
      // Handling "No changes" gracefully, but effectively success with no-op
      // Let's emit success with original stop.
      emit(EditStopSuccess(stop: originalStop, message: 'No changes detected'));
    } else {
      emit(EditStopSuccess(stop: updatedStop, message: successMessages.trim()));
    }
  }
}
