import 'package:hive/hive.dart';
import '../../models/message_model.dart';
import '../../../core/error/exceptions.dart';

/// 消息本地数据源接口
abstract class MessageLocalDataSource {
  Future<void> saveMessage(MessageModel message);
  Future<List<MessageModel>> getMessages(int conversationId, int page, int limit);
  Future<void> saveMessages(List<MessageModel> messages);
  Future<void> clearMessages(int conversationId);
  Future<void> clearAllMessages();
  Future<MessageModel?> getMessageById(int messageId);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteMessage(int messageId);
}

/// 消息本地数据源实现
class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  final Box<Map<dynamic, dynamic>> messageBox;

  const MessageLocalDataSourceImpl({
    required this.messageBox,
  });

  @override
  Future<void> saveMessage(MessageModel message) async {
    try {
      await messageBox.put(message.id.toString(), message.toJson());
    } catch (e) {
      throw CacheException('保存消息失败: $e');
    }
  }

  @override
  Future<List<MessageModel>> getMessages(int conversationId, int page, int limit) async {
    try {
      final allMessages = <MessageModel>[];
      
      // 遍历所有消息，筛选出指定会话的消息
      for (final key in messageBox.keys) {
        final messageData = messageBox.get(key);
        if (messageData != null) {
          final message = MessageModel.fromJson(Map<String, dynamic>.from(messageData));
          if (message.conversationId == conversationId) {
            allMessages.add(message);
          }
        }
      }
      
      // 按创建时间倒序排列
      allMessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // 分页处理
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      
      if (startIndex >= allMessages.length) {
        return [];
      }
      
      return allMessages.sublist(
        startIndex,
        endIndex > allMessages.length ? allMessages.length : endIndex,
      );
    } catch (e) {
      throw CacheException('获取消息列表失败: $e');
    }
  }

  @override
  Future<void> saveMessages(List<MessageModel> messages) async {
    try {
      for (final message in messages) {
        await messageBox.put(message.id.toString(), message.toJson());
      }
    } catch (e) {
      throw CacheException('批量保存消息失败: $e');
    }
  }

  @override
  Future<void> clearMessages(int conversationId) async {
    try {
      final keysToDelete = <String>[];
      
      // 找出指定会话的所有消息键
      for (final key in messageBox.keys) {
        final messageData = messageBox.get(key);
        if (messageData != null) {
          final message = MessageModel.fromJson(Map<String, dynamic>.from(messageData));
          if (message.conversationId == conversationId) {
            keysToDelete.add(key.toString());
          }
        }
      }
      
      // 删除消息
      for (final key in keysToDelete) {
        await messageBox.delete(key);
      }
    } catch (e) {
      throw CacheException('清除会话消息失败: $e');
    }
  }

  @override
  Future<void> clearAllMessages() async {
    try {
      await messageBox.clear();
    } catch (e) {
      throw CacheException('清除所有消息失败: $e');
    }
  }

  @override
  Future<MessageModel?> getMessageById(int messageId) async {
    try {
      final messageData = messageBox.get(messageId.toString());
      if (messageData != null) {
        return MessageModel.fromJson(Map<String, dynamic>.from(messageData));
      }
      return null;
    } catch (e) {
      throw CacheException('获取消息失败: $e');
    }
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    try {
      await messageBox.put(message.id.toString(), message.toJson());
    } catch (e) {
      throw CacheException('更新消息失败: $e');
    }
  }

  @override
  Future<void> deleteMessage(int messageId) async {
    try {
      await messageBox.delete(messageId.toString());
    } catch (e) {
      throw CacheException('删除消息失败: $e');
    }
  }
}