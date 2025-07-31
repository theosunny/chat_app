import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'message_model.g.dart';

/// 消息模型 - 与后端API保持一致
@JsonSerializable()
class MessageModel {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  @JsonKey(name: 'conversation_id')
  final int conversationId;
  
  @JsonKey(name: 'sender_id')
  final int senderId;
  
  @JsonKey(name: 'receiver_id')
  final int receiverId;
  
  @JsonKey(name: 'content')
  final String content;
  
  @JsonKey(name: 'message_type')
  final String messageType; // 'text', 'image', 'file'
  
  @JsonKey(name: 'is_read')
  final bool isRead;
  
  // 关联对象
  @JsonKey(name: 'sender')
  final UserModel? sender;
  
  @JsonKey(name: 'receiver')
  final UserModel? receiver;
  
  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.messageType,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.thumbnailUrl,
    this.duration,
    required this.isRead,
    required this.isRecalled,
    required this.isDeleted,
    required this.status,
    this.replyTo,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
    this.recalledAt,
    this.metadata,
  });
  
  /// 从JSON创建模型
  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
  
  /// 转换为实体
  Message toEntity() {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: sender.id,
      type: _stringToMessageType(messageType),
      content: content,
      media: _createMediaFromFields(),
      isRead: isRead,
      isRecalled: isRecalled,
      isDeleted: isDeleted,
      status: _stringToMessageStatus(status),
      replyToMessageId: replyTo?.id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      readAt: readAt,
      recalledAt: recalledAt,
      extra: metadata,
    );
  }
  
  /// 从实体创建模型（仅使用senderId）
  factory MessageModel.fromEntityWithId(Message message) {
    // 创建一个简化的发送者对象
    final simpleSender = UserModel(
      id: message.senderId,
      phone: '',
      nickname: '用户${message.senderId.substring(0, 8)}',
      avatar: null,
      gender: null,
      age: null,
      location: null,
      signature: null,
      isOnline: false,
      lastActiveAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return MessageModel(
      id: message.id,
      conversationId: message.conversationId,
      sender: simpleSender,
      content: message.content,
      messageType: _messageTypeToString(message.type),
      imageUrl: message.media?.type == MediaType.image ? message.media?.url : null,
      audioUrl: message.media?.type == MediaType.audio ? message.media?.url : null,
      videoUrl: message.media?.type == MediaType.video ? message.media?.url : null,
      fileUrl: message.media?.type == MediaType.file ? message.media?.url : null,
      fileName: message.media?.fileName,
      fileSize: message.media?.fileSize,
      thumbnailUrl: message.media?.thumbnailUrl,
      duration: message.media?.duration,
      isRead: message.isRead,
      isRecalled: message.isRecalled,
      isDeleted: message.isDeleted,
      isPinned: message.isPinned,
      replyToMessageId: message.replyToMessageId,
      forwardFromMessageId: null,
      reactions: [],
      mentions: [],
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
      deletedAt: null,
    );
   }
  
  /// 从字段创建媒体对象
  MessageMedia? _createMediaFromFields() {
    if (imageUrl != null) {
      return MessageMedia(
        id: id,
        type: MediaType.image,
        url: imageUrl!,
        thumbnailUrl: thumbnailUrl,
        createdAt: createdAt,
      );
    } else if (audioUrl != null) {
      return MessageMedia(
        id: id,
        type: MediaType.audio,
        url: audioUrl!,
        duration: duration,
        createdAt: createdAt,
      );
    } else if (videoUrl != null) {
      return MessageMedia(
        id: id,
        type: MediaType.video,
        url: videoUrl!,
        thumbnailUrl: thumbnailUrl,
        duration: duration,
        createdAt: createdAt,
      );
    } else if (fileUrl != null) {
      return MessageMedia(
        id: id,
        type: MediaType.file,
        url: fileUrl!,
        fileName: fileName,
        fileSize: fileSize,
        createdAt: createdAt,
      );
    }
    return null;
  }
  
  /// 从实体创建模型（带发送者信息）
  factory MessageModel.fromEntity(Message message, User sender) {
    return MessageModel(
      id: message.id,
      conversationId: message.conversationId,
      sender: UserModel.fromEntity(sender),
      content: message.content,
      messageType: _messageTypeToString(message.type),
      imageUrl: message.media?.type == MediaType.image ? message.media?.url : null,
      audioUrl: message.media?.type == MediaType.audio ? message.media?.url : null,
      videoUrl: message.media?.type == MediaType.video ? message.media?.url : null,
      fileUrl: message.media?.type == MediaType.file ? message.media?.url : null,
      fileName: message.media?.fileName,
      fileSize: message.media?.fileSize,
      thumbnailUrl: message.media?.thumbnailUrl,
      duration: message.media?.duration,
      isRead: message.isRead,
      isRecalled: message.isRecalled,
      isDeleted: message.isDeleted,
      status: _messageStatusToString(message.status),
      replyTo: null, // 需要根据replyToMessageId查询
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
      readAt: message.readAt,
      recalledAt: message.recalledAt,
      metadata: message.extra,
    );
  }
  
  /// 消息类型转换为字符串
  static String _messageTypeToString(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.audio:
        return 'audio';
      case MessageType.video:
        return 'video';
      case MessageType.file:
        return 'file';
      case MessageType.location:
        return 'location';
      case MessageType.contact:
        return 'contact';
      case MessageType.system:
        return 'system';
      case MessageType.custom:
        return 'custom';
    }
  }
  
  /// 字符串转换为消息类型
  static MessageType _stringToMessageType(String type) {
    switch (type) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      case 'file':
        return MessageType.file;
      case 'location':
        return MessageType.location;
      case 'contact':
        return MessageType.contact;
      case 'system':
        return MessageType.system;
      case 'custom':
        return MessageType.custom;
      default:
        return MessageType.text;
    }
  }
  
  /// 消息状态转换为字符串
  static String _messageStatusToString(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 'sending';
      case MessageStatus.sent:
        return 'sent';
      case MessageStatus.delivered:
        return 'delivered';
      case MessageStatus.read:
        return 'read';
      case MessageStatus.failed:
        return 'failed';
    }
  }
  
  /// 字符串转换为消息状态
  static MessageStatus _stringToMessageStatus(String status) {
    switch (status) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }
  
  /// 复制并修改
  MessageModel copyWith({
    String? id,
    String? conversationId,
    UserModel? sender,
    String? content,
    String? messageType,
    String? imageUrl,
    String? audioUrl,
    String? videoUrl,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? thumbnailUrl,
    int? duration,
    bool? isRead,
    bool? isRecalled,
    bool? isDeleted,
    String? status,
    MessageModel? replyTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? readAt,
    DateTime? recalledAt,
    Map<String, dynamic>? metadata,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      isRead: isRead ?? this.isRead,
      isRecalled: isRecalled ?? this.isRecalled,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
      replyTo: replyTo ?? this.replyTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      readAt: readAt ?? this.readAt,
      recalledAt: recalledAt ?? this.recalledAt,
      metadata: metadata ?? this.metadata,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MessageModel &&
        other.id == id &&
        other.conversationId == conversationId &&
        other.sender == sender &&
        other.content == content &&
        other.messageType == messageType &&
        other.imageUrl == imageUrl &&
        other.audioUrl == audioUrl &&
        other.videoUrl == videoUrl &&
        other.fileUrl == fileUrl &&
        other.fileName == fileName &&
        other.fileSize == fileSize &&
        other.thumbnailUrl == thumbnailUrl &&
        other.duration == duration &&
        other.isRead == isRead &&
        other.isRecalled == isRecalled &&
        other.isDeleted == isDeleted &&
        other.status == status &&
        other.replyTo == replyTo &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.readAt == readAt &&
        other.recalledAt == recalledAt;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        conversationId.hashCode ^
        sender.hashCode ^
        content.hashCode ^
        messageType.hashCode ^
        imageUrl.hashCode ^
        audioUrl.hashCode ^
        videoUrl.hashCode ^
        fileUrl.hashCode ^
        fileName.hashCode ^
        fileSize.hashCode ^
        thumbnailUrl.hashCode ^
        duration.hashCode ^
        isRead.hashCode ^
        isRecalled.hashCode ^
        isDeleted.hashCode ^
        status.hashCode ^
        replyTo.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        readAt.hashCode ^
        recalledAt.hashCode;
  }
  
  @override
  String toString() {
    return 'MessageModel(id: $id, sender: ${sender.nickname}, content: $content, messageType: $messageType, createdAt: $createdAt)';
  }
}

