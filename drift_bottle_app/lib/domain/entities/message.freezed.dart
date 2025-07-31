// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Message {
  /// 消息ID
  String get id => throw _privateConstructorUsedError;

  /// 会话ID
  String get conversationId => throw _privateConstructorUsedError;

  /// 发送者ID
  String get senderId => throw _privateConstructorUsedError;

  /// 接收者ID
  String? get receiverId => throw _privateConstructorUsedError;

  /// 消息类型
  MessageType get type => throw _privateConstructorUsedError;

  /// 消息内容
  String get content => throw _privateConstructorUsedError;

  /// 媒体附件
  MessageMedia? get media => throw _privateConstructorUsedError;

  /// 消息状态
  MessageStatus get status => throw _privateConstructorUsedError;

  /// 消息方向
  MessageDirection get direction => throw _privateConstructorUsedError;

  /// 是否已读
  bool get isRead => throw _privateConstructorUsedError;

  /// 是否已删除
  bool get isDeleted => throw _privateConstructorUsedError;

  /// 是否被撤回
  bool get isRecalled => throw _privateConstructorUsedError;

  /// 是否置顶
  bool get isPinned => throw _privateConstructorUsedError;

  /// 回复的消息ID
  String? get replyToMessageId => throw _privateConstructorUsedError;

  /// 回复的消息内容预览
  String? get replyToContent => throw _privateConstructorUsedError;

  /// 转发的消息ID
  String? get forwardFromMessageId => throw _privateConstructorUsedError;

  /// 提及的用户ID列表
  List<String> get mentionedUserIds => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 发送时间
  DateTime? get sentAt => throw _privateConstructorUsedError;

  /// 送达时间
  DateTime? get deliveredAt => throw _privateConstructorUsedError;

  /// 已读时间
  DateTime? get readAt => throw _privateConstructorUsedError;

  /// 撤回时间
  DateTime? get recalledAt => throw _privateConstructorUsedError;

  /// 本地消息ID (用于离线消息)
  String? get localId => throw _privateConstructorUsedError;

  /// 重试次数
  int get retryCount => throw _privateConstructorUsedError;

  /// 扩展数据
  Map<String, dynamic>? get extra => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String? receiverId,
      MessageType type,
      String content,
      MessageMedia? media,
      MessageStatus status,
      MessageDirection direction,
      bool isRead,
      bool isDeleted,
      bool isRecalled,
      bool isPinned,
      String? replyToMessageId,
      String? replyToContent,
      String? forwardFromMessageId,
      List<String> mentionedUserIds,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? sentAt,
      DateTime? deliveredAt,
      DateTime? readAt,
      DateTime? recalledAt,
      String? localId,
      int retryCount,
      Map<String, dynamic>? extra});

  $MessageMediaCopyWith<$Res>? get media;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? receiverId = freezed,
    Object? type = null,
    Object? content = null,
    Object? media = freezed,
    Object? status = null,
    Object? direction = null,
    Object? isRead = null,
    Object? isDeleted = null,
    Object? isRecalled = null,
    Object? isPinned = null,
    Object? replyToMessageId = freezed,
    Object? replyToContent = freezed,
    Object? forwardFromMessageId = freezed,
    Object? mentionedUserIds = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sentAt = freezed,
    Object? deliveredAt = freezed,
    Object? readAt = freezed,
    Object? recalledAt = freezed,
    Object? localId = freezed,
    Object? retryCount = null,
    Object? extra = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: freezed == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as MessageMedia?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as MessageDirection,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isRecalled: null == isRecalled
          ? _value.isRecalled
          : isRecalled // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      replyToMessageId: freezed == replyToMessageId
          ? _value.replyToMessageId
          : replyToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToContent: freezed == replyToContent
          ? _value.replyToContent
          : replyToContent // ignore: cast_nullable_to_non_nullable
              as String?,
      forwardFromMessageId: freezed == forwardFromMessageId
          ? _value.forwardFromMessageId
          : forwardFromMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      mentionedUserIds: null == mentionedUserIds
          ? _value.mentionedUserIds
          : mentionedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recalledAt: freezed == recalledAt
          ? _value.recalledAt
          : recalledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      localId: freezed == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String?,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageMediaCopyWith<$Res>? get media {
    if (_value.media == null) {
      return null;
    }

    return $MessageMediaCopyWith<$Res>(_value.media!, (value) {
      return _then(_value.copyWith(media: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String? receiverId,
      MessageType type,
      String content,
      MessageMedia? media,
      MessageStatus status,
      MessageDirection direction,
      bool isRead,
      bool isDeleted,
      bool isRecalled,
      bool isPinned,
      String? replyToMessageId,
      String? replyToContent,
      String? forwardFromMessageId,
      List<String> mentionedUserIds,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? sentAt,
      DateTime? deliveredAt,
      DateTime? readAt,
      DateTime? recalledAt,
      String? localId,
      int retryCount,
      Map<String, dynamic>? extra});

  @override
  $MessageMediaCopyWith<$Res>? get media;
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? receiverId = freezed,
    Object? type = null,
    Object? content = null,
    Object? media = freezed,
    Object? status = null,
    Object? direction = null,
    Object? isRead = null,
    Object? isDeleted = null,
    Object? isRecalled = null,
    Object? isPinned = null,
    Object? replyToMessageId = freezed,
    Object? replyToContent = freezed,
    Object? forwardFromMessageId = freezed,
    Object? mentionedUserIds = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sentAt = freezed,
    Object? deliveredAt = freezed,
    Object? readAt = freezed,
    Object? recalledAt = freezed,
    Object? localId = freezed,
    Object? retryCount = null,
    Object? extra = freezed,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: freezed == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as MessageMedia?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as MessageDirection,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isRecalled: null == isRecalled
          ? _value.isRecalled
          : isRecalled // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      replyToMessageId: freezed == replyToMessageId
          ? _value.replyToMessageId
          : replyToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToContent: freezed == replyToContent
          ? _value.replyToContent
          : replyToContent // ignore: cast_nullable_to_non_nullable
              as String?,
      forwardFromMessageId: freezed == forwardFromMessageId
          ? _value.forwardFromMessageId
          : forwardFromMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      mentionedUserIds: null == mentionedUserIds
          ? _value._mentionedUserIds
          : mentionedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recalledAt: freezed == recalledAt
          ? _value.recalledAt
          : recalledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      localId: freezed == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String?,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      extra: freezed == extra
          ? _value._extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$MessageImpl extends _Message {
  const _$MessageImpl(
      {required this.id,
      required this.conversationId,
      required this.senderId,
      this.receiverId,
      this.type = MessageType.text,
      required this.content,
      this.media,
      this.status = MessageStatus.sending,
      this.direction = MessageDirection.sent,
      this.isRead = false,
      this.isDeleted = false,
      this.isRecalled = false,
      this.isPinned = false,
      this.replyToMessageId,
      this.replyToContent,
      this.forwardFromMessageId,
      final List<String> mentionedUserIds = const [],
      required this.createdAt,
      required this.updatedAt,
      this.sentAt,
      this.deliveredAt,
      this.readAt,
      this.recalledAt,
      this.localId,
      this.retryCount = 0,
      final Map<String, dynamic>? extra})
      : _mentionedUserIds = mentionedUserIds,
        _extra = extra,
        super._();

  /// 消息ID
  @override
  final String id;

  /// 会话ID
  @override
  final String conversationId;

  /// 发送者ID
  @override
  final String senderId;

  /// 接收者ID
  @override
  final String? receiverId;

  /// 消息类型
  @override
  @JsonKey()
  final MessageType type;

  /// 消息内容
  @override
  final String content;

  /// 媒体附件
  @override
  final MessageMedia? media;

  /// 消息状态
  @override
  @JsonKey()
  final MessageStatus status;

  /// 消息方向
  @override
  @JsonKey()
  final MessageDirection direction;

  /// 是否已读
  @override
  @JsonKey()
  final bool isRead;

  /// 是否已删除
  @override
  @JsonKey()
  final bool isDeleted;

  /// 是否被撤回
  @override
  @JsonKey()
  final bool isRecalled;

  /// 是否置顶
  @override
  @JsonKey()
  final bool isPinned;

  /// 回复的消息ID
  @override
  final String? replyToMessageId;

  /// 回复的消息内容预览
  @override
  final String? replyToContent;

  /// 转发的消息ID
  @override
  final String? forwardFromMessageId;

  /// 提及的用户ID列表
  final List<String> _mentionedUserIds;

  /// 提及的用户ID列表
  @override
  @JsonKey()
  List<String> get mentionedUserIds {
    if (_mentionedUserIds is EqualUnmodifiableListView)
      return _mentionedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentionedUserIds);
  }

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 更新时间
  @override
  final DateTime updatedAt;

  /// 发送时间
  @override
  final DateTime? sentAt;

  /// 送达时间
  @override
  final DateTime? deliveredAt;

  /// 已读时间
  @override
  final DateTime? readAt;

  /// 撤回时间
  @override
  final DateTime? recalledAt;

  /// 本地消息ID (用于离线消息)
  @override
  final String? localId;

  /// 重试次数
  @override
  @JsonKey()
  final int retryCount;

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
    return 'Message(id: $id, conversationId: $conversationId, senderId: $senderId, receiverId: $receiverId, type: $type, content: $content, media: $media, status: $status, direction: $direction, isRead: $isRead, isDeleted: $isDeleted, isRecalled: $isRecalled, isPinned: $isPinned, replyToMessageId: $replyToMessageId, replyToContent: $replyToContent, forwardFromMessageId: $forwardFromMessageId, mentionedUserIds: $mentionedUserIds, createdAt: $createdAt, updatedAt: $updatedAt, sentAt: $sentAt, deliveredAt: $deliveredAt, readAt: $readAt, recalledAt: $recalledAt, localId: $localId, retryCount: $retryCount, extra: $extra)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.media, media) || other.media == media) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.isRecalled, isRecalled) ||
                other.isRecalled == isRecalled) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.replyToMessageId, replyToMessageId) ||
                other.replyToMessageId == replyToMessageId) &&
            (identical(other.replyToContent, replyToContent) ||
                other.replyToContent == replyToContent) &&
            (identical(other.forwardFromMessageId, forwardFromMessageId) ||
                other.forwardFromMessageId == forwardFromMessageId) &&
            const DeepCollectionEquality()
                .equals(other._mentionedUserIds, _mentionedUserIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.recalledAt, recalledAt) ||
                other.recalledAt == recalledAt) &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            const DeepCollectionEquality().equals(other._extra, _extra));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        conversationId,
        senderId,
        receiverId,
        type,
        content,
        media,
        status,
        direction,
        isRead,
        isDeleted,
        isRecalled,
        isPinned,
        replyToMessageId,
        replyToContent,
        forwardFromMessageId,
        const DeepCollectionEquality().hash(_mentionedUserIds),
        createdAt,
        updatedAt,
        sentAt,
        deliveredAt,
        readAt,
        recalledAt,
        localId,
        retryCount,
        const DeepCollectionEquality().hash(_extra)
      ]);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);
}

