import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_address_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_details_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/legacy_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/reform_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/admin_unit_mapping_model.dart';

abstract class MappingAddressApiService {
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

class MappingAddressApiServiceImpl extends MappingAddressApiService {
  @override
  Future<Either<Failure, ConvertOldToNewAddressResponse>>
  convertOldToNewAddress(ConvertAddressDto dto) async {
    try {
      final response = await sl<DioClient>().post(
        '${ApiUrls.mapping}/convert/old-to-new-address',
        data: dto.toJson(),
      );
      return Right(ConvertOldToNewAddressResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConvertNewToOldAddressResponse>>
  convertNewToOldAddress(ConvertAddressDto dto) async {
    try {
      final response = await sl<DioClient>().post(
        '${ApiUrls.mapping}/convert/new-to-old-address',
        data: dto.toJson(),
      );
      return Right(ConvertNewToOldAddressResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConvertOldToNewDetailsResponse>>
  convertOldToNewDetails(ConvertOldToNewDetailsDto dto) async {
    try {
      final response = await sl<DioClient>().post(
        '${ApiUrls.mapping}/convert/old-to-new-details',
        data: dto.toJson(),
      );
      return Right(ConvertOldToNewDetailsResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConvertNewToOldDetailsItem>>>
  convertNewToOldDetails(ConvertNewToOldDetailsDto dto) async {
    try {
      final response = await sl<DioClient>().post(
        '${ApiUrls.mapping}/convert/new-to-old-details',
        data: dto.toJson(),
      );
      final list =
          (response.data as List)
              .map((e) => ConvertNewToOldDetailsItem.fromJson(e))
              .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LegacyProvince>>> getLegacyProvinces(
    String? search,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.legacy}/provinces',
        queryParameters: search != null ? {'search': search} : null,
      );
      final list =
          (response.data as List)
              .map((e) => LegacyProvince.fromJson(e))
              .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LegacyDistrict>> getLegacyDistrict(String code) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.legacy}/districts/$code',
      );
      return Right(LegacyDistrict.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LegacyWard>>> getLegacyWardsOfDistrict(
    String districtCode,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.legacy}/districts/$districtCode/wards',
      );
      final list =
          (response.data as List).map((e) => LegacyWard.fromJson(e)).toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LegacyDistrict>>> getLegacyDistrictsOfProvince(
    String provinceCode,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.legacy}/provinces/$provinceCode/districts',
      );
      final list =
          (response.data as List)
              .map((e) => LegacyDistrict.fromJson(e))
              .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReformProvince>>> getReformProvinces(
    String? search,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.reform}/provinces',
        queryParameters: search != null ? {'search': search} : null,
      );
      final list =
          (response.data as List)
              .map((e) => ReformProvince.fromJson(e))
              .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReformProvince>> getReformProvince(String code) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.reform}/provinces/$code',
      );
      return Right(ReformProvince.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReformCommune>>> getReformCommunesOfProvince(
    String provinceCode,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.reform}/provinces/$provinceCode/communes',
      );
      final list =
          (response.data as List)
              .map((e) => ReformCommune.fromJson(e))
              .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminUnitMapping>>> findByLegacyWard(
    String code,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.mapping}/legacy-wards/$code',
      );
      final list =
          (response.data as List)
              .map((e) => AdminUnitMapping.fromJson(e))
              .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminUnitMapping>>> findByReformCommune(
    String code,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.mapping}/reform-communes/$code',
      );
      final list =
          (response.data as List)
              .map((e) => AdminUnitMapping.fromJson(e))
              .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
