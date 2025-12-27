import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/data_source/rental_bill_api_service.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class RentalBillRepositoryImpl implements RentalBillRepository {
  final RentalBillApiService _apiService = sl<RentalBillApiService>();

  @override
  Future<Either<Failure, List<RentalBill>>> getMyBills({
    RentalBillStatus? status,
  }) async {
    return await _apiService.getMyBills(status: status);
  }

  @override
  Future<Either<Failure, RentalBill>> getBillDetail(int id) async {
    return await _apiService.getBillDetail(id);
  }
}
