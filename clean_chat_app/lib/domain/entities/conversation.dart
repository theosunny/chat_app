import 'package:equatable/equatable.dart';
import 'user.dart';
import 'message.dart';

/// 会话实体
class Conversation extends Equatable {
  final int id;
  final int user1Id;
  final int user2Id;
  final int? lastMessageId;
  final String? lastMessageContent;
  final DateTime? lastMessageTime;
  final int user1UnreadCount;
  final int user2UnreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user1;
  final User? user2;
  final List<Message>? messages;

  const Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageTime,
    this.user1UnreadCount = 0,
    this.user2UnreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.user1,
    this.user2,
    this.messages,
  });

  /// 获取对方用户（相对于当前用户）
  User? getOtherUser(int currentUserId) {
    if (currentUserId == user1Id) {
      return user2;
    } else if (currentUserId == user2Id) {
      return user1;
    }
    return null;
  }

  /// 获取当前用户的未读消息数
  int getUnreadCount(int currentUserId) {
    if (currentUserId == user1Id) {
      return user1UnreadCount;
    } else if (currentUserId == user2Id) {
      return user2UnreadCount;
    }
    return 0;
  }

  /// 是否有未读消息
  bool hasUnreadMessages(int currentUserId) {
    return getUnreadCount(currentUserId) > 0;
  }

  /// 获取会话标题（对方用户名）
  String getTitle(int currentUserId) {
    final otherUser = getOtherUser(currentUserId);
    return otherUser?.displayName ?? '未知用户';
  }

  /// 获取会话头像（对方用户头像）
  String? getAvatar(int currentUserId) {
    final otherUser = getOtherUser(currentUserId);
    return otherUser?.avatar;
  }

  /// 复制并更新字段
  Conversation copyWith({
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
    List<Message>? messages,
  }) {
    return Conversation(
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
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        lastMessageId,
        lastMessageContent,
        lastMessageTime,
        user1UnreadCount,
        user2UnreadCount,
        createdAt,
        updatedAt,
        user1,
        user2,
        messages,
      ];

  @override
  String toString() {
    return 'Conversation(id: $id, user1Id: $user1Id, user2Id: $user2Id, lastMessageContent: $lastMessageContent)';
  }
}