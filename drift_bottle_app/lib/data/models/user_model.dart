import 'dart:convert';
import '../../domain/entities/user.dart';

/// 用户模型
class UserModel {
  final String id;
  final String? phone;
  final String nickname;
  final String? avatar;
  final String? gender;
  final int? age;
  final String? location;
  final String? signature;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? thirdPartyId;
  
  const UserModel({
    required this.id,
    this.phone,
    required this.nickname,
    this.avatar,
    this.gender,
    this.age,
    this.location,
    this.signature,
    required this.createdAt,
    required this.updatedAt,
    this.thirdPartyId,
  });
  
  /// 从JSON创建用户模型
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      phone: json['phone'] as String?,
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      location: json['location'] as String?,
      signature: json['signature'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      thirdPartyId: json['third_party_id'] as String?,
    );
  }
  
  /// 从JSON字符串创建用户模型
  factory UserModel.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserModel.fromJson(json);
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'nickname': nickname,
      'avatar': avatar,
      'gender': gender,
      'age': age,
      'location': location,
      'signature': signature,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'third_party_id': thirdPartyId,
    };
  }
  
  /// 转换为JSON字符串
  String toJsonString() {
    return jsonEncode(toJson());
  }
  
  /// 转换为实体
  User toEntity() {
    return User(
      id: id,
      phone: phone,
      nickname: nickname,
      avatar: avatar,
      gender: gender,
      age: age,
      location: location,
      signature: signature,
      createdAt: createdAt,
      updatedAt: updatedAt,
      thirdPartyId: thirdPartyId,
    );
  }
  
  /// 从实体创建模型
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phone: user.phone,
      nickname: user.nickname,
      avatar: user.avatar,
      gender: user.gender,
      age: user.age,
      location: user.location,
      signature: user.signature,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      thirdPartyId: user.thirdPartyId,
    );
  }
  
  /// 复制并修改
  UserModel copyWith({
    String? id,
    String? phone,
    String? nickname,
    String? avatar,
    String? gender,
    int? age,
    String? location,
    String? signature,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? thirdPartyId,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      location: location ?? this.location,
      signature: signature ?? this.signature,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      thirdPartyId: thirdPartyId ?? this.thirdPartyId,
    );
  }
  
  @override
  String toString() {
    return 'UserModel(id: $id, nickname: $nickname, phone: $phone)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UserModel &&
        other.id == id &&
        other.phone == phone &&
        other.nickname == nickname &&
        other.avatar == avatar &&
        other.gender == gender &&
        other.age == age &&
        other.location == location &&
        other.signature == signature &&
        other.thirdPartyId == thirdPartyId;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        phone.hashCode ^
        nickname.hashCode ^
        avatar.hashCode ^
        gender.hashCode ^
        age.hashCode ^
        location.hashCode ^
        signature.hashCode ^
        thirdPartyId.hashCode;
  }
}

/// 用户列表模型
class UserListModel {
  final List<UserModel> users;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;
  
  const UserListModel({
    required this.users,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });
  
  factory UserListModel.fromJson(Map<String, dynamic> json) {
    final usersJson = json['users'] as List<dynamic>;
    final users = usersJson
        .map((userJson) => UserModel.fromJson(userJson as Map<String, dynamic>))
        .toList();
    
    return UserListModel(
      users: users,
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      hasMore: json['hasMore'] as bool,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'users': users.map((user) => user.toJson()).toList(),
      'total': total,
      'page': page,
      'pageSize': pageSize,
      'hasMore': hasMore,
    };
  }
}