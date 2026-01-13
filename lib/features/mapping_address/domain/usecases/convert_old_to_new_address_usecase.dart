import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/mapping_address/domain/repository/mapping_address_repository.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_address_models.dart';

class ConvertOldToNewAddressUseCase {
  Future<Either<Failure, ConvertOldToNewAddressResponse>> call(
    ConvertAddressDto dto,
  ) async {
    return sl<MappingAddressRepository>().convertOldToNewAddress(dto);
  }
}
