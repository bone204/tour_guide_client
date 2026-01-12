class Country {
  final Map<String, dynamic> name;
  final String cca2;
  final Map<String, dynamic> flags;
  final Map<String, dynamic>? translations;

  Country({
    required this.name,
    required this.cca2,
    required this.flags,
    this.translations,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] as Map<String, dynamic>,
      cca2: json['cca2'] as String,
      flags: json['flags'] as Map<String, dynamic>,
      translations: json['translations'] as Map<String, dynamic>?,
    );
  }

  String get commonName => name['common'] as String;
  String get flagUrl => flags['png'] as String;

  String getvietnameseName() {
    if (translations != null && translations!.containsKey('vie')) {
      return translations!['vie']['common'] as String;
    }
    return commonName;
  }
}
