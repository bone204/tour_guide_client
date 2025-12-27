import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class UpdateRentalBillUseCase
    implements UseCase<Either<Failure, RentalBill>, UpdateRentalBillParams> {
  @override
  Future<Either<Failure, RentalBill>> call(UpdateRentalBillParams params) {
    return sl<RentalBillRepository>().updateBill(params);
  }
}

class UpdateRentalBillParams {
  final int id;
  final String? contactName;
  final String? contactPhone;
  final String? notes;
  final String? paymentMethod;
  final String? voucherCode;
  final int? travelPointsUsed;

  UpdateRentalBillParams({
    required this.id,
    this.contactName,
    this.contactPhone,
    this.notes,
    this.paymentMethod,
    this.voucherCode,
    this.travelPointsUsed,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (contactName != null) data['contactName'] = contactName;
    if (contactPhone != null) data['contactPhone'] = contactPhone;
    if (notes != null) data['notes'] = notes;
    if (paymentMethod != null) data['paymentMethod'] = paymentMethod;
    if (voucherCode != null) data['voucherCode'] = voucherCode;
    if (travelPointsUsed != null) data['travelPointsUsed'] = travelPointsUsed;
    return data;
  }
}