abstract class _Message extends Message {
  const factory _Message(
      {required final String id,
      required final String conversationId,
      required final String senderId,
      final String? receiverId,
      final MessageType type,
      required final String content,
      final MessageMedia? media,
      final MessageStatus status,
      final MessageDirection direction,
      final bool isRead,
      final bool isDeleted,
      final bool isRecalled,
      final bool isPinned,
      final String? replyToMessageId,
      final String? replyToContent,
      final String? forwardFromMessageId,
      final List<String> mentionedUserIds,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? sentAt,
      final DateTime? deliveredAt,
      final DateTime? readAt,
      final DateTime? recalledAt,
      final String? localId,
      final int retryCount,
      final Map<String, dynamic>? extra}) = _$MessageImpl;
  const _Message._() : super._();

  /// 消息ID
  @override
  String get id;

  /// 会话ID
  @override
  String get conversationId;

  /// 发送者ID
  @override
  String get senderId;

  /// 接收者ID
  @override
  String? get receiverId;

  /// 消息类型
  @override
  MessageType get type;

  /// 消息内容
  @override
  String get content;

  /// 媒体附件
  @override
  MessageMedia? get media;

  /// 消息状态
  @override
  MessageStatus get status;

  /// 消息方向
  @override
  MessageDirection get direction;

