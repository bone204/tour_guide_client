part of 'reform_locations_cubit.dart';

enum ReformLocationsStatus { initial, loading, success, failure }

class ReformLocationsState extends Equatable {
  final ReformLocationsStatus status;
  final List<ReformProvince> provinces;
  final List<ReformCommune> communes;
  final ReformProvince? selectedProvince;
  final ReformCommune? selectedCommune;
  final String? errorMessage;

  const ReformLocationsState({
    this.status = ReformLocationsStatus.initial,
    this.provinces = const [],
    this.communes = const [],
    this.selectedProvince,
    this.selectedCommune,
    this.errorMessage,
  });

  ReformLocationsState copyWith({
    ReformLocationsStatus? status,
    List<ReformProvince>? provinces,
    List<ReformCommune>? communes,
    ReformProvince? selectedProvince,
    ReformCommune? selectedCommune,
    String? errorMessage,
  }) {
    return ReformLocationsState(
      status: status ?? this.status,
      provinces: provinces ?? this.provinces,
      communes: communes ?? this.communes,
      selectedProvince: selectedProvince ?? this.selectedProvince,
      selectedCommune: selectedCommune ?? this.selectedCommune,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    provinces,
    communes,
    selectedProvince,
    selectedCommune,
    errorMessage,
  ];
}
