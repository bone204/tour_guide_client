class EditStopDetailsRequest {
  final String notes;

  EditStopDetailsRequest({required this.notes});

  Map<String, dynamic> toJson() {
    return {'notes': notes};
  }
}
