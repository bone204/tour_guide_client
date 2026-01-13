import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_address_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_details_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/legacy_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/reform_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/admin_unit_mapping_model.dart';

abstract class MappingAddressRepository {
  Future<Either<Failure, ConvertOldToNewAddressResponse>>
  convertOldToNewAddress(ConvertAddressDto dto);
  Future<Either<Failure, ConvertNewToOldAddressResponse>>
  convertNewToOldAddress(ConvertAddressDto dto);
  Future<Either<Failure, ConvertOldToNewDetailsResponse>>
  convertOldToNewDetails(ConvertOldToNewDetailsDto dto);
  Future<Either<Failure, List<ConvertNewToOldDetailsItem>>>
  convertNewToOldDetails(ConvertNewToOldDetailsDto dto);

  Future<Either<Failure, List<LegacyProvince>>> getLegacyProvinces(
    String? search,
  );
  Future<Either<Failure, LegacyDistrict>> getLegacyDistrict(String code);
  Future<Either<Failure, List<LegacyDistrict>>> getLegacyDistrictsOfProvince(
    String provinceCode,
  );
  Future<Either<Failure, List<LegacyWard>>> getLegacyWardsOfDistrict(
    String districtCode,
  );

  Future<Either<Failure, List<ReformProvince>>> getReformProvinces(
    String? search,
  );
  Future<Either<Failure, ReformProvince>> getReformProvince(String code);
  Future<Either<Failure, List<ReformCommune>>> getReformCommunesOfProvince(
    String provinceCode,
  );

  Future<Either<Failure, List<AdminUnitMapping>>> findByLegacyWard(String code);
  Future<Either<Failure, List<AdminUnitMapping>>> findByReformCommune(
    String code,
  );
}
