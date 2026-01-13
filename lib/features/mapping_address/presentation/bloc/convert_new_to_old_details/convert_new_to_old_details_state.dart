part of 'convert_new_to_old_details_cubit.dart';

enum ConvertNewToOldDetailsStatus { initial, loading, success, failure }

class ConvertNewToOldDetailsState extends Equatable {
  final ConvertNewToOldDetailsStatus status;
  final List<ConvertNewToOldDetailsItem>? result;
  final String? errorMessage;

  const ConvertNewToOldDetailsState({
    this.status = ConvertNewToOldDetailsStatus.initial,
    this.result,
    this.errorMessage,
  });

  ConvertNewToOldDetailsState copyWith({
    ConvertNewToOldDetailsStatus? status,
    List<ConvertNewToOldDetailsItem>? result,
    String? errorMessage,
  }) {
    return ConvertNewToOldDetailsState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
