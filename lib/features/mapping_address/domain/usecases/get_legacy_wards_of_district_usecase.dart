import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/mapping_address/domain/repository/mapping_address_repository.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/legacy_location_models.dart';

class GetLegacyWardsOfDistrictUseCase {
  Future<Either<Failure, List<LegacyWard>>> call(String districtCode) async {
    return sl<MappingAddressRepository>().getLegacyWardsOfDistrict(
      districtCode,
    );
  }
}
