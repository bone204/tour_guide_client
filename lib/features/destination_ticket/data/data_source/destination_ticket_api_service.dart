import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/create_destination_bill_request.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/destination_bill_model.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class DestinationTicketApiService {
  Future<Either<Failure, DestinationResponse>> getTicketableDestinations(
    DestinationQuery query,
  );
  Future<Either<Failure, DestinationBillModel>> createBill(
    CreateDestinationBillRequest request,
  );
  Future<Either<Failure, List<DestinationBillModel>>> getMyBills();
}

class DestinationTicketApiServiceImpl extends DestinationTicketApiService {
  @override
  Future<Either<Failure, DestinationResponse>> getTicketableDestinations(
    DestinationQuery query,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.getDestinations,
        queryParameters: query.copyWith(hasTourTickets: true).toJson(),
      );
      return Right(DestinationResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch tickets',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DestinationBillModel>> createBill(
    CreateDestinationBillRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.destinationBills,
        data: request.toJson(),
      );
      return Right(DestinationBillModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to create bill',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DestinationBillModel>>> getMyBills() async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.destinationBills}/me",
      );
      final List data = response.data;
      return Right(data.map((e) => DestinationBillModel.fromJson(e)).toList());
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch bills',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