  /// 是否已读
  @override
  bool get isRead;

  /// 是否已删除
  @override
  bool get isDeleted;

  /// 是否被撤回
  @override
  bool get isRecalled;

  /// 是否置顶
  @override
  bool get isPinned;

  /// 回复的消息ID
  @override
  String? get replyToMessageId;

  /// 回复的消息内容预览
  @override
  String? get replyToContent;

  /// 转发的消息ID
  @override
  String? get forwardFromMessageId;

  /// 提及的用户ID列表
  @override
  List<String> get mentionedUserIds;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 更新时间
  @override
  DateTime get updatedAt;

  /// 发送时间
  @override
  DateTime? get sentAt;

  /// 送达时间
  @override
  DateTime? get deliveredAt;

  /// 已读时间
  @override
  DateTime? get readAt;

  /// 撤回时间
  @override
  DateTime? get recalledAt;

  /// 本地消息ID (用于离线消息)
  @override
  String? get localId;

  /// 重试次数
  @override
  int get retryCount;

  /// 扩展数据
  @override
  Map<String, dynamic>? get extra;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MessageMedia {
  /// 媒体ID
  String get id => throw _privateConstructorUsedError;

  /// 媒体类型
  MediaType get type => throw _privateConstructorUsedError;

  /// 文件URL
  String get url => throw _privateConstructorUsedError;

  /// 本地文件路径
  String? get localPath => throw _privateConstructorUsedError;

  /// 缩略图URL
  String? get thumbnailUrl => throw _privateConstructorUsedError;

  /// 本地缩略图路径
  String? get localThumbnailPath => throw _privateConstructorUsedError;

  /// 文件名
  String? get fileName => throw _privateConstructorUsedError;

  /// 文件大小 (字节)
  int? get fileSize => throw _privateConstructorUsedError;

  /// 持续时间 (秒，用于音频/视频)
  int? get duration => throw _privateConstructorUsedError;

  /// 宽度 (像素，用于图片/视频)
  int? get width => throw _privateConstructorUsedError;

  /// 高度 (像素，用于图片/视频)
  int? get height => throw _privateConstructorUsedError;

  /// MIME类型
  String? get mimeType => throw _privateConstructorUsedError;

  /// 下载状态
  DownloadStatus get downloadStatus => throw _privateConstructorUsedError;

  /// 下载进度 (0.0 - 1.0)
  double get downloadProgress => throw _privateConstructorUsedError;

  /// 上传状态
  UploadStatus get uploadStatus => throw _privateConstructorUsedError;

  /// 上传进度 (0.0 - 1.0)
  double get uploadProgress => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of MessageMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageMediaCopyWith<MessageMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageMediaCopyWith<$Res> {
  factory $MessageMediaCopyWith(
          MessageMedia value, $Res Function(MessageMedia) then) =
      _$MessageMediaCopyWithImpl<$Res, MessageMedia>;
  @useResult
  $Res call(
      {String id,
      MediaType type,
      String url,
      String? localPath,
      String? thumbnailUrl,
      String? localThumbnailPath,
      String? fileName,
      int? fileSize,
      int? duration,
      int? width,
      int? height,
      String? mimeType,
      DownloadStatus downloadStatus,
      double downloadProgress,
      UploadStatus uploadStatus,
      double uploadProgress,
      DateTime createdAt});
}

/// @nodoc
class _$MessageMediaCopyWithImpl<$Res, $Val extends MessageMedia>
    implements $MessageMediaCopyWith<$Res> {
  _$MessageMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? url = null,
    Object? localPath = freezed,
    Object? thumbnailUrl = freezed,
    Object? localThumbnailPath = freezed,
    Object? fileName = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? mimeType = freezed,
    Object? downloadStatus = null,
    Object? downloadProgress = null,
    Object? uploadStatus = null,
    Object? uploadProgress = null,
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
      localPath: freezed == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      localThumbnailPath: freezed == localThumbnailPath
          ? _value.localThumbnailPath
          : localThumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
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
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadStatus: null == downloadStatus
          ? _value.downloadStatus
          : downloadStatus // ignore: cast_nullable_to_non_nullable
              as DownloadStatus,
      downloadProgress: null == downloadProgress
          ? _value.downloadProgress
          : downloadProgress // ignore: cast_nullable_to_non_nullable
              as double,
      uploadStatus: null == uploadStatus
          ? _value.uploadStatus
          : uploadStatus // ignore: cast_nullable_to_non_nullable
              as UploadStatus,
      uploadProgress: null == uploadProgress
          ? _value.uploadProgress
          : uploadProgress // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageMediaImplCopyWith<$Res>
    implements $MessageMediaCopyWith<$Res> {
  factory _$$MessageMediaImplCopyWith(
          _$MessageMediaImpl value, $Res Function(_$MessageMediaImpl) then) =
      __$$MessageMediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MediaType type,
      String url,
      String? localPath,
      String? thumbnailUrl,
      String? localThumbnailPath,
      String? fileName,
      int? fileSize,
      int? duration,
      int? width,
      int? height,
      String? mimeType,
      DownloadStatus downloadStatus,
      double downloadProgress,
      UploadStatus uploadStatus,
      double uploadProgress,
      DateTime createdAt});
}

/// @nodoc
class __$$MessageMediaImplCopyWithImpl<$Res>
    extends _$MessageMediaCopyWithImpl<$Res, _$MessageMediaImpl>
    implements _$$MessageMediaImplCopyWith<$Res> {
  __$$MessageMediaImplCopyWithImpl(
      _$MessageMediaImpl _value, $Res Function(_$MessageMediaImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? url = null,
    Object? localPath = freezed,
    Object? thumbnailUrl = freezed,
    Object? localThumbnailPath = freezed,
    Object? fileName = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? mimeType = freezed,
    Object? downloadStatus = null,
    Object? downloadProgress = null,
    Object? uploadStatus = null,
    Object? uploadProgress = null,
    Object? createdAt = null,
  }) {
    return _then(_$MessageMediaImpl(
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
      localPath: freezed == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      localThumbnailPath: freezed == localThumbnailPath
          ? _value.localThumbnailPath
          : localThumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
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
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadStatus: null == downloadStatus
          ? _value.downloadStatus
          : downloadStatus // ignore: cast_nullable_to_non_nullable
              as DownloadStatus,
      downloadProgress: null == downloadProgress
          ? _value.downloadProgress
          : downloadProgress // ignore: cast_nullable_to_non_nullable
              as double,
      uploadStatus: null == uploadStatus
          ? _value.uploadStatus
          : uploadStatus // ignore: cast_nullable_to_non_nullable
              as UploadStatus,
      uploadProgress: null == uploadProgress
          ? _value.uploadProgress
          : uploadProgress // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$MessageMediaImpl extends _MessageMedia {
  const _$MessageMediaImpl(
      {required this.id,
      required this.type,
      required this.url,
      this.localPath,
      this.thumbnailUrl,
      this.localThumbnailPath,
      this.fileName,
      this.fileSize,
      this.duration,
      this.width,
      this.height,
      this.mimeType,
      this.downloadStatus = DownloadStatus.none,
      this.downloadProgress = 0.0,
      this.uploadStatus = UploadStatus.none,
      this.uploadProgress = 0.0,
      required this.createdAt})
      : super._();

  /// 媒体ID
  @override
  final String id;

  /// 媒体类型
  @override
  final MediaType type;

  /// 文件URL
  @override
  final String url;

  /// 本地文件路径
  @override
  final String? localPath;

  /// 缩略图URL
  @override
  final String? thumbnailUrl;

  /// 本地缩略图路径
  @override
  final String? localThumbnailPath;

  /// 文件名
  @override
  final String? fileName;

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

  /// MIME类型
  @override
  final String? mimeType;

  /// 下载状态
  @override
  @JsonKey()
  final DownloadStatus downloadStatus;

  /// 下载进度 (0.0 - 1.0)
  @override
  @JsonKey()
  final double downloadProgress;

  /// 上传状态
  @override
  @JsonKey()
  final UploadStatus uploadStatus;

  /// 上传进度 (0.0 - 1.0)
  @override
  @JsonKey()
  final double uploadProgress;

  /// 创建时间
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MessageMedia(id: $id, type: $type, url: $url, localPath: $localPath, thumbnailUrl: $thumbnailUrl, localThumbnailPath: $localThumbnailPath, fileName: $fileName, fileSize: $fileSize, duration: $duration, width: $width, height: $height, mimeType: $mimeType, downloadStatus: $downloadStatus, downloadProgress: $downloadProgress, uploadStatus: $uploadStatus, uploadProgress: $uploadProgress, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageMediaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.localThumbnailPath, localThumbnailPath) ||
                other.localThumbnailPath == localThumbnailPath) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.downloadStatus, downloadStatus) ||
                other.downloadStatus == downloadStatus) &&
            (identical(other.downloadProgress, downloadProgress) ||
                other.downloadProgress == downloadProgress) &&
            (identical(other.uploadStatus, uploadStatus) ||
                other.uploadStatus == uploadStatus) &&
            (identical(other.uploadProgress, uploadProgress) ||
                other.uploadProgress == uploadProgress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      url,
      localPath,
      thumbnailUrl,
      localThumbnailPath,
      fileName,
      fileSize,
      duration,
      width,
      height,
      mimeType,
      downloadStatus,
      downloadProgress,
      uploadStatus,
      uploadProgress,
      createdAt);

  /// Create a copy of MessageMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageMediaImplCopyWith<_$MessageMediaImpl> get copyWith =>
      __$$MessageMediaImplCopyWithImpl<_$MessageMediaImpl>(this, _$identity);
}

abstract class _MessageMedia extends MessageMedia {
  const factory _MessageMedia(
      {required final String id,
      required final MediaType type,
      required final String url,
      final String? localPath,
      final String? thumbnailUrl,
      final String? localThumbnailPath,
      final String? fileName,
      final int? fileSize,
      final int? duration,
      final int? width,
      final int? height,
      final String? mimeType,
      final DownloadStatus downloadStatus,
      final double downloadProgress,
      final UploadStatus uploadStatus,
      final double uploadProgress,
      required final DateTime createdAt}) = _$MessageMediaImpl;
  const _MessageMedia._() : super._();

