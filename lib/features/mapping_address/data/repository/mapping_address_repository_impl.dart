import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/mapping_address/data/data_source/mapping_address_api_service.dart';
import 'package:tour_guide_app/features/mapping_address/domain/repository/mapping_address_repository.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_address_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_details_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/legacy_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/reform_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/admin_unit_mapping_model.dart';
import 'package:tour_guide_app/service_locator.dart';

class MappingAddressRepositoryImpl implements MappingAddressRepository {
  final _apiService = sl<MappingAddressApiService>();

  @override
  Future<Either<Failure, ConvertOldToNewAddressResponse>>
  convertOldToNewAddress(ConvertAddressDto dto) {
    return _apiService.convertOldToNewAddress(dto);
  }

  @override
  Future<Either<Failure, ConvertNewToOldAddressResponse>>
  convertNewToOldAddress(ConvertAddressDto dto) {
    return _apiService.convertNewToOldAddress(dto);
  }

  @override
  Future<Either<Failure, ConvertOldToNewDetailsResponse>>
  convertOldToNewDetails(ConvertOldToNewDetailsDto dto) {
    return _apiService.convertOldToNewDetails(dto);
  }

  @override
  Future<Either<Failure, List<ConvertNewToOldDetailsItem>>>
  convertNewToOldDetails(ConvertNewToOldDetailsDto dto) {
    return _apiService.convertNewToOldDetails(dto);
  }

  @override
  Future<Either<Failure, List<LegacyProvince>>> getLegacyProvinces(
    String? search,
  ) {
    return _apiService.getLegacyProvinces(search);
  }

  @override
  Future<Either<Failure, LegacyDistrict>> getLegacyDistrict(String code) {
    return _apiService.getLegacyDistrict(code);
  }

  @override
  Future<Either<Failure, List<LegacyDistrict>>> getLegacyDistrictsOfProvince(
    String provinceCode,
  ) {
    return _apiService.getLegacyDistrictsOfProvince(provinceCode);
  }

  @override
  Future<Either<Failure, List<LegacyWard>>> getLegacyWardsOfDistrict(
    String districtCode,
  ) {
    return _apiService.getLegacyWardsOfDistrict(districtCode);
  }

  @override
  Future<Either<Failure, List<ReformProvince>>> getReformProvinces(
    String? search,
  ) {
    return _apiService.getReformProvinces(search);
  }

  @override
  Future<Either<Failure, ReformProvince>> getReformProvince(String code) {
    return _apiService.getReformProvince(code);
  }

  @override
  Future<Either<Failure, List<ReformCommune>>> getReformCommunesOfProvince(
    String provinceCode,
  ) {
    return _apiService.getReformCommunesOfProvince(provinceCode);
  }

  @override
  Future<Either<Failure, List<AdminUnitMapping>>> findByLegacyWard(
    String code,
  ) {
    return _apiService.findByLegacyWard(code);
  }

  @override
  Future<Either<Failure, List<AdminUnitMapping>>> findByReformCommune(
    String code,
  ) {
    return _apiService.findByReformCommune(code);
  }
}
