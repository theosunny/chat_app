import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class MessageService {
  final ApiService _apiService = ApiService();
  
  // 获取会话列表
  Future<Map<String, dynamic>> getConversations() async {
    try {
      final response = await _apiService.get('/messages/conversations');
      return response;
    } catch (e) {
      throw Exception('获取会话列表失败: $e');
    }
  }
  
  // 获取与特定用户的消息记录
  Future<Map<String, dynamic>> getMessages({
    required String userId,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _apiService.get(
        '/messages',
        queryParameters: {
          'user_id': userId,
          'page': page,
          'page_size': pageSize,
        },
      );
      return response;
    } catch (e) {
      throw Exception('获取消息记录失败: $e');
    }
  }
  
  // 发送消息
  Future<Map<String, dynamic>> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    try {
      final response = await _apiService.post(
        '/messages',
        {
          'receiver_id': receiverId,
          'content': content,
        },
      );
      return response;
    } catch (e) {
      throw Exception('发送消息失败: $e');
    }
  }
  
  // 获取通知消息
  Future<Map<String, dynamic>> getNotifications() async {
    try {
      final response = await _apiService.get('/notifications');
      return response;
    } catch (e) {
      throw Exception('获取通知消息失败: $e');
    }
  }
  
  // 标记消息为已读
  Future<Map<String, dynamic>> markAsRead(String conversationId) async {
    try {
      final response = await _apiService.post(
        '/conversations/$conversationId/read',
        {},
      );
      return response;
    } catch (e) {
      throw Exception('标记已读失败: $e');
    }
  }
  
  // 标记通知为已读
  Future<Map<String, dynamic>> markNotificationAsRead(String notificationId) async {
    try {
      final response = await _apiService.post(
        '/notifications/$notificationId/read',
        {},
      );
      return response;
    } catch (e) {
      throw Exception('标记通知已读失败: $e');
    }
  }
  
  // 删除会话
  Future<Map<String, dynamic>> deleteConversation(String conversationId) async {
    try {
      final response = await _apiService.delete('/conversations/$conversationId');
      return response;
    } catch (e) {
      throw Exception('删除会话失败: $e');
    }
  }
  
  // 删除消息
  Future<Map<String, dynamic>> deleteMessage(String messageId) async {
    try {
      final response = await _apiService.delete('/messages/$messageId');
      return response;
    } catch (e) {
      throw Exception('删除消息失败: $e');
    }
  }
  
  // 获取未读消息数量
  Future<Map<String, dynamic>> getUnreadCount() async {
    try {
      final response = await _apiService.get('/messages/unread-count');
      return response;
    } catch (e) {
      throw Exception('获取未读消息数量失败: $e');
    }
  }
  
  // 搜索消息
  Future<Map<String, dynamic>> searchMessages({
    required String keyword,
    String? userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '/messages/search',
        queryParameters: {
          'keyword': keyword,
          if (userId != null) 'user_id': userId,
          'page': page,
          'page_size': pageSize,
        },
      );
      return response;
    } catch (e) {
      throw Exception('搜索消息失败: $e');
    }
  }
  
  // 举报消息
  Future<Map<String, dynamic>> reportMessage({
    required String messageId,
    required String reason,
  }) async {
    try {
      final response = await _apiService.post(
        '/messages/$messageId/report',
        {'reason': reason},
      );
      return response;
    } catch (e) {
      throw Exception('举报消息失败: $e');
    }
  }
}