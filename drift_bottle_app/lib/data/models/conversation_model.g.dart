// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user1Id: (json['user1_id'] as num).toInt(),
      user2Id: (json['user2_id'] as num).toInt(),
      lastMessageId: (json['last_message_id'] as num?)?.toInt(),
      lastMessageContent: json['last_message_content'] as String?,
      lastMessageTime: json['last_message_time'] == null
          ? null
          : DateTime.parse(json['last_message_time'] as String),
      user1UnreadCount: (json['user1_unread_count'] as num?)?.toInt() ?? 0,
      user2UnreadCount: (json['user2_unread_count'] as num?)?.toInt() ?? 0,
      user1: json['user1'] == null
          ? null
          : UserModel.fromJson(json['user1'] as Map<String, dynamic>),
      user2: json['user2'] == null
          ? null
          : UserModel.fromJson(json['user2'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user1_id': instance.user1Id,
      'user2_id': instance.user2Id,
      'last_message_id': instance.lastMessageId,
      'last_message_content': instance.lastMessageContent,
      'last_message_time': instance.lastMessageTime?.toIso8601String(),
      'user1_unread_count': instance.user1UnreadCount,
      'user2_unread_count': instance.user2UnreadCount,
      'user1': instance.user1,
      'user2': instance.user2,
      'messages': instance.messages,
    };
