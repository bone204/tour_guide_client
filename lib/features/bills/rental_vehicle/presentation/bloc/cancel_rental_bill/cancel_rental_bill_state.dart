import 'package:tour_guide_app/core/success/success_response.dart';

abstract class CancelRentalBillState {}

class CancelRentalBillInitial extends CancelRentalBillState {}

class CancelRentalBillLoading extends CancelRentalBillState {}

class CancelRentalBillSuccess extends CancelRentalBillState {
  final SuccessResponse response;
  CancelRentalBillSuccess(this.response);
}

class CancelRentalBillFailure extends CancelRentalBillState {
  final String message;
  CancelRentalBillFailure(this.message);
}
