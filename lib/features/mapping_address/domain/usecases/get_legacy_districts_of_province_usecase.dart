import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/mapping_address/domain/repository/mapping_address_repository.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/legacy_location_models.dart';

class GetLegacyDistrictsOfProvinceUseCase {
  Future<Either<Failure, List<LegacyDistrict>>> call(
    String provinceCode,
  ) async {
    return sl<MappingAddressRepository>().getLegacyDistrictsOfProvince(
      provinceCode,
    );
  }
}
