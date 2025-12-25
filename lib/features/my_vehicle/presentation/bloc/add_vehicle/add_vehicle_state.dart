import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_catalog.dart';
import 'package:image_picker/image_picker.dart';

enum AddVehicleStatus { initial, loading, success, failure }

class AddVehicleState extends Equatable {
  final AddVehicleStatus status;
  final int currentStep;
  final String? errorMessage;

  // Data lists
  final List<Contract> approvedContracts;
  final List<VehicleCatalog> vehicleCatalogs;

  // Form Data
  final String licensePlate;
  final Contract? selectedContract;
  final VehicleCatalog? selectedCatalog;
  final double? pricePerHour;
  final double? pricePerDay;
  final double? priceFor4Hours;
  final double? priceFor8Hours;
  final double? priceFor12Hours;
  final double? priceFor2Days;
  final double? priceFor3Days;
  final double? priceFor5Days;
  final double? priceFor7Days;
  final String requirements;
  final String description;

  // Images
  final XFile? registrationFront;
  final XFile? registrationBack;

  const AddVehicleState({
    this.status = AddVehicleStatus.initial,
    this.currentStep = 0,
    this.errorMessage,
    this.approvedContracts = const [],
    this.vehicleCatalogs = const [],
    this.licensePlate = '',
    this.selectedContract,
    this.selectedCatalog,
    this.pricePerHour,
    this.pricePerDay,
    this.priceFor4Hours,
    this.priceFor8Hours,
    this.priceFor12Hours,
    this.priceFor2Days,
    this.priceFor3Days,
    this.priceFor5Days,
    this.priceFor7Days,
    this.requirements = '',
    this.description = '',
    this.registrationFront,
    this.registrationBack,
  });

  AddVehicleState copyWith({
    AddVehicleStatus? status,
    int? currentStep,
    String? errorMessage,
    List<Contract>? approvedContracts,
    List<VehicleCatalog>? vehicleCatalogs,
    String? licensePlate,
    Contract? selectedContract,
    VehicleCatalog? selectedCatalog,
    double? pricePerHour,
    double? pricePerDay,
    double? priceFor4Hours,
    double? priceFor8Hours,
    double? priceFor12Hours,
    double? priceFor2Days,
    double? priceFor3Days,
    double? priceFor5Days,
    double? priceFor7Days,
    String? requirements,
    String? description,
    XFile? registrationFront,
    XFile? registrationBack,
  }) {
    return AddVehicleState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      errorMessage: errorMessage ?? this.errorMessage,
      approvedContracts: approvedContracts ?? this.approvedContracts,
      vehicleCatalogs: vehicleCatalogs ?? this.vehicleCatalogs,
      licensePlate: licensePlate ?? this.licensePlate,
      selectedContract: selectedContract ?? this.selectedContract,
      selectedCatalog: selectedCatalog ?? this.selectedCatalog,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      priceFor4Hours: priceFor4Hours ?? this.priceFor4Hours,
      priceFor8Hours: priceFor8Hours ?? this.priceFor8Hours,
      priceFor12Hours: priceFor12Hours ?? this.priceFor12Hours,
      priceFor2Days: priceFor2Days ?? this.priceFor2Days,
      priceFor3Days: priceFor3Days ?? this.priceFor3Days,
      priceFor5Days: priceFor5Days ?? this.priceFor5Days,
      priceFor7Days: priceFor7Days ?? this.priceFor7Days,
      requirements: requirements ?? this.requirements,
      description: description ?? this.description,
      registrationFront: registrationFront ?? this.registrationFront,
      registrationBack: registrationBack ?? this.registrationBack,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentStep,
    errorMessage,
    approvedContracts,
    vehicleCatalogs,
    licensePlate,
    selectedContract,
    selectedCatalog,
    pricePerHour,
    pricePerDay,
    priceFor4Hours,
    priceFor8Hours,
    priceFor12Hours,
    priceFor2Days,
    priceFor3Days,
    priceFor5Days,
    priceFor7Days,
    requirements,
    description,
    registrationFront,
    registrationBack,
  ];
}
