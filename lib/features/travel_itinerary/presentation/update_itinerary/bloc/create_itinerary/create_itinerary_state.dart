part of 'create_itinerary_cubit.dart';

enum CreateItineraryStatus { initial, loading, success, failure }

class CreateItineraryState extends Equatable {
  final CreateItineraryStatus status;
  final String name;
  final String province;
  final DateTime? startDate;
  final DateTime? endDate;
  final int numberOfDays;
  final String? errorMessage;
  final Itinerary? createdItinerary;

  const CreateItineraryState({
    this.status = CreateItineraryStatus.initial,
    this.name = '',
    this.province = '',
    this.startDate,
    this.endDate,
    this.numberOfDays = 1,
    this.errorMessage,
    this.createdItinerary,
  });

  CreateItineraryState copyWith({
    CreateItineraryStatus? status,
    String? name,
    String? province,
    DateTime? startDate,
    DateTime? endDate,
    int? numberOfDays,
    String? errorMessage,
    Itinerary? createdItinerary,
  }) {
    return CreateItineraryState(
      status: status ?? this.status,
      name: name ?? this.name,
      province: province ?? this.province,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      errorMessage: errorMessage ?? this.errorMessage,
      createdItinerary: createdItinerary ?? this.createdItinerary,
    );
  }

  bool get isValid =>
      name.isNotEmpty &&
      startDate != null &&
      endDate != null &&
      province.isNotEmpty;

  @override
  List<Object?> get props => [
    status,
    name,
    province,
    startDate,
    endDate,
    numberOfDays,
    errorMessage,
    createdItinerary,
  ];
}
