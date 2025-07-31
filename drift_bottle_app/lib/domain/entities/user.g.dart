// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserLocationImpl _$$UserLocationImplFromJson(Map<String, dynamic> json) =>
    _$UserLocationImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$UserLocationImplToJson(_$UserLocationImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'city': instance.city,
      'province': instance.province,
      'country': instance.country,
    };

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      allowStrangerMessage: json['allowStrangerMessage'] as bool? ?? true,
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
      showLocation: json['showLocation'] as bool? ?? false,
      messageNotification: json['messageNotification'] as bool? ?? true,
      soundNotification: json['soundNotification'] as bool? ?? true,
      vibrationNotification: json['vibrationNotification'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'zh_CN',
      privacy: json['privacy'] == null
          ? const UserPrivacySettings()
          : UserPrivacySettings.fromJson(
              json['privacy'] as Map<String, dynamic>),
      bottle: json['bottle'] == null
          ? const BottleSettings()
          : BottleSettings.fromJson(json['bottle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'allowStrangerMessage': instance.allowStrangerMessage,
      'showOnlineStatus': instance.showOnlineStatus,
      'showLocation': instance.showLocation,
      'messageNotification': instance.messageNotification,
      'soundNotification': instance.soundNotification,
      'vibrationNotification': instance.vibrationNotification,
      'darkMode': instance.darkMode,
      'language': instance.language,
      'privacy': instance.privacy,
      'bottle': instance.bottle,
    };

_$UserPrivacySettingsImpl _$$UserPrivacySettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPrivacySettingsImpl(
      profileVisibility: $enumDecodeNullable(
              _$PrivacyLevelEnumMap, json['profileVisibility']) ??
          PrivacyLevel.everyone,
      messagePermission: $enumDecodeNullable(
              _$PrivacyLevelEnumMap, json['messagePermission']) ??
          PrivacyLevel.everyone,
      onlineStatusVisibility: $enumDecodeNullable(
              _$PrivacyLevelEnumMap, json['onlineStatusVisibility']) ??
          PrivacyLevel.friends,
      locationVisibility: $enumDecodeNullable(
              _$PrivacyLevelEnumMap, json['locationVisibility']) ??
          PrivacyLevel.nobody,
      allowSearch: json['allowSearch'] as bool? ?? true,
      allowRecommendation: json['allowRecommendation'] as bool? ?? true,
      hidePhoneNumber: json['hidePhoneNumber'] as bool? ?? false,
      hideEmail: json['hideEmail'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserPrivacySettingsImplToJson(
        _$UserPrivacySettingsImpl instance) =>
    <String, dynamic>{
      'profileVisibility': _$PrivacyLevelEnumMap[instance.profileVisibility]!,
      'messagePermission': _$PrivacyLevelEnumMap[instance.messagePermission]!,
      'onlineStatusVisibility':
          _$PrivacyLevelEnumMap[instance.onlineStatusVisibility]!,
      'locationVisibility': _$PrivacyLevelEnumMap[instance.locationVisibility]!,
      'allowSearch': instance.allowSearch,
      'allowRecommendation': instance.allowRecommendation,
      'hidePhoneNumber': instance.hidePhoneNumber,
      'hideEmail': instance.hideEmail,
    };

const _$PrivacyLevelEnumMap = {
  PrivacyLevel.everyone: 'everyone',
  PrivacyLevel.friends: 'friends',
  PrivacyLevel.nobody: 'nobody',
};

_$BottleSettingsImpl _$$BottleSettingsImplFromJson(Map<String, dynamic> json) =>
    _$BottleSettingsImpl(
      receiveBottles: json['receiveBottles'] as bool? ?? true,
      receiveRange: (json['receiveRange'] as num?)?.toDouble() ?? 10.0,
      onlySameCity: json['onlySameCity'] as bool? ?? false,
      filterSensitiveContent: json['filterSensitiveContent'] as bool? ?? true,
      dailySendLimit: (json['dailySendLimit'] as num?)?.toInt() ?? 10,
      dailyPickLimit: (json['dailyPickLimit'] as num?)?.toInt() ?? 50,
    );

Map<String, dynamic> _$$BottleSettingsImplToJson(
        _$BottleSettingsImpl instance) =>
    <String, dynamic>{
      'receiveBottles': instance.receiveBottles,
      'receiveRange': instance.receiveRange,
      'onlySameCity': instance.onlySameCity,
      'filterSensitiveContent': instance.filterSensitiveContent,
      'dailySendLimit': instance.dailySendLimit,
      'dailyPickLimit': instance.dailyPickLimit,
    };
