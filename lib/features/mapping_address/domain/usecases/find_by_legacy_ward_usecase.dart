import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/mapping_address/domain/repository/mapping_address_repository.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/admin_unit_mapping_model.dart';

class FindByLegacyWardUseCase {
  Future<Either<Failure, List<AdminUnitMapping>>> call(String code) async {
    return sl<MappingAddressRepository>().findByLegacyWard(code);
  }
}