/// 消息列表模型
@JsonSerializable()
class MessageListModel {
  @JsonKey(name: 'messages')
  final List<MessageModel> messages;
  
  @JsonKey(name: 'total_count')
  final int totalCount;
  
  @JsonKey(name: 'has_more')
  final bool hasMore;
  
  @JsonKey(name: 'next_cursor')
  final String? nextCursor;
  
  @JsonKey(name: 'prev_cursor')
  final String? prevCursor;
  
  const MessageListModel({
    required this.messages,
    required this.totalCount,
    required this.hasMore,
    this.nextCursor,
    this.prevCursor,
  });
  
  /// 从JSON创建模型
  factory MessageListModel.fromJson(Map<String, dynamic> json) => _$MessageListModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$MessageListModelToJson(this);
  
  /// 复制并修改
  MessageListModel copyWith({
    List<MessageModel>? messages,
    int? totalCount,
    bool? hasMore,
    String? nextCursor,
    String? prevCursor,
  }) {
    return MessageListModel(
      messages: messages ?? this.messages,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      prevCursor: prevCursor ?? this.prevCursor,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MessageListModel &&
        other.messages == messages &&
        other.totalCount == totalCount &&
        other.hasMore == hasMore &&
        other.nextCursor == nextCursor &&
        other.prevCursor == prevCursor;
  }
  
  @override
  int get hashCode {
    return messages.hashCode ^
        totalCount.hashCode ^
        hasMore.hashCode ^
        nextCursor.hashCode ^
        prevCursor.hashCode;
  }
  
  @override
  String toString() {
    return 'MessageListModel(messages: ${messages.length}, totalCount: $totalCount, hasMore: $hasMore)';
  }
}

/// 消息统计模型
@JsonSerializable()
class MessageStatsModel {
  @JsonKey(name: 'total_sent')
  final int totalSent;
  
