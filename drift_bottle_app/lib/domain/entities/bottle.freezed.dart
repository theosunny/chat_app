// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Bottle {
  /// 漂流瓶ID
  String get id => throw _privateConstructorUsedError;

  /// 发送者信息
  User get sender => throw _privateConstructorUsedError;

  /// 内容
  String get content => throw _privateConstructorUsedError;

  /// 内容类型
  BottleContentType get contentType => throw _privateConstructorUsedError;

  /// 媒体文件列表 (图片、音频等)
  List<BottleMedia> get mediaList => throw _privateConstructorUsedError;

  /// 标签列表
  List<String> get tags => throw _privateConstructorUsedError;

  /// 发送位置
  BottleLocation? get sendLocation => throw _privateConstructorUsedError;

  /// 当前位置 (漂流过程中的位置)
  BottleLocation? get currentLocation => throw _privateConstructorUsedError;

  /// 漂流瓶状态
  BottleStatus get status => throw _privateConstructorUsedError;

  /// 漂流瓶类型
  BottleType get type => throw _privateConstructorUsedError;

  /// 优先级 (影响被捡到的概率)
  BottlePriority get priority => throw _privateConstructorUsedError;

  /// 有效期 (小时)
  int get validHours => throw _privateConstructorUsedError;

  /// 最大漂流距离 (公里)
  double get maxDriftDistance => throw _privateConstructorUsedError;

  /// 已漂流距离 (公里)
  double get driftedDistance => throw _privateConstructorUsedError;

  /// 被查看次数
  int get viewCount => throw _privateConstructorUsedError;

  /// 被点赞次数
  int get likeCount => throw _privateConstructorUsedError;

  /// 被收藏次数
  int get favoriteCount => throw _privateConstructorUsedError;

  /// 回复数量
  int get replyCount => throw _privateConstructorUsedError;

  /// 是否匿名
  bool get isAnonymous => throw _privateConstructorUsedError;

  /// 是否私密 (只有特定用户可见)
  bool get isPrivate => throw _privateConstructorUsedError;

  /// 是否置顶
  bool get isPinned => throw _privateConstructorUsedError;

  /// 是否被举报
  bool get isReported => throw _privateConstructorUsedError;

  /// 是否被删除
  bool get isDeleted => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 过期时间
  DateTime? get expiredAt => throw _privateConstructorUsedError;

  /// 被捡到时间
  DateTime? get pickedAt => throw _privateConstructorUsedError;

  /// 捡到者信息
  User? get picker => throw _privateConstructorUsedError;

  /// 漂流轨迹
  List<BottleTrack> get driftTrack => throw _privateConstructorUsedError;

  /// 扩展数据
  Map<String, dynamic>? get extra => throw _privateConstructorUsedError;

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BottleCopyWith<Bottle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottleCopyWith<$Res> {
  factory $BottleCopyWith(Bottle value, $Res Function(Bottle) then) =
      _$BottleCopyWithImpl<$Res, Bottle>;
  @useResult
  $Res call(
      {String id,
      User sender,
      String content,
      BottleContentType contentType,
      List<BottleMedia> mediaList,
      List<String> tags,
      BottleLocation? sendLocation,
      BottleLocation? currentLocation,
      BottleStatus status,
      BottleType type,
      BottlePriority priority,
      int validHours,
      double maxDriftDistance,
      double driftedDistance,
      int viewCount,
      int likeCount,
      int favoriteCount,
      int replyCount,
      bool isAnonymous,
      bool isPrivate,
      bool isPinned,
      bool isReported,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? expiredAt,
      DateTime? pickedAt,
      User? picker,
      List<BottleTrack> driftTrack,
      Map<String, dynamic>? extra});

  $BottleLocationCopyWith<$Res>? get sendLocation;
  $BottleLocationCopyWith<$Res>? get currentLocation;
}

