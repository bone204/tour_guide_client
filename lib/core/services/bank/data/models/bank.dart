class Bank {
  final int id;
  final String name;
  final String code;
  final String bin;
  final String shortName;
  final String logo;
  final int transferSupported;
  final int lookupSupported;
  final String shortNameAlt;
  final int support;
  final int isTransfer;
  final String? swiftCode;

  const Bank({
    required this.id,
    required this.name,
    required this.code,
    required this.bin,
    required this.shortName,
    required this.logo,
    required this.transferSupported,
    required this.lookupSupported,
    required this.shortNameAlt,
    required this.support,
    required this.isTransfer,
    this.swiftCode,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      bin: json['bin'] ?? '',
      shortName: json['shortName'] ?? '',
      logo: json['logo'] ?? '',
      transferSupported: json['transferSupported'] ?? 0,
      lookupSupported: json['lookupSupported'] ?? 0,
      shortNameAlt: json['short_name'] ?? '',
      support: json['support'] ?? 0,
      isTransfer: json['isTransfer'] ?? 0,
      swiftCode: json['swift_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'bin': bin,
      'shortName': shortName,
      'logo': logo,
      'transferSupported': transferSupported,
      'lookupSupported': lookupSupported,
      'short_name': shortNameAlt,
      'support': support,
      'isTransfer': isTransfer,
      'swift_code': swiftCode,
    };
  }
}

class BankResponse {
  final String code;
  final String desc;
  final List<Bank> data;

  BankResponse({required this.code, required this.desc, required this.data});

  factory BankResponse.fromJson(Map<String, dynamic> json) {
    return BankResponse(
      code: json['code'] ?? '',
      desc: json['desc'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Bank.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'desc': desc,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
