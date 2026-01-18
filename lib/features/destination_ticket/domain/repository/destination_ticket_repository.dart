import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/create_destination_bill_request.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/destination_bill_model.dart';

abstract class DestinationTicketRepository {
  Future<Either<Failure, DestinationResponse>> getTicketableDestinations(
    DestinationQuery query,
  );
  Future<Either<Failure, DestinationBillModel>> createBill(
    CreateDestinationBillRequest request,
  );
  Future<Either<Failure, List<DestinationBillModel>>> getMyBills();
}