/// @nodoc
class _$BottleCopyWithImpl<$Res, $Val extends Bottle>
    implements $BottleCopyWith<$Res> {
  _$BottleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sender = null,
    Object? content = null,
    Object? contentType = null,
    Object? mediaList = null,
    Object? tags = null,
    Object? sendLocation = freezed,
    Object? currentLocation = freezed,
    Object? status = null,
    Object? type = null,
    Object? priority = null,
    Object? validHours = null,
    Object? maxDriftDistance = null,
    Object? driftedDistance = null,
    Object? viewCount = null,
    Object? likeCount = null,
    Object? favoriteCount = null,
    Object? replyCount = null,
    Object? isAnonymous = null,
    Object? isPrivate = null,
    Object? isPinned = null,
    Object? isReported = null,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? expiredAt = freezed,
    Object? pickedAt = freezed,
    Object? picker = freezed,
    Object? driftTrack = null,
    Object? extra = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as User,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as BottleContentType,
      mediaList: null == mediaList
          ? _value.mediaList
          : mediaList // ignore: cast_nullable_to_non_nullable
              as List<BottleMedia>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sendLocation: freezed == sendLocation
          ? _value.sendLocation
          : sendLocation // ignore: cast_nullable_to_non_nullable
              as BottleLocation?,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as BottleLocation?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BottleStatus,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BottleType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as BottlePriority,
      validHours: null == validHours
          ? _value.validHours
          : validHours // ignore: cast_nullable_to_non_nullable
              as int,
      maxDriftDistance: null == maxDriftDistance
          ? _value.maxDriftDistance
          : maxDriftDistance // ignore: cast_nullable_to_non_nullable
              as double,
      driftedDistance: null == driftedDistance
          ? _value.driftedDistance
          : driftedDistance // ignore: cast_nullable_to_non_nullable
              as double,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteCount: null == favoriteCount
          ? _value.favoriteCount
          : favoriteCount // ignore: cast_nullable_to_non_nullable
              as int,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiredAt: freezed == expiredAt
          ? _value.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedAt: freezed == pickedAt
          ? _value.pickedAt
          : pickedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      picker: freezed == picker
          ? _value.picker
          : picker // ignore: cast_nullable_to_non_nullable
              as User?,
      driftTrack: null == driftTrack
          ? _value.driftTrack
          : driftTrack // ignore: cast_nullable_to_non_nullable
              as List<BottleTrack>,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BottleLocationCopyWith<$Res>? get sendLocation {
    if (_value.sendLocation == null) {
      return null;
    }

    return $BottleLocationCopyWith<$Res>(_value.sendLocation!, (value) {
      return _then(_value.copyWith(sendLocation: value) as $Val);
    });
  }

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BottleLocationCopyWith<$Res>? get currentLocation {
    if (_value.currentLocation == null) {
      return null;
    }

    return $BottleLocationCopyWith<$Res>(_value.currentLocation!, (value) {
      return _then(_value.copyWith(currentLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BottleImplCopyWith<$Res> implements $BottleCopyWith<$Res> {
  factory _$$BottleImplCopyWith(
          _$BottleImpl value, $Res Function(_$BottleImpl) then) =
      __$$BottleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      User sender,
      String content,
      BottleContentType contentType,
      List<BottleMedia> mediaList,
      List<String> tags,
      BottleLocation? sendLocation,
      BottleLocation? currentLocation,
      BottleStatus status,
      BottleType type,
      BottlePriority priority,
      int validHours,
      double maxDriftDistance,
      double driftedDistance,
      int viewCount,
      int likeCount,
      int favoriteCount,
      int replyCount,
      bool isAnonymous,
      bool isPrivate,
      bool isPinned,
      bool isReported,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? expiredAt,
      DateTime? pickedAt,
      User? picker,
      List<BottleTrack> driftTrack,
      Map<String, dynamic>? extra});

  @override
  $BottleLocationCopyWith<$Res>? get sendLocation;
  @override
  $BottleLocationCopyWith<$Res>? get currentLocation;
}

/// @nodoc
class __$$BottleImplCopyWithImpl<$Res>
    extends _$BottleCopyWithImpl<$Res, _$BottleImpl>
    implements _$$BottleImplCopyWith<$Res> {
  __$$BottleImplCopyWithImpl(
      _$BottleImpl _value, $Res Function(_$BottleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sender = null,
    Object? content = null,
    Object? contentType = null,
    Object? mediaList = null,
    Object? tags = null,
    Object? sendLocation = freezed,
    Object? currentLocation = freezed,
    Object? status = null,
    Object? type = null,
    Object? priority = null,
    Object? validHours = null,
    Object? maxDriftDistance = null,
    Object? driftedDistance = null,
    Object? viewCount = null,
    Object? likeCount = null,
    Object? favoriteCount = null,
    Object? replyCount = null,
    Object? isAnonymous = null,
    Object? isPrivate = null,
    Object? isPinned = null,
    Object? isReported = null,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? expiredAt = freezed,
    Object? pickedAt = freezed,
    Object? picker = freezed,
    Object? driftTrack = null,
    Object? extra = freezed,
  }) {
    return _then(_$BottleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as User,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as BottleContentType,
      mediaList: null == mediaList
          ? _value._mediaList
          : mediaList // ignore: cast_nullable_to_non_nullable
              as List<BottleMedia>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sendLocation: freezed == sendLocation
          ? _value.sendLocation
          : sendLocation // ignore: cast_nullable_to_non_nullable
              as BottleLocation?,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as BottleLocation?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BottleStatus,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BottleType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as BottlePriority,
      validHours: null == validHours
          ? _value.validHours
          : validHours // ignore: cast_nullable_to_non_nullable
              as int,
      maxDriftDistance: null == maxDriftDistance
          ? _value.maxDriftDistance
          : maxDriftDistance // ignore: cast_nullable_to_non_nullable
              as double,
      driftedDistance: null == driftedDistance
          ? _value.driftedDistance
          : driftedDistance // ignore: cast_nullable_to_non_nullable
              as double,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteCount: null == favoriteCount
          ? _value.favoriteCount
          : favoriteCount // ignore: cast_nullable_to_non_nullable
              as int,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiredAt: freezed == expiredAt
          ? _value.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedAt: freezed == pickedAt
          ? _value.pickedAt
          : pickedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      picker: freezed == picker
          ? _value.picker
          : picker // ignore: cast_nullable_to_non_nullable
              as User?,
      driftTrack: null == driftTrack
          ? _value._driftTrack
          : driftTrack // ignore: cast_nullable_to_non_nullable
              as List<BottleTrack>,
      extra: freezed == extra
          ? _value._extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$BottleImpl extends _Bottle {
  const _$BottleImpl(
      {required this.id,
      required this.sender,
      required this.content,
      this.contentType = BottleContentType.text,
      final List<BottleMedia> mediaList = const [],
      final List<String> tags = const [],
      this.sendLocation,
      this.currentLocation,
      this.status = BottleStatus.floating,
      this.type = BottleType.normal,
      this.priority = BottlePriority.normal,
      this.validHours = 72,
      this.maxDriftDistance = 100.0,
      this.driftedDistance = 0.0,
      this.viewCount = 0,
      this.likeCount = 0,
      this.favoriteCount = 0,
      this.replyCount = 0,
      this.isAnonymous = false,
      this.isPrivate = false,
      this.isPinned = false,
      this.isReported = false,
      this.isDeleted = false,
      required this.createdAt,
      required this.updatedAt,
      this.expiredAt,
      this.pickedAt,
      this.picker,
      final List<BottleTrack> driftTrack = const [],
      final Map<String, dynamic>? extra})
      : _mediaList = mediaList,
        _tags = tags,
        _driftTrack = driftTrack,
        _extra = extra,
        super._();

  /// 漂流瓶ID
  @override
  final String id;

  /// 发送者信息
  @override
  final User sender;

  /// 内容
  @override
  final String content;

  /// 内容类型
  @override
  @JsonKey()
  final BottleContentType contentType;

  /// 媒体文件列表 (图片、音频等)
  final List<BottleMedia> _mediaList;

  /// 媒体文件列表 (图片、音频等)
  @override
  @JsonKey()
  List<BottleMedia> get mediaList {
    if (_mediaList is EqualUnmodifiableListView) return _mediaList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaList);
  }

  /// 标签列表
  final List<String> _tags;

  /// 标签列表
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 发送位置
  @override
  final BottleLocation? sendLocation;

  /// 当前位置 (漂流过程中的位置)
  @override
  final BottleLocation? currentLocation;

  /// 漂流瓶状态
  @override
  @JsonKey()
  final BottleStatus status;

  /// 漂流瓶类型
  @override
  @JsonKey()
  final BottleType type;

  /// 优先级 (影响被捡到的概率)
  @override
  @JsonKey()
  final BottlePriority priority;

  /// 有效期 (小时)
  @override
  @JsonKey()
  final int validHours;

  /// 最大漂流距离 (公里)
  @override
  @JsonKey()
  final double maxDriftDistance;

  /// 已漂流距离 (公里)
  @override
  @JsonKey()
  final double driftedDistance;

  /// 被查看次数
  @override
  @JsonKey()
  final int viewCount;

  /// 被点赞次数
  @override
  @JsonKey()
  final int likeCount;

  /// 被收藏次数
  @override
  @JsonKey()
  final int favoriteCount;

  /// 回复数量
  @override
  @JsonKey()
  final int replyCount;

  /// 是否匿名
  @override
  @JsonKey()
  final bool isAnonymous;

  /// 是否私密 (只有特定用户可见)
  @override
  @JsonKey()
  final bool isPrivate;

  /// 是否置顶
  @override
  @JsonKey()
  final bool isPinned;

  /// 是否被举报
  @override
  @JsonKey()
  final bool isReported;

  /// 是否被删除
  @override
  @JsonKey()
  final bool isDeleted;

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 更新时间
  @override
  final DateTime updatedAt;

  /// 过期时间
  @override
  final DateTime? expiredAt;

  /// 被捡到时间
  @override
  final DateTime? pickedAt;

  /// 捡到者信息
  @override
  final User? picker;

  /// 漂流轨迹
  final List<BottleTrack> _driftTrack;

  /// 漂流轨迹
  @override
  @JsonKey()
  List<BottleTrack> get driftTrack {
    if (_driftTrack is EqualUnmodifiableListView) return _driftTrack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_driftTrack);
  }

  /// 扩展数据
  final Map<String, dynamic>? _extra;

  /// 扩展数据
  @override
  Map<String, dynamic>? get extra {
    final value = _extra;
    if (value == null) return null;
    if (_extra is EqualUnmodifiableMapView) return _extra;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Bottle(id: $id, sender: $sender, content: $content, contentType: $contentType, mediaList: $mediaList, tags: $tags, sendLocation: $sendLocation, currentLocation: $currentLocation, status: $status, type: $type, priority: $priority, validHours: $validHours, maxDriftDistance: $maxDriftDistance, driftedDistance: $driftedDistance, viewCount: $viewCount, likeCount: $likeCount, favoriteCount: $favoriteCount, replyCount: $replyCount, isAnonymous: $isAnonymous, isPrivate: $isPrivate, isPinned: $isPinned, isReported: $isReported, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, expiredAt: $expiredAt, pickedAt: $pickedAt, picker: $picker, driftTrack: $driftTrack, extra: $extra)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            const DeepCollectionEquality()
                .equals(other._mediaList, _mediaList) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.sendLocation, sendLocation) ||
                other.sendLocation == sendLocation) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.validHours, validHours) ||
                other.validHours == validHours) &&
            (identical(other.maxDriftDistance, maxDriftDistance) ||
                other.maxDriftDistance == maxDriftDistance) &&
            (identical(other.driftedDistance, driftedDistance) ||
                other.driftedDistance == driftedDistance) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.favoriteCount, favoriteCount) ||
                other.favoriteCount == favoriteCount) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isReported, isReported) ||
                other.isReported == isReported) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.expiredAt, expiredAt) ||
                other.expiredAt == expiredAt) &&
            (identical(other.pickedAt, pickedAt) ||
                other.pickedAt == pickedAt) &&
            (identical(other.picker, picker) || other.picker == picker) &&
            const DeepCollectionEquality()
                .equals(other._driftTrack, _driftTrack) &&
            const DeepCollectionEquality().equals(other._extra, _extra));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        sender,
        content,
        contentType,
        const DeepCollectionEquality().hash(_mediaList),
        const DeepCollectionEquality().hash(_tags),
        sendLocation,
        currentLocation,
        status,
        type,
        priority,
        validHours,
        maxDriftDistance,
        driftedDistance,
        viewCount,
        likeCount,
        favoriteCount,
        replyCount,
        isAnonymous,
        isPrivate,
        isPinned,
        isReported,
        isDeleted,
        createdAt,
        updatedAt,
        expiredAt,
        pickedAt,
        picker,
        const DeepCollectionEquality().hash(_driftTrack),
        const DeepCollectionEquality().hash(_extra)
      ]);

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BottleImplCopyWith<_$BottleImpl> get copyWith =>
      __$$BottleImplCopyWithImpl<_$BottleImpl>(this, _$identity);
}