  /// 媒体ID
  @override
  String get id;

  /// 媒体类型
  @override
  MediaType get type;

  /// 文件URL
  @override
  String get url;

  /// 本地文件路径
  @override
  String? get localPath;

  /// 缩略图URL
  @override
  String? get thumbnailUrl;

  /// 本地缩略图路径
  @override
  String? get localThumbnailPath;

  /// 文件名
  @override
  String? get fileName;

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

  /// MIME类型
  @override
  String? get mimeType;

  /// 下载状态
  @override
  DownloadStatus get downloadStatus;

  /// 下载进度 (0.0 - 1.0)
  @override
  double get downloadProgress;

  /// 上传状态
  @override
  UploadStatus get uploadStatus;

  /// 上传进度 (0.0 - 1.0)
  @override
  double get uploadProgress;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// Create a copy of MessageMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageMediaImplCopyWith<_$MessageMediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Conversation {
  /// 会话ID
  String get id => throw _privateConstructorUsedError;

  /// 会话类型
  ConversationType get type => throw _privateConstructorUsedError;

  /// 会话名称
  String? get name => throw _privateConstructorUsedError;

  /// 会话头像
  String? get avatar => throw _privateConstructorUsedError;

  /// 参与者列表
  List<User> get participants => throw _privateConstructorUsedError;