  @JsonKey(name: 'total_received')
  final int totalReceived;
  
  @JsonKey(name: 'total_unread')
  final int totalUnread;
  
  @JsonKey(name: 'today_sent')
  final int todaySent;
  
  @JsonKey(name: 'today_received')
  final int todayReceived;
  
  @JsonKey(name: 'this_week_sent')
  final int thisWeekSent;
  
  @JsonKey(name: 'this_week_received')
  final int thisWeekReceived;
  
  @JsonKey(name: 'this_month_sent')
  final int thisMonthSent;
  
  @JsonKey(name: 'this_month_received')
  final int thisMonthReceived;
  
  @JsonKey(name: 'message_types')
  final Map<String, int> messageTypes;
  
  const MessageStatsModel({
    required this.totalSent,
    required this.totalReceived,
    required this.totalUnread,
    required this.todaySent,
    required this.todayReceived,
    required this.thisWeekSent,
    required this.thisWeekReceived,
    required this.thisMonthSent,
    required this.thisMonthReceived,
    required this.messageTypes,
  });
  
  /// 从JSON创建模型
  factory MessageStatsModel.fromJson(Map<String, dynamic> json) => _$MessageStatsModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$MessageStatsModelToJson(this);
  
  /// 复制并修改
  MessageStatsModel copyWith({
    int? totalSent,
    int? totalReceived,
    int? totalUnread,
    int? todaySent,
    int? todayReceived,
    int? thisWeekSent,
    int? thisWeekReceived,
    int? thisMonthSent,
    int? thisMonthReceived,
    Map<String, int>? messageTypes,
  }) {
    return MessageStatsModel(
      totalSent: totalSent ?? this.totalSent,
      totalReceived: totalReceived ?? this.totalReceived,
      totalUnread: totalUnread ?? this.totalUnread,
      todaySent: todaySent ?? this.todaySent,
      todayReceived: todayReceived ?? this.todayReceived,
      thisWeekSent: thisWeekSent ?? this.thisWeekSent,
      thisWeekReceived: thisWeekReceived ?? this.thisWeekReceived,
      thisMonthSent: thisMonthSent ?? this.thisMonthSent,
      thisMonthReceived: thisMonthReceived ?? this.thisMonthReceived,
      messageTypes: messageTypes ?? this.messageTypes,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MessageStatsModel &&
        other.totalSent == totalSent &&
        other.totalReceived == totalReceived &&
        other.totalUnread == totalUnread &&
        other.todaySent == todaySent &&
        other.todayReceived == todayReceived &&
        other.thisWeekSent == thisWeekSent &&
        other.thisWeekReceived == thisWeekReceived &&
        other.thisMonthSent == thisMonthSent &&
        other.thisMonthReceived == thisMonthReceived &&
        other.messageTypes == messageTypes;
  }
  
  @override
  int get hashCode {
    return totalSent.hashCode ^
        totalReceived.hashCode ^
        totalUnread.hashCode ^
        todaySent.hashCode ^
        todayReceived.hashCode ^
        thisWeekSent.hashCode ^
        thisWeekReceived.hashCode ^
        thisMonthSent.hashCode ^
        thisMonthReceived.hashCode ^
        messageTypes.hashCode;
  }
  
  @override
  String toString() {
    return 'MessageStatsModel(totalSent: $totalSent, totalReceived: $totalReceived, totalUnread: $totalUnread)';
  }
}