abstract class _Bottle extends Bottle {
  const factory _Bottle(
      {required final String id,
      required final User sender,
      required final String content,
      final BottleContentType contentType,
      final List<BottleMedia> mediaList,
      final List<String> tags,
      final BottleLocation? sendLocation,
      final BottleLocation? currentLocation,
      final BottleStatus status,
      final BottleType type,
      final BottlePriority priority,
      final int validHours,
      final double maxDriftDistance,
      final double driftedDistance,
      final int viewCount,
      final int likeCount,
      final int favoriteCount,
      final int replyCount,
      final bool isAnonymous,
      final bool isPrivate,
      final bool isPinned,
      final bool isReported,
      final bool isDeleted,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? expiredAt,
      final DateTime? pickedAt,
      final User? picker,
      final List<BottleTrack> driftTrack,
      final Map<String, dynamic>? extra}) = _$BottleImpl;
  const _Bottle._() : super._();

  /// 漂流瓶ID
  @override
  String get id;

  /// 发送者信息
  @override
  User get sender;

  /// 内容
  @override
  String get content;

  /// 内容类型
  @override
  BottleContentType get contentType;

  /// 媒体文件列表 (图片、音频等)
  @override
  List<BottleMedia> get mediaList;

  /// 标签列表
  @override
  List<String> get tags;

