part of 'convert_old_to_new_details_cubit.dart';

enum ConvertOldToNewDetailsStatus { initial, loading, success, failure }

class ConvertOldToNewDetailsState extends Equatable {
  final ConvertOldToNewDetailsStatus status;
  final ConvertOldToNewDetailsResponse? result;
  final String? errorMessage;

  const ConvertOldToNewDetailsState({
    this.status = ConvertOldToNewDetailsStatus.initial,
    this.result,
    this.errorMessage,
  });

  ConvertOldToNewDetailsState copyWith({
    ConvertOldToNewDetailsStatus? status,
    ConvertOldToNewDetailsResponse? result,
    String? errorMessage,
  }) {
    return ConvertOldToNewDetailsState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
