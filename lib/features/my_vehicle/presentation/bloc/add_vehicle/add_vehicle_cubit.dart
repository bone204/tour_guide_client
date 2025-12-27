import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/add_vehicle_request.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_catalog.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/add_vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_my_contracts.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_vehicle_catalogs.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  final AddVehicleUseCase _addVehicleUseCase;
  final GetMyContractsUseCase _getMyContractsUseCase;
  final GetVehicleCatalogsUseCase _getVehicleCatalogsUseCase;

  AddVehicleCubit({
    required AddVehicleUseCase addVehicleUseCase,
    required GetMyContractsUseCase getMyContractsUseCase,
    required GetVehicleCatalogsUseCase getVehicleCatalogsUseCase,
  }) : _addVehicleUseCase = addVehicleUseCase,
       _getMyContractsUseCase = getMyContractsUseCase,
       _getVehicleCatalogsUseCase = getVehicleCatalogsUseCase,
       super(const AddVehicleState());

  Future<void> loadInitialData() async {
    emit(state.copyWith(status: AddVehicleStatus.loading));

    // Fetch approved contracts (fetch all and filter locally for safety)
    final contractsResult = await _getMyContractsUseCase(null);
    final catalogsResult = await _getVehicleCatalogsUseCase();

    if (isClosed) return;

    contractsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: AddVehicleStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) {
        final approvedContracts =
            data.items
                .where((c) => c.status.toLowerCase() == 'approved')
                .toList();

        catalogsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: AddVehicleStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (catalogs) => emit(
            state.copyWith(
              status: AddVehicleStatus.initial,
              approvedContracts: approvedContracts,
              vehicleCatalogs: catalogs,
            ),
          ),
        );
      },
    );
  }

  void updateStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  // Field Updates
  void updateSelectedContract(Contract? contract) {
    emit(state.copyWith(selectedContract: contract));
  }

  void updateSelectedCatalog(VehicleCatalog? catalog) {
    emit(state.copyWith(selectedCatalog: catalog));
  }

  void updateLicensePlate(String value) {
    emit(state.copyWith(licensePlate: value));
  }

  void updateRegistrationFront(XFile? file) {
    emit(state.copyWith(registrationFront: file));
  }

  void updateRegistrationBack(XFile? file) {
    emit(state.copyWith(registrationBack: file));
  }

  // Pricing Updates
  void updatePricePerHour(String value) =>
      emit(state.copyWith(pricePerHour: double.tryParse(value)));
  void updatePricePerDay(String value) =>
      emit(state.copyWith(pricePerDay: double.tryParse(value)));
  void updatePriceFor4Hours(String value) =>
      emit(state.copyWith(priceFor4Hours: double.tryParse(value)));
  void updatePriceFor8Hours(String value) =>
      emit(state.copyWith(priceFor8Hours: double.tryParse(value)));
  void updatePriceFor12Hours(String value) =>
      emit(state.copyWith(priceFor12Hours: double.tryParse(value)));
  void updatePriceFor2Days(String value) =>
      emit(state.copyWith(priceFor2Days: double.tryParse(value)));
  void updatePriceFor3Days(String value) =>
      emit(state.copyWith(priceFor3Days: double.tryParse(value)));
  void updatePriceFor5Days(String value) =>
      emit(state.copyWith(priceFor5Days: double.tryParse(value)));
  void updatePriceFor7Days(String value) =>
      emit(state.copyWith(priceFor7Days: double.tryParse(value)));

  void updateRequirements(String value) {
    emit(state.copyWith(requirements: value));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value));
  }

  Future<void> submitVehicle() async {
    if (state.selectedContract == null || state.selectedCatalog == null) return;

    emit(state.copyWith(status: AddVehicleStatus.loading));

    final request = AddVehicleRequest(
      licensePlate: state.licensePlate,
      contractId: state.selectedContract!.id,
      vehicleCatalogId: state.selectedCatalog!.id,
      pricePerHour: state.pricePerHour ?? 0,
      pricePerDay: state.pricePerDay ?? 0,
      priceFor4Hours: state.priceFor4Hours,
      priceFor8Hours: state.priceFor8Hours,
      priceFor12Hours: state.priceFor12Hours,
      priceFor2Days: state.priceFor2Days,
      priceFor3Days: state.priceFor3Days,
      priceFor5Days: state.priceFor5Days,
      priceFor7Days: state.priceFor7Days,
      requirements: state.requirements,
      description: state.description,
      vehicleRegistrationFront: state.registrationFront?.path,
      vehicleRegistrationBack: state.registrationBack?.path,
    );

    final result = await _addVehicleUseCase(request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddVehicleStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Fire event to notify vehicle list update
        eventBus.fire(VehicleAddedEvent());
        emit(state.copyWith(status: AddVehicleStatus.success));
      },
    );
  }
}