  /// 发送位置
  @override
  BottleLocation? get sendLocation;

  /// 当前位置 (漂流过程中的位置)
  @override
  BottleLocation? get currentLocation;

  /// 漂流瓶状态
  @override
  BottleStatus get status;

  /// 漂流瓶类型
  @override
  BottleType get type;

  /// 优先级 (影响被捡到的概率)
  @override
  BottlePriority get priority;

  /// 有效期 (小时)
  @override
  int get validHours;

  /// 最大漂流距离 (公里)
  @override
  double get maxDriftDistance;

  /// 已漂流距离 (公里)
  @override
  double get driftedDistance;

  /// 被查看次数
  @override
  int get viewCount;

  /// 被点赞次数
  @override
  int get likeCount;

  /// 被收藏次数
  @override
  int get favoriteCount;

  /// 回复数量
  @override
  int get replyCount;

  /// 是否匿名
  @override
  bool get isAnonymous;

  /// 是否私密 (只有特定用户可见)
  @override
  bool get isPrivate;

  /// 是否置顶
  @override
  bool get isPinned;

  /// 是否被举报
  @override
  bool get isReported;

  /// 是否被删除
  @override
  bool get isDeleted;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 更新时间
  @override
  DateTime get updatedAt;

  /// 过期时间
  @override
  DateTime? get expiredAt;

