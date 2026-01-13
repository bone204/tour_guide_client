part of 'convert_old_to_new_address_cubit.dart';

enum ConvertOldToNewAddressStatus { initial, loading, success, failure }

class ConvertOldToNewAddressState extends Equatable {
  final ConvertOldToNewAddressStatus status;
  final ConvertOldToNewAddressResponse? result;
  final String? errorMessage;

  const ConvertOldToNewAddressState({
    this.status = ConvertOldToNewAddressStatus.initial,
    this.result,
    this.errorMessage,
  });

  ConvertOldToNewAddressState copyWith({
    ConvertOldToNewAddressStatus? status,
    ConvertOldToNewAddressResponse? result,
    String? errorMessage,
  }) {
    return ConvertOldToNewAddressState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