  /// 最后一条消息
  Message? get lastMessage => throw _privateConstructorUsedError;

  /// 未读消息数
  int get unreadCount => throw _privateConstructorUsedError;

  /// 是否置顶
  bool get isPinned => throw _privateConstructorUsedError;

  /// 是否免打扰
  bool get isMuted => throw _privateConstructorUsedError;

  /// 是否已删除
  bool get isDeleted => throw _privateConstructorUsedError;

  /// 是否被拉黑
  bool get isBlocked => throw _privateConstructorUsedError;

  /// 草稿内容
  String? get draft => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 最后活跃时间
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;

  /// 扩展数据
  Map<String, dynamic>? get extra => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {String id,
      ConversationType type,
      String? name,
      String? avatar,
      List<User> participants,
      Message? lastMessage,
      int unreadCount,
      bool isPinned,
      bool isMuted,
      bool isDeleted,
      bool isBlocked,
      String? draft,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastActiveAt,
      Map<String, dynamic>? extra});

  $MessageCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? avatar = freezed,
    Object? participants = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? isPinned = null,
    Object? isMuted = null,
    Object? isDeleted = null,
    Object? isBlocked = null,
    Object? draft = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastActiveAt = freezed,
    Object? extra = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ConversationType,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<User>,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as Message?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      draft: freezed == draft
          ? _value.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $MessageCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ConversationType type,
      String? name,
      String? avatar,
      List<User> participants,
      Message? lastMessage,
      int unreadCount,
      bool isPinned,
      bool isMuted,
      bool isDeleted,
      bool isBlocked,
      String? draft,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastActiveAt,
      Map<String, dynamic>? extra});

  @override
  $MessageCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? avatar = freezed,
    Object? participants = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? isPinned = null,
    Object? isMuted = null,
    Object? isDeleted = null,
    Object? isBlocked = null,
    Object? draft = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastActiveAt = freezed,
    Object? extra = freezed,
  }) {
    return _then(_$ConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ConversationType,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<User>,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as Message?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      draft: freezed == draft
          ? _value.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      extra: freezed == extra
          ? _value._extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$ConversationImpl extends _Conversation {
  const _$ConversationImpl(
      {required this.id,
      this.type = ConversationType.single,
      this.name,
      this.avatar,
      final List<User> participants = const [],
      this.lastMessage,
      this.unreadCount = 0,
      this.isPinned = false,
      this.isMuted = false,
      this.isDeleted = false,
      this.isBlocked = false,
      this.draft,
      required this.createdAt,
      required this.updatedAt,
      this.lastActiveAt,
      final Map<String, dynamic>? extra})
      : _participants = participants,
        _extra = extra,
        super._();

  /// 会话ID
  @override
  final String id;

  /// 会话类型
  @override
  @JsonKey()
  final ConversationType type;

  /// 会话名称
  @override
  final String? name;

  /// 会话头像
  @override
  final String? avatar;

  /// 参与者列表
  final List<User> _participants;

  /// 参与者列表
  @override
  @JsonKey()
  List<User> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  /// 最后一条消息
  @override
  final Message? lastMessage;

  /// 未读消息数
  @override
  @JsonKey()
  final int unreadCount;

  /// 是否置顶
  @override
  @JsonKey()
  final bool isPinned;

  /// 是否免打扰
  @override
  @JsonKey()
  final bool isMuted;

  /// 是否已删除
  @override
  @JsonKey()
  final bool isDeleted;

  /// 是否被拉黑
  @override
  @JsonKey()
  final bool isBlocked;

  /// 草稿内容
  @override
  final String? draft;

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 更新时间
  @override
  final DateTime updatedAt;

  /// 最后活跃时间
  @override
  final DateTime? lastActiveAt;

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
    return 'Conversation(id: $id, type: $type, name: $name, avatar: $avatar, participants: $participants, lastMessage: $lastMessage, unreadCount: $unreadCount, isPinned: $isPinned, isMuted: $isMuted, isDeleted: $isDeleted, isBlocked: $isBlocked, draft: $draft, createdAt: $createdAt, updatedAt: $updatedAt, lastActiveAt: $lastActiveAt, extra: $extra)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            const DeepCollectionEquality().equals(other._extra, _extra));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      avatar,
      const DeepCollectionEquality().hash(_participants),
      lastMessage,
      unreadCount,
      isPinned,
      isMuted,
      isDeleted,
      isBlocked,
      draft,
      createdAt,
      updatedAt,
      lastActiveAt,
      const DeepCollectionEquality().hash(_extra));

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);
}

