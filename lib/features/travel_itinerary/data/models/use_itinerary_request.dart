class UseItineraryRequest {
  final String name;
  final String startDate;
  final String endDate;

  UseItineraryRequest({required this.name, required this.startDate, required this.endDate});

  Map<String, dynamic> toJson() {
    return {'name': name, 'startDate': startDate, 'endDate': endDate};
  }
}
