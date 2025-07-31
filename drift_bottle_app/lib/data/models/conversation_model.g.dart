// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      creator: json['creator'] == null
          ? null
          : UserModel.fromJson(json['creator'] as Map<String, dynamic>),
      adminIds:
          (json['admin_ids'] as List<dynamic>).map((e) => e as String).toList(),
      lastMessage: json['last_message'] == null
          ? null
          : MessageModel.fromJson(json['last_message'] as Map<String, dynamic>),
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String),
      unreadCount: (json['unread_count'] as num).toInt(),
      isMuted: json['is_muted'] as bool,
      isPinned: json['is_pinned'] as bool,
      isArchived: json['is_archived'] as bool,
      isDeleted: json['is_deleted'] as bool,
      isActive: json['is_active'] as bool,
      settings: json['settings'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'avatar_url': instance.avatarUrl,
      'participants': instance.participants,
      'creator': instance.creator,
      'admin_ids': instance.adminIds,
      'last_message': instance.lastMessage,
      'last_message_at': instance.lastMessageAt?.toIso8601String(),
      'unread_count': instance.unreadCount,
      'is_muted': instance.isMuted,
      'is_pinned': instance.isPinned,
      'is_archived': instance.isArchived,
      'is_deleted': instance.isDeleted,
      'is_active': instance.isActive,
      'settings': instance.settings,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

ConversationListModel _$ConversationListModelFromJson(
        Map<String, dynamic> json) =>
    ConversationListModel(
      conversations: (json['conversations'] as List<dynamic>)
          .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num).toInt(),
      hasMore: json['has_more'] as bool,
      nextCursor: json['next_cursor'] as String?,
      prevCursor: json['prev_cursor'] as String?,
    );

Map<String, dynamic> _$ConversationListModelToJson(
        ConversationListModel instance) =>
    <String, dynamic>{
      'conversations': instance.conversations,
      'total_count': instance.totalCount,
      'has_more': instance.hasMore,
      'next_cursor': instance.nextCursor,
      'prev_cursor': instance.prevCursor,
    };

ConversationStatsModel _$ConversationStatsModelFromJson(
        Map<String, dynamic> json) =>
    ConversationStatsModel(
      totalConversations: (json['total_conversations'] as num).toInt(),
      activeConversations: (json['active_conversations'] as num).toInt(),
      archivedConversations: (json['archived_conversations'] as num).toInt(),
      mutedConversations: (json['muted_conversations'] as num).toInt(),
      pinnedConversations: (json['pinned_conversations'] as num).toInt(),
      totalUnreadMessages: (json['total_unread_messages'] as num).toInt(),
      conversationTypes:
          Map<String, int>.from(json['conversation_types'] as Map),
    );

Map<String, dynamic> _$ConversationStatsModelToJson(
        ConversationStatsModel instance) =>
    <String, dynamic>{
      'total_conversations': instance.totalConversations,
      'active_conversations': instance.activeConversations,
      'archived_conversations': instance.archivedConversations,
      'muted_conversations': instance.mutedConversations,
      'pinned_conversations': instance.pinnedConversations,
      'total_unread_messages': instance.totalUnreadMessages,
      'conversation_types': instance.conversationTypes,
    };
