import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';
import 'message_model.dart';

part 'conversation_model.g.dart';

/// 会话模型 - 与后端API保持一致
@JsonSerializable()
class ConversationModel {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  @JsonKey(name: 'user1_id')
  final int user1Id;
  
  @JsonKey(name: 'user2_id')
  final int user2Id;
  
  @JsonKey(name: 'last_message_id')
  final int? lastMessageId;
  
  @JsonKey(name: 'last_message_content')
  final String lastMessageContent;
  
  @JsonKey(name: 'last_message_time')
  final DateTime lastMessageTime;
  
  @JsonKey(name: 'user1_unread_count')
  final int user1UnreadCount;
  
  @JsonKey(name: 'user2_unread_count')
  final int user2UnreadCount;
  
  @JsonKey(name: 'user1')
  final UserModel? user1;
  
  @JsonKey(name: 'user2')
  final UserModel? user2;
  
  @JsonKey(name: 'messages')
  final List<MessageModel>? messages;
  
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  @JsonKey(name: 'settings')
  final Map<String, dynamic>? settings;
  
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  
  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;
  
  const ConversationModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.user1Id,
    required this.user2Id,
    this.lastMessageId,
    required this.lastMessageContent,
    required this.lastMessageTime,
    this.user1UnreadCount = 0,
    this.user2UnreadCount = 0,
    this.user1,
    this.user2,
    this.messages,
    this.isArchived = false,
    this.isDeleted = false,
    this.isActive = true,
    this.settings,
    this.deletedAt,
    this.metadata,
  });
  
  /// 从JSON创建模型
  factory ConversationModel.fromJson(Map<String, dynamic> json) => _$ConversationModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
  
  /// 从实体创建模型
  factory ConversationModel.fromEntity(Conversation conversation) {
    return ConversationModel(
      id: conversation.id,
      type: conversation.type.name,
      title: conversation.name,
      description: null,
      avatarUrl: conversation.avatar,
      participants: conversation.participants.map((user) => UserModel.fromEntity(user)).toList(),
      creator: null,
      adminIds: [],
      lastMessage: conversation.lastMessage != null 
          ? MessageModel.fromEntity(conversation.lastMessage!, conversation.participants.first)
          : null,
      lastMessageAt: conversation.lastMessageAt,
      unreadCount: conversation.unreadCount,
      isMuted: conversation.isMuted,
      isPinned: conversation.isPinned,
      isArchived: conversation.isArchived,
      isDeleted: false,
      isActive: true,
      settings: null,
      createdAt: conversation.createdAt,
      updatedAt: conversation.updatedAt,
      deletedAt: null,
      metadata: null,
    );
  }
  
  /// 转换为实体
  Conversation toEntity() {
    return Conversation(
      id: id,
      type: ConversationType.values.firstWhere((e) => e.name == type, orElse: () => ConversationType.single),
      name: title,
      avatar: avatarUrl,
      participants: participants.map((user) => user.toEntity()).toList(),
      lastMessage: lastMessage?.toEntity(),
      unreadCount: unreadCount,
      isPinned: isPinned,
      isMuted: isMuted,
      isArchived: isArchived,
      isBlocked: false,
      draft: null,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessageAt: lastMessageAt,
    );
  }
  
  /// 复制并修改
  ConversationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? avatarUrl,
    List<UserModel>? participants,
    UserModel? creator,
    List<String>? adminIds,
    MessageModel? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    bool? isArchived,
    bool? isDeleted,
    bool? isActive,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      participants: participants ?? this.participants,
      creator: creator ?? this.creator,
      adminIds: adminIds ?? this.adminIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      metadata: metadata ?? this.metadata,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ConversationModel &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.description == description &&
        other.avatarUrl == avatarUrl &&
        other.participants == participants &&
        other.creator == creator &&
        other.adminIds == adminIds &&
        other.lastMessage == lastMessage &&
        other.lastMessageAt == lastMessageAt &&
        other.unreadCount == unreadCount &&
        other.isMuted == isMuted &&
        other.isPinned == isPinned &&
        other.isArchived == isArchived &&
        other.isDeleted == isDeleted &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        title.hashCode ^
        description.hashCode ^
        avatarUrl.hashCode ^
        participants.hashCode ^
        creator.hashCode ^
        adminIds.hashCode ^
        lastMessage.hashCode ^
        lastMessageAt.hashCode ^
        unreadCount.hashCode ^
        isMuted.hashCode ^
        isPinned.hashCode ^
        isArchived.hashCode ^
        isDeleted.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }
  
  @override
  String toString() {
    return 'ConversationModel(id: $id, type: $type, title: $title, participants: ${participants.length}, unreadCount: $unreadCount)';
  }
}

