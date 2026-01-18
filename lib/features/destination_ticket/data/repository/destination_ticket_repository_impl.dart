import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination_ticket/data/data_source/destination_ticket_api_service.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/create_destination_bill_request.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/destination_bill_model.dart';
import 'package:tour_guide_app/features/destination_ticket/domain/repository/destination_ticket_repository.dart';

class DestinationTicketRepositoryImpl extends DestinationTicketRepository {
  final DestinationTicketApiService apiService;

  DestinationTicketRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, DestinationResponse>> getTicketableDestinations(
    DestinationQuery query,
  ) {
    return apiService.getTicketableDestinations(query);
  }

  @override
  Future<Either<Failure, DestinationBillModel>> createBill(
    CreateDestinationBillRequest request,
  ) {
    return apiService.createBill(request);
  }

  @override
  Future<Either<Failure, List<DestinationBillModel>>> getMyBills() {
    return apiService.getMyBills();
  }
}
