import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/get_cooperations.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_list/cooperation_list_state.dart';

class CooperationListCubit extends Cubit<CooperationListState> {
  final GetCooperationsUseCase getCooperationsUseCase;

  CooperationListCubit({required this.getCooperationsUseCase})
    : super(CooperationListInitial());

  Future<void> getCooperations() async {
    if (isClosed) return;
    emit(CooperationListLoading());

    // Fetch Hotels
    final hotelResult = await getCooperationsUseCase(
      const GetCooperationsParams(type: 'hotel'),
    );

    // Fetch Restaurants
    final restaurantResult = await getCooperationsUseCase(
      const GetCooperationsParams(type: 'restaurant'),
    );

    if (isClosed) return;

    final hotels = hotelResult.fold((l) => <Cooperation>[], (r) => r.items);

    final restaurants = restaurantResult.fold(
      (l) => <Cooperation>[],
      (r) => r.items,
    );

    emit(CooperationListLoaded(hotels: hotels, restaurants: restaurants));
  }
}
