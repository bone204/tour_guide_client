class CheckContentResponse {
  final String? decision;
  final List<String>? reasons;

  CheckContentResponse({this.decision, this.reasons});

  factory CheckContentResponse.fromJson(Map<String, dynamic> json) {
    return CheckContentResponse(
      decision: json['decision'],
      reasons:
          (json['reasons'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'decision': decision, 'reasons': reasons};
  }
}
