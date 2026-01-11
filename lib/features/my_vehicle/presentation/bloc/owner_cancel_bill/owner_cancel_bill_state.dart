import 'package:tour_guide_app/core/success/success_response.dart';

abstract class OwnerCancelBillState {}

class OwnerCancelBillInitial extends OwnerCancelBillState {}

class OwnerCancelBillLoading extends OwnerCancelBillState {}

class OwnerCancelBillSuccess extends OwnerCancelBillState {
  final SuccessResponse response;
  OwnerCancelBillSuccess(this.response);
}

class OwnerCancelBillFailure extends OwnerCancelBillState {
  final String message;
  OwnerCancelBillFailure(this.message);
}
