import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/mapping_address/domain/repository/mapping_address_repository.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_details_models.dart';

class ConvertOldToNewDetailsUseCase {
  Future<Either<Failure, ConvertOldToNewDetailsResponse>> call(
    ConvertOldToNewDetailsDto dto,
  ) async {
    return sl<MappingAddressRepository>().convertOldToNewDetails(dto);
  }
}
