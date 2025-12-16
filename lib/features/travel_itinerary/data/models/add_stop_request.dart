class AddStopRequest {
  final int dayOrder;
  final int travelPoints;
  final String startTime;
  final String endTime;
  final String notes;
  final int destinationId;
  final int sequence;
  final String status;

  AddStopRequest({
    required this.dayOrder,
    required this.travelPoints,
    required this.startTime,
    required this.endTime,
    required this.notes,
    required this.destinationId,
    this.sequence = 1,
    this.status = 'upcoming',
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOrder': dayOrder,
      'travelPoints': travelPoints,
      'startTime': startTime,
      'endTime': endTime,
      'notes': notes,
      'destinationId': destinationId,
      'sequence': sequence,
      'status': status,
    };
  }
}