/// 会话列表模型
@JsonSerializable()
class ConversationListModel {
  @JsonKey(name: 'conversations')
  final List<ConversationModel> conversations;
  
  @JsonKey(name: 'total_count')
  final int totalCount;
  
  @JsonKey(name: 'has_more')
  final bool hasMore;
  
  @JsonKey(name: 'next_cursor')
  final String? nextCursor;
  
  @JsonKey(name: 'prev_cursor')
  final String? prevCursor;
  
  const ConversationListModel({
    required this.conversations,
    required this.totalCount,
    required this.hasMore,
    this.nextCursor,
    this.prevCursor,
  });
  
  /// 从JSON创建模型
  factory ConversationListModel.fromJson(Map<String, dynamic> json) => _$ConversationListModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$ConversationListModelToJson(this);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ConversationListModel &&
        other.conversations == conversations &&
        other.totalCount == totalCount &&
        other.hasMore == hasMore &&
        other.nextCursor == nextCursor &&
        other.prevCursor == prevCursor;
  }
  
  @override
  int get hashCode {
    return conversations.hashCode ^
        totalCount.hashCode ^
        hasMore.hashCode ^
        nextCursor.hashCode ^
        prevCursor.hashCode;
  }
  
  @override
  String toString() {
    return 'ConversationListModel(conversations: ${conversations.length}, totalCount: $totalCount, hasMore: $hasMore)';
  }
}

/// 会话统计模型
@JsonSerializable()
class ConversationStatsModel {
  @JsonKey(name: 'total_conversations')
  final int totalConversations;
  
  @JsonKey(name: 'active_conversations')
  final int activeConversations;
  
  @JsonKey(name: 'archived_conversations')
  final int archivedConversations;
  
  @JsonKey(name: 'muted_conversations')
  final int mutedConversations;
  
  @JsonKey(name: 'pinned_conversations')
  final int pinnedConversations;
  
  @JsonKey(name: 'total_unread_messages')
  final int totalUnreadMessages;
  
  @JsonKey(name: 'conversation_types')
  final Map<String, int> conversationTypes;
  
  const ConversationStatsModel({
    required this.totalConversations,
    required this.activeConversations,
    required this.archivedConversations,
    required this.mutedConversations,
    required this.pinnedConversations,
    required this.totalUnreadMessages,
    required this.conversationTypes,
  });
  
  /// 从JSON创建模型
  factory ConversationStatsModel.fromJson(Map<String, dynamic> json) => _$ConversationStatsModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$ConversationStatsModelToJson(this);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ConversationStatsModel &&
        other.totalConversations == totalConversations &&
        other.activeConversations == activeConversations &&
        other.archivedConversations == archivedConversations &&
        other.mutedConversations == mutedConversations &&
        other.pinnedConversations == pinnedConversations &&
        other.totalUnreadMessages == totalUnreadMessages;
  }
  
  @override
  int get hashCode {
    return totalConversations.hashCode ^
        activeConversations.hashCode ^
        archivedConversations.hashCode ^
        mutedConversations.hashCode ^
        pinnedConversations.hashCode ^
        totalUnreadMessages.hashCode ^
        conversationTypes.hashCode;
  }
  
  @override
  String toString() {
    return 'ConversationStatsModel(totalConversations: $totalConversations, activeConversations: $activeConversations, totalUnreadMessages: $totalUnreadMessages)';
  }
}