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
  final String? lastMessageContent;
  
  @JsonKey(name: 'last_message_time')
  final DateTime? lastMessageTime;
  
  @JsonKey(name: 'user1_unread_count')
  final int user1UnreadCount;
  
  @JsonKey(name: 'user2_unread_count')
  final int user2UnreadCount;
  
  // 关联对象
  @JsonKey(name: 'user1')
  final UserModel? user1;
  
  @JsonKey(name: 'user2')
  final UserModel? user2;
  
  @JsonKey(name: 'messages')
  final List<MessageModel>? messages;

  const ConversationModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.user1Id,
    required this.user2Id,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageTime,
    this.user1UnreadCount = 0,
    this.user2UnreadCount = 0,
    this.user1,
    this.user2,
    this.messages,
  });
  
  /// 从JSON创建模型
  factory ConversationModel.fromJson(Map<String, dynamic> json) => _$ConversationModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);

  /// 复制并更新字段
  ConversationModel copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? user1Id,
    int? user2Id,
    int? lastMessageId,
    String? lastMessageContent,
    DateTime? lastMessageTime,
    int? user1UnreadCount,
    int? user2UnreadCount,
    UserModel? user1,
    UserModel? user2,
    List<MessageModel>? messages,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      user1UnreadCount: user1UnreadCount ?? this.user1UnreadCount,
      user2UnreadCount: user2UnreadCount ?? this.user2UnreadCount,
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
      messages: messages ?? this.messages,
    );
  }
}