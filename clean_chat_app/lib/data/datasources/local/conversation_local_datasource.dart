import 'package:hive/hive.dart';
import '../../models/conversation_model.dart';
import '../../../core/error/exceptions.dart';

/// 会话本地数据源接口
abstract class ConversationLocalDataSource {
  Future<void> saveConversation(ConversationModel conversation);
  Future<List<ConversationModel>> getConversations(int page, int limit);
  Future<void> saveConversations(List<ConversationModel> conversations);
  Future<void> clearConversations();
  Future<ConversationModel?> getConversationById(int conversationId);
  Future<ConversationModel?> getConversationByUserId(int otherUserId, int currentUserId);
  Future<void> updateConversation(ConversationModel conversation);
  Future<void> deleteConversation(int conversationId);
}

/// 会话本地数据源实现
class ConversationLocalDataSourceImpl implements ConversationLocalDataSource {
  final Box<Map<dynamic, dynamic>> conversationBox;

  const ConversationLocalDataSourceImpl({
    required this.conversationBox,
  });

  @override
  Future<void> saveConversation(ConversationModel conversation) async {
    try {
      await conversationBox.put(conversation.id.toString(), conversation.toJson());
    } catch (e) {
      throw CacheException('保存会话失败: $e');
    }
  }

  @override
  Future<List<ConversationModel>> getConversations(int page, int limit) async {
    try {
      final allConversations = <ConversationModel>[];
      
      // 遍历所有会话
      for (final key in conversationBox.keys) {
        final conversationData = conversationBox.get(key);
        if (conversationData != null) {
          final conversation = ConversationModel.fromJson(Map<String, dynamic>.from(conversationData));
          allConversations.add(conversation);
        }
      }
      
      // 按最后消息时间倒序排列
      allConversations.sort((a, b) {
        final aTime = a.lastMessageTime ?? a.updatedAt;
        final bTime = b.lastMessageTime ?? b.updatedAt;
        return bTime.compareTo(aTime);
      });
      
      // 分页处理
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      
      if (startIndex >= allConversations.length) {
        return [];
      }
      
      return allConversations.sublist(
        startIndex,
        endIndex > allConversations.length ? allConversations.length : endIndex,
      );
    } catch (e) {
      throw CacheException('获取会话列表失败: $e');
    }
  }

  @override
  Future<void> saveConversations(List<ConversationModel> conversations) async {
    try {
      for (final conversation in conversations) {
        await conversationBox.put(conversation.id.toString(), conversation.toJson());
      }
    } catch (e) {
      throw CacheException('批量保存会话失败: $e');
    }
  }

  @override
  Future<void> clearConversations() async {
    try {
      await conversationBox.clear();
    } catch (e) {
      throw CacheException('清除会话数据失败: $e');
    }
  }

  @override
  Future<ConversationModel?> getConversationById(int conversationId) async {
    try {
      final conversationData = conversationBox.get(conversationId.toString());
      if (conversationData != null) {
        return ConversationModel.fromJson(Map<String, dynamic>.from(conversationData));
      }
      return null;
    } catch (e) {
      throw CacheException('获取会话失败: $e');
    }
  }

  @override
  Future<ConversationModel?> getConversationByUserId(int otherUserId, int currentUserId) async {
    try {
      // 遍历所有会话，找到包含指定用户的会话
      for (final key in conversationBox.keys) {
        final conversationData = conversationBox.get(key);
        if (conversationData != null) {
          final conversation = ConversationModel.fromJson(Map<String, dynamic>.from(conversationData));
          
          // 检查会话是否包含当前用户和目标用户
          if ((conversation.user1Id == currentUserId && conversation.user2Id == otherUserId) ||
              (conversation.user1Id == otherUserId && conversation.user2Id == currentUserId)) {
            return conversation;
          }
        }
      }
      return null;
    } catch (e) {
      throw CacheException('根据用户ID获取会话失败: $e');
    }
  }

  @override
  Future<void> updateConversation(ConversationModel conversation) async {
    try {
      await conversationBox.put(conversation.id.toString(), conversation.toJson());
    } catch (e) {
      throw CacheException('更新会话失败: $e');
    }
  }

  @override
  Future<void> deleteConversation(int conversationId) async {
    try {
      await conversationBox.delete(conversationId.toString());
    } catch (e) {
      throw CacheException('删除会话失败: $e');
    }
  }
}