abstract class _Conversation extends Conversation {
  const factory _Conversation(
      {required final String id,
      final ConversationType type,
      final String? name,
      final String? avatar,
      final List<User> participants,
      final Message? lastMessage,
      final int unreadCount,
      final bool isPinned,
      final bool isMuted,
      final bool isDeleted,
      final bool isBlocked,
      final String? draft,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? lastActiveAt,
      final Map<String, dynamic>? extra}) = _$ConversationImpl;
  const _Conversation._() : super._();

  /// 会话ID
  @override
  String get id;

  /// 会话类型
  @override
  ConversationType get type;

  /// 会话名称
  @override
  String? get name;

  /// 会话头像
  @override
  String? get avatar;

  /// 参与者列表
  @override
  List<User> get participants;

  /// 最后一条消息
  @override
  Message? get lastMessage;

  /// 未读消息数
  @override
  int get unreadCount;

  /// 是否置顶
  @override
  bool get isPinned;

  /// 是否免打扰
  @override
  bool get isMuted;

  /// 是否已删除
  @override
  bool get isDeleted;

  /// 是否被拉黑
  @override
  bool get isBlocked;

  /// 草稿内容
  @override
  String? get draft;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 更新时间
  @override
  DateTime get updatedAt;

  /// 最后活跃时间
  @override
  DateTime? get lastActiveAt;

  /// 扩展数据
  @override
  Map<String, dynamic>? get extra;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
