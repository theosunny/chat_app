import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// 用户数据模型
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.nickname,
    super.avatar,
    super.bio,
    required super.createdAt,
    required super.updatedAt,
    super.isOnline = false,
    super.lastActiveAt,
  });

  /// 从JSON创建UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// 从User实体创建UserModel
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      nickname: user.nickname,
      avatar: user.avatar,
      bio: user.bio,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isOnline: user.isOnline,
      lastActiveAt: user.lastActiveAt,
    );
  }

  /// 转换为User实体
  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      nickname: nickname,
      avatar: avatar,
      bio: bio,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isOnline: isOnline,
      lastActiveAt: lastActiveAt,
    );
  }

  /// 复制并更新部分字段
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? nickname,
    String? avatar,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isOnline,
    DateTime? lastActiveAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOnline: isOnline ?? this.isOnline,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}