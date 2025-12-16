  class CreateItineraryRequest {
  final String name;
  final String? province;
  final int? numberOfDays;
  final String? startDate;
  final String? endDate;
  final List<RouteStopRequest>? stops;

  const CreateItineraryRequest({
    required this.name,
    this.province,
    this.numberOfDays,
    this.startDate,
    this.endDate,
    this.stops,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (province != null) 'province': province,
      if (numberOfDays != null) 'numberOfDays': numberOfDays,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (stops != null) 'stops': stops!.map((e) => e.toJson()).toList(),
    };
  }
}

class RouteStopRequest {
  final int dayOrder;
  final int sequence;
  final int? destinationId;
  final int? travelPoints;
  final String? startTime;
  final String? endTime;
  final String? notes;

  const RouteStopRequest({
    required this.dayOrder,
    required this.sequence,
    this.destinationId,
    this.travelPoints,
    this.startTime,
    this.endTime,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOrder': dayOrder,
      'sequence': sequence,
      if (destinationId != null) 'destinationId': destinationId,
      if (travelPoints != null) 'travelPoints': travelPoints,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      if (notes != null) 'notes': notes,
    };
  }
}
