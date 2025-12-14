class ProvinceQuery {
  final String? q;
  final String? region;
  final bool? active;

  ProvinceQuery({this.q, this.region, this.active});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> params = {};
    if (q != null && q!.isNotEmpty) params['q'] = q;
    if (region != null && region!.isNotEmpty) params['region'] = region;
    if (active != null) params['active'] = active;
    return params;
  }

  ProvinceQuery copyWith({String? q, String? region, bool? active}) {
    return ProvinceQuery(
      q: q ?? this.q,
      region: region ?? this.region,
      active: active ?? this.active,
    );
  }
}
