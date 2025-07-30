class UserModel {
  final String id;
  final String nickname;
  final String? avatar;
  final String? phone;
  final String? email;
  final int gender; // 0: 未知, 1: 男, 2: 女
  final String? signature;
  final int followCount;
  final int fansCount;
  final int bottleCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  UserModel({
    required this.id,
    required this.nickname,
    this.avatar,
    this.phone,
    this.email,
    this.gender = 0,
    this.signature,
    this.followCount = 0,
    this.fansCount = 0,
    this.bottleCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      nickname: json['nickname'] ?? '',
      avatar: json['avatar'],
      phone: json['phone'],
      email: json['email'],
      gender: _parseGender(json['gender']),
      signature: json['signature'],
      followCount: json['follow_count'] ?? 0,
      fansCount: json['fans_count'] ?? 0,
      bottleCount: json['bottle_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'gender': gender,
      'signature': signature,
      'follow_count': followCount,
      'fans_count': fansCount,
      'bottle_count': bottleCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  UserModel copyWith({
    String? id,
    String? nickname,
    String? avatar,
    String? phone,
    String? email,
    int? gender,
    String? signature,
    int? followCount,
    int? fansCount,
    int? bottleCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      signature: signature ?? this.signature,
      followCount: followCount ?? this.followCount,
      fansCount: fansCount ?? this.fansCount,
      bottleCount: bottleCount ?? this.bottleCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  String get genderText {
    switch (gender) {
      case 1:
        return '男';
      case 2:
        return '女';
      default:
        return '未知';
    }
  }
  
  static int _parseGender(dynamic gender) {
    if (gender is int) {
      return gender;
    } else if (gender is String) {
      switch (gender.toLowerCase()) {
        case 'male':
        case '男':
          return 1;
        case 'female':
        case '女':
          return 2;
        default:
          return 0;
      }
    }
    return 0;
  }
}