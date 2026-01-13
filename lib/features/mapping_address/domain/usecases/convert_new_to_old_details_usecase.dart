import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/mapping_address/domain/repository/mapping_address_repository.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_details_models.dart';

class ConvertNewToOldDetailsUseCase {
  Future<Either<Failure, List<ConvertNewToOldDetailsItem>>> call(
    ConvertNewToOldDetailsDto dto,
  ) async {
    return sl<MappingAddressRepository>().convertNewToOldDetails(dto);
  }
}
