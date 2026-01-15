class UpdateTravelRouteRequest {
  final String? name;
  final String? startDate;
  final String? endDate;
  final String? province;

  UpdateTravelRouteRequest({
    this.name,
    this.startDate,
    this.endDate,
    this.province,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (startDate != null) data['startDate'] = startDate;
    if (endDate != null) data['endDate'] = endDate;
    if (province != null) data['province'] = province;
    return data;
  }

  factory UpdateTravelRouteRequest.fromJson(Map<String, dynamic> json) {
    return UpdateTravelRouteRequest(
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      province: json['province'],
    );
  }
}
