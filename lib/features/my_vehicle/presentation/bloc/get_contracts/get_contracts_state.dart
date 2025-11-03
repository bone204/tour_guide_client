import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';

abstract class GetContractsState {}

class GetContractsInitial extends GetContractsState {}

class GetContractsLoading extends GetContractsState {}

class GetContractsSuccess extends GetContractsState {
  final List<Contract> contracts;

  GetContractsSuccess({required this.contracts});
}

class GetContractsEmpty extends GetContractsState {}

class GetContractsFailure extends GetContractsState {
  final String errorMessage;

  GetContractsFailure({required this.errorMessage});
}

