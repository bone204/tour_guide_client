enum DestinationSortBy { rating, popularity }

class DestinationQuery {
  final String? q;
  final bool? available;
  final String? province;
  final int offset;
  final int limit;
  final DestinationSortBy? sortBy;
  final bool? hasTourTickets;

  DestinationQuery({
    this.q,
    this.available,
    this.province,
    this.offset = 0,
    this.limit = 10,
    this.sortBy,
    this.hasTourTickets,
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
    if (sortBy != null) {
      params['sortBy'] = sortBy!.name;
    }
    if (hasTourTickets != null) {
      params['hasTourTickets'] = hasTourTickets;
    }

    return params;
  }

  DestinationQuery copyWith({
    String? q,
    bool? available,
    String? province,
    int? offset,
    int? limit,
    DestinationSortBy? sortBy,
    bool? hasTourTickets,
  }) {
    return DestinationQuery(
      q: q ?? this.q,
      available: available ?? this.available,
      province: province ?? this.province,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      hasTourTickets: hasTourTickets ?? this.hasTourTickets,
    );
  }
}
