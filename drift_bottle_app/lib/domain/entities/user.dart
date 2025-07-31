import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 隐私级别枚举
enum PrivacyLevel {
  everyone,
  friends,
  nobody,
}

/// 用户在线状态枚举
enum UserOnlineStatus {
  /// 在线
  online,
  
  /// 离线
  offline,
  
  /// 忙碌
  busy,
  
  /// 离开
  away,
  
  /// 隐身
  invisible,
}

/// 用户地理位置
@freezed
class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? city,
    String? province,
    String? country,
  }) = _UserLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);
}

/// 用户设置
@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    @Default(true) bool allowStrangerMessage,
    @Default(true) bool showOnlineStatus,
    @Default(false) bool showLocation,
    @Default(true) bool messageNotification,
    @Default(true) bool soundNotification,
    @Default(true) bool vibrationNotification,
    @Default(false) bool darkMode,
    @Default('zh_CN') String language,
    @Default(UserPrivacySettings()) UserPrivacySettings privacy,
    @Default(BottleSettings()) BottleSettings bottle,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);
}

/// 用户隐私设置
@freezed
class UserPrivacySettings with _$UserPrivacySettings {
  const factory UserPrivacySettings({
    @Default(PrivacyLevel.everyone) PrivacyLevel profileVisibility,
    @Default(PrivacyLevel.everyone) PrivacyLevel messagePermission,
    @Default(PrivacyLevel.friends) PrivacyLevel onlineStatusVisibility,
    @Default(PrivacyLevel.nobody) PrivacyLevel locationVisibility,
    @Default(true) bool allowSearch,
    @Default(true) bool allowRecommendation,
    @Default(false) bool hidePhoneNumber,
    @Default(false) bool hideEmail,
  }) = _UserPrivacySettings;

  factory UserPrivacySettings.fromJson(Map<String, dynamic> json) => _$UserPrivacySettingsFromJson(json);
}

/// 漂流瓶设置
@freezed
class BottleSettings with _$BottleSettings {
  const factory BottleSettings({
    @Default(true) bool receiveBottles,
    @Default(10.0) double receiveRange,
    @Default(false) bool onlySameCity,
    @Default(true) bool filterSensitiveContent,
    @Default(10) int dailySendLimit,
    @Default(50) int dailyPickLimit,
  }) = _BottleSettings;

  factory BottleSettings.fromJson(Map<String, dynamic> json) => _$BottleSettingsFromJson(json);
}

/// 用户实体
class User {
  /// 用户ID
  final String id;
  
  /// 手机号
  final String? phone;
  
  /// 昵称
  final String nickname;
  
  /// 头像URL
  final String? avatar;
  
  /// 性别
  final String? gender;
  
  /// 年龄
  final int? age;
  
  /// 地理位置
  final String? location;
  
  /// 个性签名
  final String? signature;
  
  /// 创建时间
  final DateTime createdAt;
  
  /// 更新时间
  final DateTime updatedAt;
  
  /// 第三方ID
  final String? thirdPartyId;
  
  const User({
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
  
  /// 获取显示名称
  String get displayName => nickname.isNotEmpty ? nickname : id;
  
  /// 获取性别显示文本
  String get genderText {
    switch (gender) {
      case 'male':
        return '男';
      case 'female':
        return '女';
      default:
        return '未知';
    }
  }
  
  /// 复制并修改
  User copyWith({
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
    return User(
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
    return 'User(id: $id, nickname: $nickname, phone: $phone)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User &&
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