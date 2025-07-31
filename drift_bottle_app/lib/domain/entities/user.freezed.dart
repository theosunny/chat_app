// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) {
  return _UserLocation.fromJson(json);
}

/// @nodoc
mixin _$UserLocation {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;

  /// Serializes this UserLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserLocationCopyWith<UserLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLocationCopyWith<$Res> {
  factory $UserLocationCopyWith(
          UserLocation value, $Res Function(UserLocation) then) =
      _$UserLocationCopyWithImpl<$Res, UserLocation>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      String? address,
      String? city,
      String? province,
      String? country});
}

/// @nodoc
class _$UserLocationCopyWithImpl<$Res, $Val extends UserLocation>
    implements $UserLocationCopyWith<$Res> {
  _$UserLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? country = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserLocationImplCopyWith<$Res>
    implements $UserLocationCopyWith<$Res> {
  factory _$$UserLocationImplCopyWith(
          _$UserLocationImpl value, $Res Function(_$UserLocationImpl) then) =
      __$$UserLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      String? address,
      String? city,
      String? province,
      String? country});
}

/// @nodoc
class __$$UserLocationImplCopyWithImpl<$Res>
    extends _$UserLocationCopyWithImpl<$Res, _$UserLocationImpl>
    implements _$$UserLocationImplCopyWith<$Res> {
  __$$UserLocationImplCopyWithImpl(
      _$UserLocationImpl _value, $Res Function(_$UserLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? country = freezed,
  }) {
    return _then(_$UserLocationImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserLocationImpl implements _UserLocation {
  const _$UserLocationImpl(
      {required this.latitude,
      required this.longitude,
      this.address,
      this.city,
      this.province,
      this.country});

  factory _$UserLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserLocationImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? province;
  @override
  final String? country;

  @override
  String toString() {
    return 'UserLocation(latitude: $latitude, longitude: $longitude, address: $address, city: $city, province: $province, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, latitude, longitude, address, city, province, country);

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserLocationImplCopyWith<_$UserLocationImpl> get copyWith =>
      __$$UserLocationImplCopyWithImpl<_$UserLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserLocationImplToJson(
      this,
    );
  }
}

abstract class _UserLocation implements UserLocation {
  const factory _UserLocation(
      {required final double latitude,
      required final double longitude,
      final String? address,
      final String? city,
      final String? province,
      final String? country}) = _$UserLocationImpl;

  factory _UserLocation.fromJson(Map<String, dynamic> json) =
      _$UserLocationImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get province;
  @override
  String? get country;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserLocationImplCopyWith<_$UserLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  bool get allowStrangerMessage => throw _privateConstructorUsedError;
  bool get showOnlineStatus => throw _privateConstructorUsedError;
  bool get showLocation => throw _privateConstructorUsedError;
  bool get messageNotification => throw _privateConstructorUsedError;
  bool get soundNotification => throw _privateConstructorUsedError;
  bool get vibrationNotification => throw _privateConstructorUsedError;
  bool get darkMode => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  UserPrivacySettings get privacy => throw _privateConstructorUsedError;
  BottleSettings get bottle => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {bool allowStrangerMessage,
      bool showOnlineStatus,
      bool showLocation,
      bool messageNotification,
      bool soundNotification,
      bool vibrationNotification,
      bool darkMode,
      String language,
      UserPrivacySettings privacy,
      BottleSettings bottle});

  $UserPrivacySettingsCopyWith<$Res> get privacy;
  $BottleSettingsCopyWith<$Res> get bottle;
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowStrangerMessage = null,
    Object? showOnlineStatus = null,
    Object? showLocation = null,
    Object? messageNotification = null,
    Object? soundNotification = null,
    Object? vibrationNotification = null,
    Object? darkMode = null,
    Object? language = null,
    Object? privacy = null,
    Object? bottle = null,
  }) {
    return _then(_value.copyWith(
      allowStrangerMessage: null == allowStrangerMessage
          ? _value.allowStrangerMessage
          : allowStrangerMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      showOnlineStatus: null == showOnlineStatus
          ? _value.showOnlineStatus
          : showOnlineStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      showLocation: null == showLocation
          ? _value.showLocation
          : showLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      messageNotification: null == messageNotification
          ? _value.messageNotification
          : messageNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      soundNotification: null == soundNotification
          ? _value.soundNotification
          : soundNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationNotification: null == vibrationNotification
          ? _value.vibrationNotification
          : vibrationNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      darkMode: null == darkMode
          ? _value.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as UserPrivacySettings,
      bottle: null == bottle
          ? _value.bottle
          : bottle // ignore: cast_nullable_to_non_nullable
              as BottleSettings,
    ) as $Val);
  }

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPrivacySettingsCopyWith<$Res> get privacy {
    return $UserPrivacySettingsCopyWith<$Res>(_value.privacy, (value) {
      return _then(_value.copyWith(privacy: value) as $Val);
    });
  }

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BottleSettingsCopyWith<$Res> get bottle {
    return $BottleSettingsCopyWith<$Res>(_value.bottle, (value) {
      return _then(_value.copyWith(bottle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool allowStrangerMessage,
      bool showOnlineStatus,
      bool showLocation,
      bool messageNotification,
      bool soundNotification,
      bool vibrationNotification,
      bool darkMode,
      String language,
      UserPrivacySettings privacy,
      BottleSettings bottle});

  @override
  $UserPrivacySettingsCopyWith<$Res> get privacy;
  @override
  $BottleSettingsCopyWith<$Res> get bottle;
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowStrangerMessage = null,
    Object? showOnlineStatus = null,
    Object? showLocation = null,
    Object? messageNotification = null,
    Object? soundNotification = null,
    Object? vibrationNotification = null,
    Object? darkMode = null,
    Object? language = null,
    Object? privacy = null,
    Object? bottle = null,
  }) {
    return _then(_$UserSettingsImpl(
      allowStrangerMessage: null == allowStrangerMessage
          ? _value.allowStrangerMessage
          : allowStrangerMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      showOnlineStatus: null == showOnlineStatus
          ? _value.showOnlineStatus
          : showOnlineStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      showLocation: null == showLocation
          ? _value.showLocation
          : showLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      messageNotification: null == messageNotification
          ? _value.messageNotification
          : messageNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      soundNotification: null == soundNotification
          ? _value.soundNotification
          : soundNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationNotification: null == vibrationNotification
          ? _value.vibrationNotification
          : vibrationNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      darkMode: null == darkMode
          ? _value.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as UserPrivacySettings,
      bottle: null == bottle
          ? _value.bottle
          : bottle // ignore: cast_nullable_to_non_nullable
              as BottleSettings,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl(
      {this.allowStrangerMessage = true,
      this.showOnlineStatus = true,
      this.showLocation = false,
      this.messageNotification = true,
      this.soundNotification = true,
      this.vibrationNotification = true,
      this.darkMode = false,
      this.language = 'zh_CN',
      this.privacy = const UserPrivacySettings(),
      this.bottle = const BottleSettings()});

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool allowStrangerMessage;
  @override
  @JsonKey()
  final bool showOnlineStatus;
  @override
  @JsonKey()
  final bool showLocation;
  @override
  @JsonKey()
  final bool messageNotification;
  @override
  @JsonKey()
  final bool soundNotification;
  @override
  @JsonKey()
  final bool vibrationNotification;
  @override
  @JsonKey()
  final bool darkMode;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final UserPrivacySettings privacy;
  @override
  @JsonKey()
  final BottleSettings bottle;

  @override
  String toString() {
    return 'UserSettings(allowStrangerMessage: $allowStrangerMessage, showOnlineStatus: $showOnlineStatus, showLocation: $showLocation, messageNotification: $messageNotification, soundNotification: $soundNotification, vibrationNotification: $vibrationNotification, darkMode: $darkMode, language: $language, privacy: $privacy, bottle: $bottle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.allowStrangerMessage, allowStrangerMessage) ||
                other.allowStrangerMessage == allowStrangerMessage) &&
            (identical(other.showOnlineStatus, showOnlineStatus) ||
                other.showOnlineStatus == showOnlineStatus) &&
            (identical(other.showLocation, showLocation) ||
                other.showLocation == showLocation) &&
            (identical(other.messageNotification, messageNotification) ||
                other.messageNotification == messageNotification) &&
            (identical(other.soundNotification, soundNotification) ||
                other.soundNotification == soundNotification) &&
            (identical(other.vibrationNotification, vibrationNotification) ||
                other.vibrationNotification == vibrationNotification) &&
            (identical(other.darkMode, darkMode) ||
                other.darkMode == darkMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            (identical(other.bottle, bottle) || other.bottle == bottle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      allowStrangerMessage,
      showOnlineStatus,
      showLocation,
      messageNotification,
      soundNotification,
      vibrationNotification,
      darkMode,
      language,
      privacy,
      bottle);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings(
      {final bool allowStrangerMessage,
      final bool showOnlineStatus,
      final bool showLocation,
      final bool messageNotification,
      final bool soundNotification,
      final bool vibrationNotification,
      final bool darkMode,
      final String language,
      final UserPrivacySettings privacy,
      final BottleSettings bottle}) = _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  bool get allowStrangerMessage;
  @override
  bool get showOnlineStatus;
  @override
  bool get showLocation;
  @override
  bool get messageNotification;
  @override
  bool get soundNotification;
  @override
  bool get vibrationNotification;
  @override
  bool get darkMode;
  @override
  String get language;
  @override
  UserPrivacySettings get privacy;
  @override
  BottleSettings get bottle;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPrivacySettings _$UserPrivacySettingsFromJson(Map<String, dynamic> json) {
  return _UserPrivacySettings.fromJson(json);
}

/// @nodoc
mixin _$UserPrivacySettings {
  PrivacyLevel get profileVisibility => throw _privateConstructorUsedError;
  PrivacyLevel get messagePermission => throw _privateConstructorUsedError;
  PrivacyLevel get onlineStatusVisibility => throw _privateConstructorUsedError;
  PrivacyLevel get locationVisibility => throw _privateConstructorUsedError;
  bool get allowSearch => throw _privateConstructorUsedError;
  bool get allowRecommendation => throw _privateConstructorUsedError;
  bool get hidePhoneNumber => throw _privateConstructorUsedError;
  bool get hideEmail => throw _privateConstructorUsedError;

  /// Serializes this UserPrivacySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPrivacySettingsCopyWith<UserPrivacySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPrivacySettingsCopyWith<$Res> {
  factory $UserPrivacySettingsCopyWith(
          UserPrivacySettings value, $Res Function(UserPrivacySettings) then) =
      _$UserPrivacySettingsCopyWithImpl<$Res, UserPrivacySettings>;
  @useResult
  $Res call(
      {PrivacyLevel profileVisibility,
      PrivacyLevel messagePermission,
      PrivacyLevel onlineStatusVisibility,
      PrivacyLevel locationVisibility,
      bool allowSearch,
      bool allowRecommendation,
      bool hidePhoneNumber,
      bool hideEmail});
}

/// @nodoc
class _$UserPrivacySettingsCopyWithImpl<$Res, $Val extends UserPrivacySettings>
    implements $UserPrivacySettingsCopyWith<$Res> {
  _$UserPrivacySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileVisibility = null,
    Object? messagePermission = null,
    Object? onlineStatusVisibility = null,
    Object? locationVisibility = null,
    Object? allowSearch = null,
    Object? allowRecommendation = null,
    Object? hidePhoneNumber = null,
    Object? hideEmail = null,
  }) {
    return _then(_value.copyWith(
      profileVisibility: null == profileVisibility
          ? _value.profileVisibility
          : profileVisibility // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      messagePermission: null == messagePermission
          ? _value.messagePermission
          : messagePermission // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      onlineStatusVisibility: null == onlineStatusVisibility
          ? _value.onlineStatusVisibility
          : onlineStatusVisibility // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      locationVisibility: null == locationVisibility
          ? _value.locationVisibility
          : locationVisibility // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      allowSearch: null == allowSearch
          ? _value.allowSearch
          : allowSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      allowRecommendation: null == allowRecommendation
          ? _value.allowRecommendation
          : allowRecommendation // ignore: cast_nullable_to_non_nullable
              as bool,
      hidePhoneNumber: null == hidePhoneNumber
          ? _value.hidePhoneNumber
          : hidePhoneNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      hideEmail: null == hideEmail
          ? _value.hideEmail
          : hideEmail // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPrivacySettingsImplCopyWith<$Res>
    implements $UserPrivacySettingsCopyWith<$Res> {
  factory _$$UserPrivacySettingsImplCopyWith(_$UserPrivacySettingsImpl value,
          $Res Function(_$UserPrivacySettingsImpl) then) =
      __$$UserPrivacySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PrivacyLevel profileVisibility,
      PrivacyLevel messagePermission,
      PrivacyLevel onlineStatusVisibility,
      PrivacyLevel locationVisibility,
      bool allowSearch,
      bool allowRecommendation,
      bool hidePhoneNumber,
      bool hideEmail});
}

/// @nodoc
class __$$UserPrivacySettingsImplCopyWithImpl<$Res>
    extends _$UserPrivacySettingsCopyWithImpl<$Res, _$UserPrivacySettingsImpl>
    implements _$$UserPrivacySettingsImplCopyWith<$Res> {
  __$$UserPrivacySettingsImplCopyWithImpl(_$UserPrivacySettingsImpl _value,
      $Res Function(_$UserPrivacySettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileVisibility = null,
    Object? messagePermission = null,
    Object? onlineStatusVisibility = null,
    Object? locationVisibility = null,
    Object? allowSearch = null,
    Object? allowRecommendation = null,
    Object? hidePhoneNumber = null,
    Object? hideEmail = null,
  }) {
    return _then(_$UserPrivacySettingsImpl(
      profileVisibility: null == profileVisibility
          ? _value.profileVisibility
          : profileVisibility // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      messagePermission: null == messagePermission
          ? _value.messagePermission
          : messagePermission // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      onlineStatusVisibility: null == onlineStatusVisibility
          ? _value.onlineStatusVisibility
          : onlineStatusVisibility // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      locationVisibility: null == locationVisibility
          ? _value.locationVisibility
          : locationVisibility // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      allowSearch: null == allowSearch
          ? _value.allowSearch
          : allowSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      allowRecommendation: null == allowRecommendation
          ? _value.allowRecommendation
          : allowRecommendation // ignore: cast_nullable_to_non_nullable
              as bool,
      hidePhoneNumber: null == hidePhoneNumber
          ? _value.hidePhoneNumber
          : hidePhoneNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      hideEmail: null == hideEmail
          ? _value.hideEmail
          : hideEmail // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPrivacySettingsImpl implements _UserPrivacySettings {
  const _$UserPrivacySettingsImpl(
      {this.profileVisibility = PrivacyLevel.everyone,
      this.messagePermission = PrivacyLevel.everyone,
      this.onlineStatusVisibility = PrivacyLevel.friends,
      this.locationVisibility = PrivacyLevel.nobody,
      this.allowSearch = true,
      this.allowRecommendation = true,
      this.hidePhoneNumber = false,
      this.hideEmail = false});

  factory _$UserPrivacySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPrivacySettingsImplFromJson(json);

  @override
  @JsonKey()
  final PrivacyLevel profileVisibility;
  @override
  @JsonKey()
  final PrivacyLevel messagePermission;
  @override
  @JsonKey()
  final PrivacyLevel onlineStatusVisibility;
  @override
  @JsonKey()
  final PrivacyLevel locationVisibility;
  @override
  @JsonKey()
  final bool allowSearch;
  @override
  @JsonKey()
  final bool allowRecommendation;
  @override
  @JsonKey()
  final bool hidePhoneNumber;
  @override
  @JsonKey()
  final bool hideEmail;

  @override
  String toString() {
    return 'UserPrivacySettings(profileVisibility: $profileVisibility, messagePermission: $messagePermission, onlineStatusVisibility: $onlineStatusVisibility, locationVisibility: $locationVisibility, allowSearch: $allowSearch, allowRecommendation: $allowRecommendation, hidePhoneNumber: $hidePhoneNumber, hideEmail: $hideEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPrivacySettingsImpl &&
            (identical(other.profileVisibility, profileVisibility) ||
                other.profileVisibility == profileVisibility) &&
            (identical(other.messagePermission, messagePermission) ||
                other.messagePermission == messagePermission) &&
            (identical(other.onlineStatusVisibility, onlineStatusVisibility) ||
                other.onlineStatusVisibility == onlineStatusVisibility) &&
            (identical(other.locationVisibility, locationVisibility) ||
                other.locationVisibility == locationVisibility) &&
            (identical(other.allowSearch, allowSearch) ||
                other.allowSearch == allowSearch) &&
            (identical(other.allowRecommendation, allowRecommendation) ||
                other.allowRecommendation == allowRecommendation) &&
            (identical(other.hidePhoneNumber, hidePhoneNumber) ||
                other.hidePhoneNumber == hidePhoneNumber) &&
            (identical(other.hideEmail, hideEmail) ||
                other.hideEmail == hideEmail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      profileVisibility,
      messagePermission,
      onlineStatusVisibility,
      locationVisibility,
      allowSearch,
      allowRecommendation,
      hidePhoneNumber,
      hideEmail);

  /// Create a copy of UserPrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPrivacySettingsImplCopyWith<_$UserPrivacySettingsImpl> get copyWith =>
      __$$UserPrivacySettingsImplCopyWithImpl<_$UserPrivacySettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPrivacySettingsImplToJson(
      this,
    );
  }
}

abstract class _UserPrivacySettings implements UserPrivacySettings {
  const factory _UserPrivacySettings(
      {final PrivacyLevel profileVisibility,
      final PrivacyLevel messagePermission,
      final PrivacyLevel onlineStatusVisibility,
      final PrivacyLevel locationVisibility,
      final bool allowSearch,
      final bool allowRecommendation,
      final bool hidePhoneNumber,
      final bool hideEmail}) = _$UserPrivacySettingsImpl;

  factory _UserPrivacySettings.fromJson(Map<String, dynamic> json) =
      _$UserPrivacySettingsImpl.fromJson;

  @override
  PrivacyLevel get profileVisibility;
  @override
  PrivacyLevel get messagePermission;
  @override
  PrivacyLevel get onlineStatusVisibility;
  @override
  PrivacyLevel get locationVisibility;
  @override
  bool get allowSearch;
  @override
  bool get allowRecommendation;
  @override
  bool get hidePhoneNumber;
  @override
  bool get hideEmail;

  /// Create a copy of UserPrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPrivacySettingsImplCopyWith<_$UserPrivacySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BottleSettings _$BottleSettingsFromJson(Map<String, dynamic> json) {
  return _BottleSettings.fromJson(json);
}

/// @nodoc
mixin _$BottleSettings {
  bool get receiveBottles => throw _privateConstructorUsedError;
  double get receiveRange => throw _privateConstructorUsedError;
  bool get onlySameCity => throw _privateConstructorUsedError;
  bool get filterSensitiveContent => throw _privateConstructorUsedError;
  int get dailySendLimit => throw _privateConstructorUsedError;
  int get dailyPickLimit => throw _privateConstructorUsedError;

  /// Serializes this BottleSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BottleSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BottleSettingsCopyWith<BottleSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottleSettingsCopyWith<$Res> {
  factory $BottleSettingsCopyWith(
          BottleSettings value, $Res Function(BottleSettings) then) =
      _$BottleSettingsCopyWithImpl<$Res, BottleSettings>;
  @useResult
  $Res call(
      {bool receiveBottles,
      double receiveRange,
      bool onlySameCity,
      bool filterSensitiveContent,
      int dailySendLimit,
      int dailyPickLimit});
}

/// @nodoc
class _$BottleSettingsCopyWithImpl<$Res, $Val extends BottleSettings>
    implements $BottleSettingsCopyWith<$Res> {
  _$BottleSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BottleSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receiveBottles = null,
    Object? receiveRange = null,
    Object? onlySameCity = null,
    Object? filterSensitiveContent = null,
    Object? dailySendLimit = null,
    Object? dailyPickLimit = null,
  }) {
    return _then(_value.copyWith(
      receiveBottles: null == receiveBottles
          ? _value.receiveBottles
          : receiveBottles // ignore: cast_nullable_to_non_nullable
              as bool,
      receiveRange: null == receiveRange
          ? _value.receiveRange
          : receiveRange // ignore: cast_nullable_to_non_nullable
              as double,
      onlySameCity: null == onlySameCity
          ? _value.onlySameCity
          : onlySameCity // ignore: cast_nullable_to_non_nullable
              as bool,
      filterSensitiveContent: null == filterSensitiveContent
          ? _value.filterSensitiveContent
          : filterSensitiveContent // ignore: cast_nullable_to_non_nullable
              as bool,
      dailySendLimit: null == dailySendLimit
          ? _value.dailySendLimit
          : dailySendLimit // ignore: cast_nullable_to_non_nullable
              as int,
      dailyPickLimit: null == dailyPickLimit
          ? _value.dailyPickLimit
          : dailyPickLimit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BottleSettingsImplCopyWith<$Res>
    implements $BottleSettingsCopyWith<$Res> {
  factory _$$BottleSettingsImplCopyWith(_$BottleSettingsImpl value,
          $Res Function(_$BottleSettingsImpl) then) =
      __$$BottleSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool receiveBottles,
      double receiveRange,
      bool onlySameCity,
      bool filterSensitiveContent,
      int dailySendLimit,
      int dailyPickLimit});
}

/// @nodoc
class __$$BottleSettingsImplCopyWithImpl<$Res>
    extends _$BottleSettingsCopyWithImpl<$Res, _$BottleSettingsImpl>
    implements _$$BottleSettingsImplCopyWith<$Res> {
  __$$BottleSettingsImplCopyWithImpl(
      _$BottleSettingsImpl _value, $Res Function(_$BottleSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BottleSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receiveBottles = null,
    Object? receiveRange = null,
    Object? onlySameCity = null,
    Object? filterSensitiveContent = null,
    Object? dailySendLimit = null,
    Object? dailyPickLimit = null,
  }) {
    return _then(_$BottleSettingsImpl(
      receiveBottles: null == receiveBottles
          ? _value.receiveBottles
          : receiveBottles // ignore: cast_nullable_to_non_nullable
              as bool,
      receiveRange: null == receiveRange
          ? _value.receiveRange
          : receiveRange // ignore: cast_nullable_to_non_nullable
              as double,
      onlySameCity: null == onlySameCity
          ? _value.onlySameCity
          : onlySameCity // ignore: cast_nullable_to_non_nullable
              as bool,
      filterSensitiveContent: null == filterSensitiveContent
          ? _value.filterSensitiveContent
          : filterSensitiveContent // ignore: cast_nullable_to_non_nullable
              as bool,
      dailySendLimit: null == dailySendLimit
          ? _value.dailySendLimit
          : dailySendLimit // ignore: cast_nullable_to_non_nullable
              as int,
      dailyPickLimit: null == dailyPickLimit
          ? _value.dailyPickLimit
          : dailyPickLimit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BottleSettingsImpl implements _BottleSettings {
  const _$BottleSettingsImpl(
      {this.receiveBottles = true,
      this.receiveRange = 10.0,
      this.onlySameCity = false,
      this.filterSensitiveContent = true,
      this.dailySendLimit = 10,
      this.dailyPickLimit = 50});

  factory _$BottleSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BottleSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool receiveBottles;
  @override
  @JsonKey()
  final double receiveRange;
  @override
  @JsonKey()
  final bool onlySameCity;
  @override
  @JsonKey()
  final bool filterSensitiveContent;
  @override
  @JsonKey()
  final int dailySendLimit;
  @override
  @JsonKey()
  final int dailyPickLimit;

  @override
  String toString() {
    return 'BottleSettings(receiveBottles: $receiveBottles, receiveRange: $receiveRange, onlySameCity: $onlySameCity, filterSensitiveContent: $filterSensitiveContent, dailySendLimit: $dailySendLimit, dailyPickLimit: $dailyPickLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottleSettingsImpl &&
            (identical(other.receiveBottles, receiveBottles) ||
                other.receiveBottles == receiveBottles) &&
            (identical(other.receiveRange, receiveRange) ||
                other.receiveRange == receiveRange) &&
            (identical(other.onlySameCity, onlySameCity) ||
                other.onlySameCity == onlySameCity) &&
            (identical(other.filterSensitiveContent, filterSensitiveContent) ||
                other.filterSensitiveContent == filterSensitiveContent) &&
            (identical(other.dailySendLimit, dailySendLimit) ||
                other.dailySendLimit == dailySendLimit) &&
            (identical(other.dailyPickLimit, dailyPickLimit) ||
                other.dailyPickLimit == dailyPickLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, receiveBottles, receiveRange,
      onlySameCity, filterSensitiveContent, dailySendLimit, dailyPickLimit);

  /// Create a copy of BottleSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BottleSettingsImplCopyWith<_$BottleSettingsImpl> get copyWith =>
      __$$BottleSettingsImplCopyWithImpl<_$BottleSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BottleSettingsImplToJson(
      this,
    );
  }
}

abstract class _BottleSettings implements BottleSettings {
  const factory _BottleSettings(
      {final bool receiveBottles,
      final double receiveRange,
      final bool onlySameCity,
      final bool filterSensitiveContent,
      final int dailySendLimit,
      final int dailyPickLimit}) = _$BottleSettingsImpl;

  factory _BottleSettings.fromJson(Map<String, dynamic> json) =
      _$BottleSettingsImpl.fromJson;

  @override
  bool get receiveBottles;
  @override
  double get receiveRange;
  @override
  bool get onlySameCity;
  @override
  bool get filterSensitiveContent;
  @override
  int get dailySendLimit;
  @override
  int get dailyPickLimit;

  /// Create a copy of BottleSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BottleSettingsImplCopyWith<_$BottleSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
