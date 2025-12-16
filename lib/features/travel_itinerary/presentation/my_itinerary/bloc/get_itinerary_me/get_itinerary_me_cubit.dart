import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_itinerary_me.dart';

part 'get_itinerary_me_state.dart';

class GetItineraryMeCubit extends Cubit<GetItineraryMeState> {
  final GetItineraryMeUseCase getItineraryMeUseCase;
  late final StreamSubscription _subscription;

  GetItineraryMeCubit(this.getItineraryMeUseCase)
    : super(GetItineraryMeInitial()) {
    _subscription = eventBus.on<CreateItinerarySuccessEvent>().listen((event) {
      getItineraryMe();
    });
  }

  Future<void> getItineraryMe() async {
    emit(GetItineraryMeLoading());
    final result = await getItineraryMeUseCase.call(NoParams());
    result.fold(
      (failure) => emit(GetItineraryMeFailure(failure.message)),
      (response) => emit(GetItineraryMeSuccess(response.items)),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
