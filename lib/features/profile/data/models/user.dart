class User {
  final int id;
  final String username;

  final String? email;
  final String? phone;
  final String? fcmToken;

  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isCitizenIdVerified;

  final String? dateOfBirth;
  final String? fullName;
  final String? gender;
  final String? address;
  final String? nationality;
  final String? citizenId;

  final String? idCardImageUrl;
  final String? citizenFrontImageUrl;
  final String? citizenBackImageUrl;

  final String? bankName;
  final String? bankAccountNumber;
  final String? bankAccountName;

  final List<dynamic> hobbies;
  final List<dynamic> favoriteDestinationIds;
  final List<String> favoriteTravelRouteIds;
  final List<dynamic> favoriteEateries;
  final List<dynamic> cooperationIds;

  final String? avatarUrl;

  final int travelPoint;
  final int travelExp;
  final int travelTrip;
  final int feedbackTimes;

  final String userTier;
  final String role;

  final String createdAt;
  final String updatedAt;

  const User({
    required this.id,
    required this.username,
    this.email,
    this.phone,
    this.fcmToken,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isCitizenIdVerified,
    this.dateOfBirth,
    this.fullName,
    this.gender,
    this.address,
    this.nationality,
    this.citizenId,
    this.idCardImageUrl,
    this.citizenFrontImageUrl,
    this.citizenBackImageUrl,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountName,
    required this.hobbies,
    required this.favoriteDestinationIds,
    required this.favoriteTravelRouteIds,
    required this.favoriteEateries,
    required this.cooperationIds,
    this.avatarUrl,
    required this.travelPoint,
    required this.travelExp,
    required this.travelTrip,
    required this.feedbackTimes,
    required this.userTier,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',

      email: json['email'],
      phone: json['phone'],
      fcmToken: json['fcmToken'],

      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isCitizenIdVerified: json['isCitizenIdVerified'] ?? false,

      dateOfBirth: json['dateOfBirth'],
      fullName: json['fullName'],
      gender: json['gender'],
      address: json['address'],
      nationality: json['nationality'],
      citizenId: json['citizenId'],

      idCardImageUrl: json['idCardImageUrl'],
      citizenFrontImageUrl: json['citizenFrontImageUrl'],
      citizenBackImageUrl: json['citizenBackImageUrl'],

      bankName: json['bankName'],
      bankAccountNumber: json['bankAccountNumber'],
      bankAccountName: json['bankAccountName'],

      hobbies: json['hobbies'] as List? ?? [],
      favoriteDestinationIds: json['favoriteDestinationIds'] as List? ?? [],
      favoriteTravelRouteIds:
          (json['favoriteTravelRouteIds'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      favoriteEateries: json['favoriteEateries'] as List? ?? [],
      cooperationIds: json['cooperationIds'] as List? ?? [],

      avatarUrl: json['avatarUrl'],

      travelPoint: json['travelPoint'] ?? 0,
      travelExp: json['travelExp'] ?? 0,
      travelTrip: json['travelTrip'] ?? 0,
      feedbackTimes: json['feedbackTimes'] ?? 0,

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
      'email': email,
      'phone': phone,
      'fcmToken': fcmToken,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isCitizenIdVerified': isCitizenIdVerified,
      'dateOfBirth': dateOfBirth,
      'fullName': fullName,
      'gender': gender,
      'address': address,
      'nationality': nationality,
      'citizenId': citizenId,
      'idCardImageUrl': idCardImageUrl,
      'citizenFrontImageUrl': citizenFrontImageUrl,
      'citizenBackImageUrl': citizenBackImageUrl,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
      'hobbies': hobbies,
      'favoriteDestinationIds': favoriteDestinationIds,
      'favoriteTravelRouteIds': favoriteTravelRouteIds,
      'favoriteEateries': favoriteEateries,
      'cooperationIds': cooperationIds,
      'avatarUrl': avatarUrl,
      'travelPoint': travelPoint,
      'travelExp': travelExp,
      'travelTrip': travelTrip,
      'feedbackTimes': feedbackTimes,
      'userTier': userTier,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? phone,
    String? fcmToken,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isCitizenIdVerified,
    String? dateOfBirth,
    String? fullName,
    String? gender,
    String? address,
    String? nationality,
    String? citizenId,
    String? idCardImageUrl,
    String? citizenFrontImageUrl,
    String? citizenBackImageUrl,
    String? bankName,
    String? bankAccountNumber,
    String? bankAccountName,
    List<dynamic>? hobbies,
    List<dynamic>? favoriteDestinationIds,
    List<String>? favoriteTravelRouteIds,
    List<dynamic>? favoriteEateries,
    List<dynamic>? cooperationIds,
    String? avatarUrl,
    int? travelPoint,
    int? travelExp,
    int? travelTrip,
    int? feedbackTimes,
    String? userTier,
    String? role,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fcmToken: fcmToken ?? this.fcmToken,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isCitizenIdVerified: isCitizenIdVerified ?? this.isCitizenIdVerified,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      nationality: nationality ?? this.nationality,
      citizenId: citizenId ?? this.citizenId,
      idCardImageUrl: idCardImageUrl ?? this.idCardImageUrl,
      citizenFrontImageUrl: citizenFrontImageUrl ?? this.citizenFrontImageUrl,
      citizenBackImageUrl: citizenBackImageUrl ?? this.citizenBackImageUrl,
      bankName: bankName ?? this.bankName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      hobbies: hobbies ?? this.hobbies,
      favoriteDestinationIds:
          favoriteDestinationIds ?? this.favoriteDestinationIds,
      favoriteTravelRouteIds:
          favoriteTravelRouteIds ?? this.favoriteTravelRouteIds,
      favoriteEateries: favoriteEateries ?? this.favoriteEateries,
      cooperationIds: cooperationIds ?? this.cooperationIds,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      travelPoint: travelPoint ?? this.travelPoint,
      travelExp: travelExp ?? this.travelExp,
      travelTrip: travelTrip ?? this.travelTrip,
      feedbackTimes: feedbackTimes ?? this.feedbackTimes,
      userTier: userTier ?? this.userTier,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
