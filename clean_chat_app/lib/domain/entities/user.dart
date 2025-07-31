import 'package:equatable/equatable.dart';

/// 用户实体
class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? nickname;
  final String? avatar;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isOnline;
  final DateTime? lastActiveAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.nickname,
    this.avatar,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    this.isOnline = false,
    this.lastActiveAt,
  });

  /// 获取显示名称
  String get displayName => nickname ?? username;

  /// 是否有头像
  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  /// 复制并更新字段
  User copyWith({
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
    return User(
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

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        nickname,
        avatar,
        bio,
        createdAt,
        updatedAt,
        isOnline,
        lastActiveAt,
      ];

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, nickname: $nickname)';
  }
}