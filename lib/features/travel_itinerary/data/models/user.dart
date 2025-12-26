class User {
  final int id;
  final String username;
  final String? name;
  final String? email;
  final String? phone;
  final String password;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String dateOfBirth;
  final String fullName;
  final String gender;
  final String address;
  final String nationality;
  final String citizenId;
  final String idCardImageUrl;
  final String bankName;
  final String bankAccountNumber;
  final String bankAccountName;
  final List<String> hobbies;
  final List<int> favoriteDestinationIds;
  final List<int> favoriteEateries;
  final List<int> cooperationIds;
  final String avatarUrl;
  final int travelPoint;
  final int travelExp;
  final int travelTrip;
  final int feedbackTimes;
  final int dayParticipation;
  final String userTier;
  final String role;
  final String createdAt;
  final String updatedAt;

  const User({
    required this.id,
    required this.username,
    this.name,
    this.email,
    this.phone,
    required this.password,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.dateOfBirth,
    required this.fullName,
    required this.gender,
    required this.address,
    required this.nationality,
    required this.citizenId,
    required this.idCardImageUrl,
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.hobbies,
    required this.favoriteDestinationIds,
    required this.favoriteEateries,
    required this.cooperationIds,
    required this.avatarUrl,
    required this.travelPoint,
    required this.travelExp,
    required this.travelTrip,
    required this.feedbackTimes,
    required this.dayParticipation,
    required this.userTier,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      dateOfBirth: json['dateOfBirth'] ?? '',
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      nationality: json['nationality'] ?? '',
      citizenId: json['citizenId'] ?? '',
      idCardImageUrl: json['idCardImageUrl'] ?? '',
      bankName: json['bankName'] ?? '',
      bankAccountNumber: json['bankAccountNumber'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      hobbies:
          (json['hobbies'] as List?)?.map((e) => e.toString()).toList() ?? [],
      favoriteDestinationIds:
          (json['favoriteDestinationIds'] as List?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      favoriteEateries:
          (json['favoriteEateries'] as List?)?.map((e) => e as int).toList() ??
          [],
      cooperationIds:
          (json['cooperationIds'] as List?)?.map((e) => e as int).toList() ??
          [],
      avatarUrl: json['avatarUrl'] ?? '',
      travelPoint: json['travelPoint'] ?? 0,
      travelExp: json['travelExp'] ?? 0,
      travelTrip: json['travelTrip'] ?? 0,
      feedbackTimes: json['feedbackTimes'] ?? 0,
      dayParticipation: json['dayParticipation'] ?? 0,
      userTier: json['userTier'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'dateOfBirth': dateOfBirth,
      'fullName': fullName,
      'gender': gender,
      'address': address,
      'nationality': nationality,
      'citizenId': citizenId,
      'idCardImageUrl': idCardImageUrl,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
      'hobbies': hobbies,
      'favoriteDestinationIds': favoriteDestinationIds,
      'favoriteEateries': favoriteEateries,
      'cooperationIds': cooperationIds,
      'avatarUrl': avatarUrl,
      'travelPoint': travelPoint,
      'travelExp': travelExp,
      'travelTrip': travelTrip,
      'feedbackTimes': feedbackTimes,
      'dayParticipation': dayParticipation,
      'userTier': userTier,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? name,
    String? email,
    String? phone,
    String? password,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? dateOfBirth,
    String? fullName,
    String? gender,
    String? address,
    String? nationality,
    String? citizenId,
    String? idCardImageUrl,
    String? bankName,
    String? bankAccountNumber,
    String? bankAccountName,
    List<String>? hobbies,
    List<int>? favoriteDestinationIds,
    List<int>? favoriteEateries,
    List<int>? cooperationIds,
    String? avatarUrl,
    int? travelPoint,
    int? travelExp,
    int? travelTrip,
    int? feedbackTimes,
    int? dayParticipation,
    String? userTier,
    String? role,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      nationality: nationality ?? this.nationality,
      citizenId: citizenId ?? this.citizenId,
      idCardImageUrl: idCardImageUrl ?? this.idCardImageUrl,
      bankName: bankName ?? this.bankName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      hobbies: hobbies ?? this.hobbies,
      favoriteDestinationIds:
          favoriteDestinationIds ?? this.favoriteDestinationIds,
      favoriteEateries: favoriteEateries ?? this.favoriteEateries,
      cooperationIds: cooperationIds ?? this.cooperationIds,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      travelPoint: travelPoint ?? this.travelPoint,
      travelExp: travelExp ?? this.travelExp,
      travelTrip: travelTrip ?? this.travelTrip,
      feedbackTimes: feedbackTimes ?? this.feedbackTimes,
      dayParticipation: dayParticipation ?? this.dayParticipation,
      userTier: userTier ?? this.userTier,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
