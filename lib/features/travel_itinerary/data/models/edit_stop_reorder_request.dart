class EditStopReorderRequest {
  final int dayOrder;
  final int sequence;

  EditStopReorderRequest({required this.dayOrder, required this.sequence});

  Map<String, dynamic> toJson() {
    return {'dayOrder': dayOrder, 'sequence': sequence};
  }
}
