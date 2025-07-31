// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String,
      messageType: json['message_type'] as String,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      videoUrl: json['video_url'] as String?,
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      thumbnailUrl: json['thumbnail_url'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      isRead: json['is_read'] as bool,
      isRecalled: json['is_recalled'] as bool,
      isDeleted: json['is_deleted'] as bool,
      status: json['status'] as String,
      replyTo: json['reply_to'] == null
          ? null
          : MessageModel.fromJson(json['reply_to'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      recalledAt: json['recalled_at'] == null
          ? null
          : DateTime.parse(json['recalled_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender': instance.sender,
      'content': instance.content,
      'message_type': instance.messageType,
      'image_url': instance.imageUrl,
      'audio_url': instance.audioUrl,
      'video_url': instance.videoUrl,
      'file_url': instance.fileUrl,
      'file_name': instance.fileName,
      'file_size': instance.fileSize,
      'thumbnail_url': instance.thumbnailUrl,
      'duration': instance.duration,
      'is_read': instance.isRead,
      'is_recalled': instance.isRecalled,
      'is_deleted': instance.isDeleted,
      'status': instance.status,
      'reply_to': instance.replyTo,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
      'recalled_at': instance.recalledAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

MessageListModel _$MessageListModelFromJson(Map<String, dynamic> json) =>
    MessageListModel(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num).toInt(),
      hasMore: json['has_more'] as bool,
      nextCursor: json['next_cursor'] as String?,
      prevCursor: json['prev_cursor'] as String?,
    );

Map<String, dynamic> _$MessageListModelToJson(MessageListModel instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'total_count': instance.totalCount,
      'has_more': instance.hasMore,
      'next_cursor': instance.nextCursor,
      'prev_cursor': instance.prevCursor,
    };

MessageStatsModel _$MessageStatsModelFromJson(Map<String, dynamic> json) =>
    MessageStatsModel(
      totalSent: (json['total_sent'] as num).toInt(),
      totalReceived: (json['total_received'] as num).toInt(),
      totalUnread: (json['total_unread'] as num).toInt(),
      todaySent: (json['today_sent'] as num).toInt(),
      todayReceived: (json['today_received'] as num).toInt(),
      thisWeekSent: (json['this_week_sent'] as num).toInt(),
      thisWeekReceived: (json['this_week_received'] as num).toInt(),
      thisMonthSent: (json['this_month_sent'] as num).toInt(),
      thisMonthReceived: (json['this_month_received'] as num).toInt(),
      messageTypes: Map<String, int>.from(json['message_types'] as Map),
    );

Map<String, dynamic> _$MessageStatsModelToJson(MessageStatsModel instance) =>
    <String, dynamic>{
      'total_sent': instance.totalSent,
      'total_received': instance.totalReceived,
      'total_unread': instance.totalUnread,
      'today_sent': instance.todaySent,
      'today_received': instance.todayReceived,
      'this_week_sent': instance.thisWeekSent,
      'this_week_received': instance.thisWeekReceived,
      'this_month_sent': instance.thisMonthSent,
      'this_month_received': instance.thisMonthReceived,
      'message_types': instance.messageTypes,
    };
