part of 'legacy_locations_cubit.dart';

enum LegacyLocationsStatus { initial, loading, success, failure }

class LegacyLocationsState extends Equatable {
  final LegacyLocationsStatus status;
  final List<LegacyProvince> provinces;
  final List<LegacyDistrict> districts;
  final List<LegacyWard> wards;
  final LegacyProvince? selectedProvince;
  final LegacyDistrict? selectedDistrict;
  final LegacyWard? selectedWard;
  final String? errorMessage;

  const LegacyLocationsState({
    this.status = LegacyLocationsStatus.initial,
    this.provinces = const [],
    this.districts = const [],
    this.wards = const [],
    this.selectedProvince,
    this.selectedDistrict,
    this.selectedWard,
    this.errorMessage,
  });

  LegacyLocationsState copyWith({
    LegacyLocationsStatus? status,
    List<LegacyProvince>? provinces,
    List<LegacyDistrict>? districts,
    List<LegacyWard>? wards,
    LegacyProvince? selectedProvince,
    LegacyDistrict? selectedDistrict,
    LegacyWard? selectedWard,
    String? errorMessage,
  }) {
    return LegacyLocationsState(
      status: status ?? this.status,
      provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
      wards: wards ?? this.wards,
      selectedProvince: selectedProvince ?? this.selectedProvince,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      selectedWard: selectedWard ?? this.selectedWard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    provinces,
    districts,
    wards,
    selectedProvince,
    selectedDistrict,
    selectedWard,
    errorMessage,
  ];
}