  /// 被捡到时间
  @override
  DateTime? get pickedAt;

  /// 捡到者信息
  @override
  User? get picker;

  /// 漂流轨迹
  @override
  List<BottleTrack> get driftTrack;

  /// 扩展数据
  @override
  Map<String, dynamic>? get extra;

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BottleImplCopyWith<_$BottleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BottleMedia {
  /// 媒体ID
  String get id => throw _privateConstructorUsedError;

  /// 媒体类型
  MediaType get type => throw _privateConstructorUsedError;

  /// 文件URL
  String get url => throw _privateConstructorUsedError;

  /// 缩略图URL
  String? get thumbnailUrl => throw _privateConstructorUsedError;

  /// 文件大小 (字节)
  int? get fileSize => throw _privateConstructorUsedError;

  /// 持续时间 (秒，用于音频/视频)
  int? get duration => throw _privateConstructorUsedError;

  /// 宽度 (像素，用于图片/视频)
  int? get width => throw _privateConstructorUsedError;

  /// 高度 (像素，用于图片/视频)
  int? get height => throw _privateConstructorUsedError;

  /// 文件名
  String? get fileName => throw _privateConstructorUsedError;

  /// MIME类型
  String? get mimeType => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of BottleMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BottleMediaCopyWith<BottleMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottleMediaCopyWith<$Res> {
  factory $BottleMediaCopyWith(
          BottleMedia value, $Res Function(BottleMedia) then) =
      _$BottleMediaCopyWithImpl<$Res, BottleMedia>;
  @useResult
  $Res call(
      {String id,
      MediaType type,
      String url,
      String? thumbnailUrl,
      int? fileSize,
      int? duration,
      int? width,
      int? height,
      String? fileName,
      String? mimeType,
      DateTime createdAt});
}

/// @nodoc
class _$BottleMediaCopyWithImpl<$Res, $Val extends BottleMedia>
    implements $BottleMediaCopyWith<$Res> {
  _$BottleMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BottleMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? fileName = freezed,
    Object? mimeType = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BottleMediaImplCopyWith<$Res>
    implements $BottleMediaCopyWith<$Res> {
  factory _$$BottleMediaImplCopyWith(
          _$BottleMediaImpl value, $Res Function(_$BottleMediaImpl) then) =
      __$$BottleMediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MediaType type,
      String url,
      String? thumbnailUrl,
      int? fileSize,
      int? duration,
      int? width,
      int? height,
      String? fileName,
      String? mimeType,
      DateTime createdAt});
}

/// @nodoc
class __$$BottleMediaImplCopyWithImpl<$Res>
    extends _$BottleMediaCopyWithImpl<$Res, _$BottleMediaImpl>
    implements _$$BottleMediaImplCopyWith<$Res> {
  __$$BottleMediaImplCopyWithImpl(
      _$BottleMediaImpl _value, $Res Function(_$BottleMediaImpl) _then)
      : super(_value, _then);

  /// Create a copy of BottleMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? fileName = freezed,
    Object? mimeType = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$BottleMediaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BottleMediaImpl implements _BottleMedia {
  const _$BottleMediaImpl(
      {required this.id,
      required this.type,
      required this.url,
      this.thumbnailUrl,
      this.fileSize,
      this.duration,
      this.width,
      this.height,
      this.fileName,
      this.mimeType,
      required this.createdAt});

  /// 媒体ID
  @override
  final String id;

  /// 媒体类型
  @override
  final MediaType type;

  /// 文件URL
  @override
  final String url;

  /// 缩略图URL
  @override
  final String? thumbnailUrl;

  /// 文件大小 (字节)
  @override
  final int? fileSize;

  /// 持续时间 (秒，用于音频/视频)
  @override
  final int? duration;

  /// 宽度 (像素，用于图片/视频)
  @override
  final int? width;

  /// 高度 (像素，用于图片/视频)
  @override
  final int? height;

  /// 文件名
  @override
  final String? fileName;

  /// MIME类型
  @override
  final String? mimeType;

  /// 创建时间
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BottleMedia(id: $id, type: $type, url: $url, thumbnailUrl: $thumbnailUrl, fileSize: $fileSize, duration: $duration, width: $width, height: $height, fileName: $fileName, mimeType: $mimeType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottleMediaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, type, url, thumbnailUrl,
      fileSize, duration, width, height, fileName, mimeType, createdAt);

  /// Create a copy of BottleMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BottleMediaImplCopyWith<_$BottleMediaImpl> get copyWith =>
      __$$BottleMediaImplCopyWithImpl<_$BottleMediaImpl>(this, _$identity);
}

abstract class _BottleMedia implements BottleMedia {
  const factory _BottleMedia(
      {required final String id,
      required final MediaType type,
      required final String url,
      final String? thumbnailUrl,
      final int? fileSize,
      final int? duration,
      final int? width,
      final int? height,
      final String? fileName,
      final String? mimeType,
      required final DateTime createdAt}) = _$BottleMediaImpl;

  /// 媒体ID
  @override
  String get id;

  /// 媒体类型
  @override
  MediaType get type;

  /// 文件URL
  @override
  String get url;

  /// 缩略图URL
  @override
  String? get thumbnailUrl;

  /// 文件大小 (字节)
  @override
  int? get fileSize;

  /// 持续时间 (秒，用于音频/视频)
  @override
  int? get duration;

  /// 宽度 (像素，用于图片/视频)
  @override
  int? get width;

  /// 高度 (像素，用于图片/视频)
  @override
  int? get height;

  /// 文件名
  @override
  String? get fileName;

  /// MIME类型
  @override
  String? get mimeType;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// Create a copy of BottleMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BottleMediaImplCopyWith<_$BottleMediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BottleLocation {
  /// 纬度
  double get latitude => throw _privateConstructorUsedError;

  /// 经度
  double get longitude => throw _privateConstructorUsedError;

  /// 地址描述
  String? get address => throw _privateConstructorUsedError;

  /// 城市
  String? get city => throw _privateConstructorUsedError;

  /// 省份/州
  String? get province => throw _privateConstructorUsedError;

  /// 国家
  String? get country => throw _privateConstructorUsedError;

  /// 位置精度 (米)
  double? get accuracy => throw _privateConstructorUsedError;

  /// 记录时间
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Create a copy of BottleLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BottleLocationCopyWith<BottleLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottleLocationCopyWith<$Res> {
  factory $BottleLocationCopyWith(
          BottleLocation value, $Res Function(BottleLocation) then) =
      _$BottleLocationCopyWithImpl<$Res, BottleLocation>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      String? address,
      String? city,
      String? province,
      String? country,
      double? accuracy,
      DateTime timestamp});
}

/// @nodoc
class _$BottleLocationCopyWithImpl<$Res, $Val extends BottleLocation>
    implements $BottleLocationCopyWith<$Res> {
  _$BottleLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BottleLocation
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
    Object? accuracy = freezed,
    Object? timestamp = null,
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
      accuracy: freezed == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BottleLocationImplCopyWith<$Res>
    implements $BottleLocationCopyWith<$Res> {
  factory _$$BottleLocationImplCopyWith(_$BottleLocationImpl value,
          $Res Function(_$BottleLocationImpl) then) =
      __$$BottleLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      String? address,
      String? city,
      String? province,
      String? country,
      double? accuracy,
      DateTime timestamp});
}

