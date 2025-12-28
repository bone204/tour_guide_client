part of 'create_itinerary_cubit.dart';

enum CreateItineraryStatus { initial, loading, success, failure }

class CreateItineraryState extends Equatable {
  final CreateItineraryStatus status;
  final String name;
  final String province;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? errorMessage;
  final Itinerary? createdItinerary;

  const CreateItineraryState({
    this.status = CreateItineraryStatus.initial,
    this.name = '',
    this.province = '',
    this.startDate,
    this.endDate,
    this.errorMessage,
    this.createdItinerary,
  });

  CreateItineraryState copyWith({
    CreateItineraryStatus? status,
    String? name,
    String? province,
    DateTime? startDate,
    DateTime? endDate,
    String? errorMessage,
    Itinerary? createdItinerary,
  }) {
    return CreateItineraryState(
      status: status ?? this.status,
      name: name ?? this.name,
      province: province ?? this.province,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      errorMessage: errorMessage ?? this.errorMessage,
      createdItinerary: createdItinerary ?? this.createdItinerary,
    );
  }

  int get numberOfDays {
    if (startDate == null || endDate == null) return 1;
    // Normalize dates to midnight to ensure correct day difference calculation
    final start = DateTime(startDate!.year, startDate!.month, startDate!.day);
    final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
    final diff = end.difference(start).inDays;
    return diff >= 0 ? diff + 1 : 1;
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
    errorMessage,
    createdItinerary,
  ];
}
