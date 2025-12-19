import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/create_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/create_itinerary.dart';

part 'create_itinerary_state.dart';

class CreateItineraryCubit extends Cubit<CreateItineraryState> {
  final CreateItineraryUseCase _createItineraryUseCase;

  CreateItineraryCubit({required CreateItineraryUseCase createItineraryUseCase})
    : _createItineraryUseCase = createItineraryUseCase,
      super(const CreateItineraryState());

  void initialize(String province) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));

    emit(
      state.copyWith(
        province: province,
        startDate: tomorrow,
        endDate: dayAfterTomorrow,
      ),
    );
  }

  void nameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void dateChanged({DateTime? startDate, DateTime? endDate}) {
    var newStartDate = startDate ?? state.startDate;
    var newEndDate = endDate ?? state.endDate;

    // Validation: End date cannot be before start date
    if (newStartDate != null &&
        newEndDate != null &&
        newEndDate.isBefore(newStartDate)) {
      newEndDate = newStartDate;
    }

    emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
  }

  Future<void> submitted() async {
    if (!state.isValid) return;

    if (!isClosed) emit(state.copyWith(status: CreateItineraryStatus.loading));

    final request = CreateItineraryRequest(
      name: state.name,
      province: state.province,
      startDate: DateFormat('yyyy-MM-dd').format(state.startDate!),
      endDate: DateFormat('yyyy-MM-dd').format(state.endDate!),
    );

    final result = await _createItineraryUseCase(request);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: CreateItineraryStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (itinerary) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: CreateItineraryStatus.success,
              createdItinerary: itinerary,
            ),
          );
        }
      },
    );
  }
}
