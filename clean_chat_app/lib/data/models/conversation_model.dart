import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/message.dart';
import 'user_model.dart';
import 'message_model.dart';

part 'conversation_model.g.dart';

/// 会话数据模型
@JsonSerializable()
class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.user1Id,
    required super.user2Id,
    super.lastMessageId,
    super.lastMessageContent,
    super.lastMessageTime,
    super.user1UnreadCount = 0,
    super.user2UnreadCount = 0,
    required super.createdAt,
    required super.updatedAt,
    super.user1,
    super.user2,
    super.lastMessage,
  });

  /// 从JSON创建ConversationModel
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int,
      user1Id: json['user1Id'] as int,
      user2Id: json['user2Id'] as int,
      lastMessageId: json['lastMessageId'] as int?,
      lastMessageContent: json['lastMessageContent'] as String?,
      lastMessageTime: json['lastMessageTime'] != null 
          ? DateTime.parse(json['lastMessageTime'] as String)
          : null,
      user1UnreadCount: json['user1UnreadCount'] as int? ?? 0,
      user2UnreadCount: json['user2UnreadCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user1: json['user1'] != null 
          ? UserModel.fromJson(json['user1'] as Map<String, dynamic>).toEntity()
          : null,
      user2: json['user2'] != null 
          ? UserModel.fromJson(json['user2'] as Map<String, dynamic>).toEntity()
          : null,
      lastMessage: json['lastMessage'] != null 
          ? MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>).toEntity()
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'lastMessageId': lastMessageId,
      'lastMessageContent': lastMessageContent,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'user1UnreadCount': user1UnreadCount,
      'user2UnreadCount': user2UnreadCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user1': user1 != null ? UserModel.fromEntity(user1!).toJson() : null,
      'user2': user2 != null ? UserModel.fromEntity(user2!).toJson() : null,
      'lastMessage': lastMessage != null ? MessageModel.fromEntity(lastMessage!).toJson() : null,
    };
  }

  /// 从Conversation实体创建ConversationModel
  factory ConversationModel.fromEntity(Conversation conversation) {
    return ConversationModel(
      id: conversation.id,
      user1Id: conversation.user1Id,
      user2Id: conversation.user2Id,
      lastMessageId: conversation.lastMessageId,
      lastMessageContent: conversation.lastMessageContent,
      lastMessageTime: conversation.lastMessageTime,
      user1UnreadCount: conversation.user1UnreadCount,
      user2UnreadCount: conversation.user2UnreadCount,
      createdAt: conversation.createdAt,
      updatedAt: conversation.updatedAt,
      user1: conversation.user1,
      user2: conversation.user2,
      lastMessage: conversation.lastMessage,
    );
  }

  /// 转换为Conversation实体
  Conversation toEntity() {
    return Conversation(
      id: id,
      user1Id: user1Id,
      user2Id: user2Id,
      lastMessageId: lastMessageId,
      lastMessageContent: lastMessageContent,
      lastMessageTime: lastMessageTime,
      user1UnreadCount: user1UnreadCount,
      user2UnreadCount: user2UnreadCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user1: user1,
      user2: user2,
      lastMessage: lastMessage,
    );
  }

  /// 复制并更新部分字段
  ConversationModel copyWith({
    int? id,
    int? user1Id,
    int? user2Id,
    int? lastMessageId,
    String? lastMessageContent,
    DateTime? lastMessageTime,
    int? user1UnreadCount,
    int? user2UnreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user1,
    User? user2,
    Message? lastMessage,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      user1UnreadCount: user1UnreadCount ?? this.user1UnreadCount,
      user2UnreadCount: user2UnreadCount ?? this.user2UnreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}