/// @nodoc
class __$$BottleLocationImplCopyWithImpl<$Res>
    extends _$BottleLocationCopyWithImpl<$Res, _$BottleLocationImpl>
    implements _$$BottleLocationImplCopyWith<$Res> {
  __$$BottleLocationImplCopyWithImpl(
      _$BottleLocationImpl _value, $Res Function(_$BottleLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of BottleLocation
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
    Object? accuracy = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$BottleLocationImpl(
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
      accuracy: freezed == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BottleLocationImpl implements _BottleLocation {
  const _$BottleLocationImpl(
      {required this.latitude,
      required this.longitude,
      this.address,
      this.city,
      this.province,
      this.country,
      this.accuracy,
      required this.timestamp});

  /// 纬度
  @override
  final double latitude;

  /// 经度
  @override
  final double longitude;

  /// 地址描述
  @override
  final String? address;

  /// 城市
  @override
  final String? city;

  /// 省份/州
  @override
  final String? province;

  /// 国家
  @override
  final String? country;

  /// 位置精度 (米)
  @override
  final double? accuracy;

  /// 记录时间
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'BottleLocation(latitude: $latitude, longitude: $longitude, address: $address, city: $city, province: $province, country: $country, accuracy: $accuracy, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottleLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude, address,
      city, province, country, accuracy, timestamp);

  /// Create a copy of BottleLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BottleLocationImplCopyWith<_$BottleLocationImpl> get copyWith =>
      __$$BottleLocationImplCopyWithImpl<_$BottleLocationImpl>(
          this, _$identity);
}

abstract class _BottleLocation implements BottleLocation {
  const factory _BottleLocation(
      {required final double latitude,
      required final double longitude,
      final String? address,
      final String? city,
      final String? province,
      final String? country,
      final double? accuracy,
      required final DateTime timestamp}) = _$BottleLocationImpl;

  /// 纬度
  @override
  double get latitude;

  /// 经度
  @override
  double get longitude;

  /// 地址描述
  @override
  String? get address;

  /// 城市
  @override
  String? get city;

  /// 省份/州
  @override
  String? get province;

  /// 国家
  @override
  String? get country;

  /// 位置精度 (米)
  @override
  double? get accuracy;

  /// 记录时间
  @override
  DateTime get timestamp;

  /// Create a copy of BottleLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BottleLocationImplCopyWith<_$BottleLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BottleTrack {
  /// 轨迹ID
  String get id => throw _privateConstructorUsedError;

  /// 位置信息
  BottleLocation get location => throw _privateConstructorUsedError;

  /// 轨迹类型
  TrackType get type => throw _privateConstructorUsedError;

  /// 描述
  String? get description => throw _privateConstructorUsedError;

  /// 记录时间
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Create a copy of BottleTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BottleTrackCopyWith<BottleTrack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottleTrackCopyWith<$Res> {
  factory $BottleTrackCopyWith(
          BottleTrack value, $Res Function(BottleTrack) then) =
      _$BottleTrackCopyWithImpl<$Res, BottleTrack>;
  @useResult
  $Res call(
      {String id,
      BottleLocation location,
      TrackType type,
      String? description,
      DateTime timestamp});

  $BottleLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$BottleTrackCopyWithImpl<$Res, $Val extends BottleTrack>
    implements $BottleTrackCopyWith<$Res> {
  _$BottleTrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BottleTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? location = null,
    Object? type = null,
    Object? description = freezed,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as BottleLocation,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TrackType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of BottleTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BottleLocationCopyWith<$Res> get location {
    return $BottleLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BottleTrackImplCopyWith<$Res>
    implements $BottleTrackCopyWith<$Res> {
  factory _$$BottleTrackImplCopyWith(
          _$BottleTrackImpl value, $Res Function(_$BottleTrackImpl) then) =
      __$$BottleTrackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      BottleLocation location,
      TrackType type,
      String? description,
      DateTime timestamp});

  @override
  $BottleLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$BottleTrackImplCopyWithImpl<$Res>
    extends _$BottleTrackCopyWithImpl<$Res, _$BottleTrackImpl>
    implements _$$BottleTrackImplCopyWith<$Res> {
  __$$BottleTrackImplCopyWithImpl(
      _$BottleTrackImpl _value, $Res Function(_$BottleTrackImpl) _then)
      : super(_value, _then);

  /// Create a copy of BottleTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? location = null,
    Object? type = null,
    Object? description = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$BottleTrackImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as BottleLocation,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TrackType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BottleTrackImpl implements _BottleTrack {
  const _$BottleTrackImpl(
      {required this.id,
      required this.location,
      required this.type,
      this.description,
      required this.timestamp});

  /// 轨迹ID
  @override
  final String id;

  /// 位置信息
  @override
  final BottleLocation location;

  /// 轨迹类型
  @override
  final TrackType type;

  /// 描述
  @override
  final String? description;

  /// 记录时间
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'BottleTrack(id: $id, location: $location, type: $type, description: $description, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottleTrackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, location, type, description, timestamp);

  /// Create a copy of BottleTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BottleTrackImplCopyWith<_$BottleTrackImpl> get copyWith =>
      __$$BottleTrackImplCopyWithImpl<_$BottleTrackImpl>(this, _$identity);
}

abstract class _BottleTrack implements BottleTrack {
  const factory _BottleTrack(
      {required final String id,
      required final BottleLocation location,
      required final TrackType type,
      final String? description,
      required final DateTime timestamp}) = _$BottleTrackImpl;

  /// 轨迹ID
  @override
  String get id;

  /// 位置信息
  @override
  BottleLocation get location;

  /// 轨迹类型
  @override
  TrackType get type;

  /// 描述
  @override
  String? get description;

  /// 记录时间
  @override
  DateTime get timestamp;

  /// Create a copy of BottleTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BottleTrackImplCopyWith<_$BottleTrackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BottleReply {
  /// 回复ID
  String get id => throw _privateConstructorUsedError;

  /// 漂流瓶ID
  String get bottleId => throw _privateConstructorUsedError;

  /// 发送者信息
  User get sender => throw _privateConstructorUsedError;

  /// 回复内容
  String get content => throw _privateConstructorUsedError;

  /// 内容类型
  BottleContentType get contentType => throw _privateConstructorUsedError;

  /// 媒体文件列表
  List<BottleMedia> get mediaList => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 是否已删除
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Create a copy of BottleReply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BottleReplyCopyWith<BottleReply> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottleReplyCopyWith<$Res> {
  factory $BottleReplyCopyWith(
          BottleReply value, $Res Function(BottleReply) then) =
      _$BottleReplyCopyWithImpl<$Res, BottleReply>;
  @useResult
  $Res call(
      {String id,
      String bottleId,
      User sender,
      String content,
      BottleContentType contentType,
      List<BottleMedia> mediaList,
      DateTime createdAt,
      bool isDeleted});
}

/// @nodoc
class _$BottleReplyCopyWithImpl<$Res, $Val extends BottleReply>
    implements $BottleReplyCopyWith<$Res> {
  _$BottleReplyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BottleReply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bottleId = null,
    Object? sender = null,
    Object? content = null,
    Object? contentType = null,
    Object? mediaList = null,
    Object? createdAt = null,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bottleId: null == bottleId
          ? _value.bottleId
          : bottleId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as User,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as BottleContentType,
      mediaList: null == mediaList
          ? _value.mediaList
          : mediaList // ignore: cast_nullable_to_non_nullable
              as List<BottleMedia>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BottleReplyImplCopyWith<$Res>
    implements $BottleReplyCopyWith<$Res> {
  factory _$$BottleReplyImplCopyWith(
          _$BottleReplyImpl value, $Res Function(_$BottleReplyImpl) then) =
      __$$BottleReplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bottleId,
      User sender,
      String content,
      BottleContentType contentType,
      List<BottleMedia> mediaList,
      DateTime createdAt,
      bool isDeleted});
}

/// @nodoc
class __$$BottleReplyImplCopyWithImpl<$Res>
    extends _$BottleReplyCopyWithImpl<$Res, _$BottleReplyImpl>
    implements _$$BottleReplyImplCopyWith<$Res> {
  __$$BottleReplyImplCopyWithImpl(
      _$BottleReplyImpl _value, $Res Function(_$BottleReplyImpl) _then)
      : super(_value, _then);

  /// Create a copy of BottleReply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bottleId = null,
    Object? sender = null,
    Object? content = null,
    Object? contentType = null,
    Object? mediaList = null,
    Object? createdAt = null,
    Object? isDeleted = null,
  }) {
    return _then(_$BottleReplyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bottleId: null == bottleId
          ? _value.bottleId
          : bottleId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as User,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as BottleContentType,
      mediaList: null == mediaList
          ? _value._mediaList
          : mediaList // ignore: cast_nullable_to_non_nullable
              as List<BottleMedia>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BottleReplyImpl implements _BottleReply {
  const _$BottleReplyImpl(
      {required this.id,
      required this.bottleId,
      required this.sender,
      required this.content,
      this.contentType = BottleContentType.text,
      final List<BottleMedia> mediaList = const [],
      required this.createdAt,
      this.isDeleted = false})
      : _mediaList = mediaList;

  /// 回复ID
  @override
  final String id;

  /// 漂流瓶ID
  @override
  final String bottleId;

  /// 发送者信息
  @override
  final User sender;

  /// 回复内容
  @override
  final String content;

  /// 内容类型
  @override
  @JsonKey()
  final BottleContentType contentType;

  /// 媒体文件列表
  final List<BottleMedia> _mediaList;

  /// 媒体文件列表
  @override
  @JsonKey()
  List<BottleMedia> get mediaList {
    if (_mediaList is EqualUnmodifiableListView) return _mediaList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaList);
  }

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 是否已删除
  @override
  @JsonKey()
  final bool isDeleted;

  @override
  String toString() {
    return 'BottleReply(id: $id, bottleId: $bottleId, sender: $sender, content: $content, contentType: $contentType, mediaList: $mediaList, createdAt: $createdAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottleReplyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bottleId, bottleId) ||
                other.bottleId == bottleId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            const DeepCollectionEquality()
                .equals(other._mediaList, _mediaList) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bottleId,
      sender,
      content,
      contentType,
      const DeepCollectionEquality().hash(_mediaList),
      createdAt,
      isDeleted);

  /// Create a copy of BottleReply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BottleReplyImplCopyWith<_$BottleReplyImpl> get copyWith =>
      __$$BottleReplyImplCopyWithImpl<_$BottleReplyImpl>(this, _$identity);
}

abstract class _BottleReply implements BottleReply {
  const factory _BottleReply(
      {required final String id,
      required final String bottleId,
      required final User sender,
      required final String content,
      final BottleContentType contentType,
      final List<BottleMedia> mediaList,
      required final DateTime createdAt,
      final bool isDeleted}) = _$BottleReplyImpl;

  /// 回复ID
  @override
  String get id;

  /// 漂流瓶ID
  @override
  String get bottleId;

  /// 发送者信息
  @override
  User get sender;

  /// 回复内容
  @override
  String get content;

  /// 内容类型
  @override
  BottleContentType get contentType;

  /// 媒体文件列表
  @override
  List<BottleMedia> get mediaList;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 是否已删除
  @override
  bool get isDeleted;

  /// Create a copy of BottleReply
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BottleReplyImplCopyWith<_$BottleReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
