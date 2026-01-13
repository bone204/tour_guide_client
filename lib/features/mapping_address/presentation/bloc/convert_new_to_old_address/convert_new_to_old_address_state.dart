part of 'convert_new_to_old_address_cubit.dart';

enum ConvertNewToOldAddressStatus { initial, loading, success, failure }

class ConvertNewToOldAddressState extends Equatable {
  final ConvertNewToOldAddressStatus status;
  final ConvertNewToOldAddressResponse? result;
  final String? errorMessage;

  const ConvertNewToOldAddressState({
    this.status = ConvertNewToOldAddressStatus.initial,
    this.result,
    this.errorMessage,
  });

  ConvertNewToOldAddressState copyWith({
    ConvertNewToOldAddressStatus? status,
    ConvertNewToOldAddressResponse? result,
    String? errorMessage,
  }) {
    return ConvertNewToOldAddressState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
