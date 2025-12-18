class EditStopTimeRequest {
  final String startTime;
  final String endTime;

  EditStopTimeRequest({required this.startTime, required this.endTime});

  Map<String, dynamic> toJson() {
    return {'startTime': startTime, 'endTime': endTime};
  }
}
