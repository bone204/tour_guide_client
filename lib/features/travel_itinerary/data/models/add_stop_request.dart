class AddStopRequest {
  final int dayOrder;
  final int travelPoints;
  final String startTime;
  final String endTime;
  final String notes;

  AddStopRequest({
    required this.dayOrder,
    required this.travelPoints,
    required this.startTime,
    required this.endTime,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOrder': dayOrder,
      'travelPoints': travelPoints,
      'startTime': startTime,
      'endTime': endTime,
      'notes': notes,
    };
  }
}
