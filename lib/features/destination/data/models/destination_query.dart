class DestinationQuery {
  final String? q;
  final bool? available;
  final String? province;
  final int offset;
  final int limit;

  DestinationQuery({
    this.q,
    this.available,
    this.province,
    this.offset = 0,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> params = {'offset': offset, 'limit': limit};

    if (q != null && q!.isNotEmpty) {
      params['q'] = q;
    }
    if (available != null) {
      params['available'] = available;
    }
    if (province != null && province!.isNotEmpty) {
      params['province'] = province;
    }

    return params;
  }

  DestinationQuery copyWith({
    String? q,
    bool? available,
    String? province,
    int? offset,
    int? limit,
  }) {
    return DestinationQuery(
      q: q ?? this.q,
      available: available ?? this.available,
      province: province ?? this.province,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
    );
  }
}
