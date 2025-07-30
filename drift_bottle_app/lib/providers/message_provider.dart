import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/message_service.dart';

class MessageProvider extends ChangeNotifier {
  final MessageService _messageService = MessageService();
  
  List<ConversationModel> _conversations = [];
  List<MessageModel> _messages = [];
  List<MessageModel> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;
  
  List<ConversationModel> get conversations => _conversations;
  List<MessageModel> get messages => _messages;
  List<MessageModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;
  
  // 获取会话列表
  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _messageService.getConversations();
      if (result['success']) {
        final data = result['data'];
        if (data != null && data is List) {
          _conversations = data
              .map((json) => ConversationModel.fromJson(json))
              .toList();
        } else {
          _conversations = [];
        }
        
        // 计算未读消息总数
        _unreadCount = _conversations
            .map((conv) => conv.unreadCount)
            .fold(0, (sum, count) => sum + count);
      }
    } catch (e) {
      debugPrint('获取会话列表失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 获取与特定用户的消息记录
  Future<void> fetchMessages(String userId, {bool refresh = false}) async {
    if (refresh) {
      _messages.clear();
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _messageService.getMessages(
        userId: userId,
        page: 1,
        pageSize: 50,
      );
      
      if (result['success']) {
        final newMessages = (result['data'] as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();
        
        if (refresh) {
          _messages = newMessages;
        } else {
          _messages.addAll(newMessages);
        }
        
        // 按时间排序
        _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }
    } catch (e) {
      debugPrint('获取消息记录失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 发送消息
  Future<bool> sendMessage(String receiverId, String content) async {
    try {
      final result = await _messageService.sendMessage(
        receiverId: receiverId,
        content: content,
      );
      
      if (result['success']) {
        final message = MessageModel.fromJson(result['data']);
        _messages.add(message);
        
        // 更新会话列表
        final convIndex = _conversations.indexWhere(
          (conv) => conv.otherUser.id == receiverId,
        );
        if (convIndex != -1) {
          _conversations[convIndex] = ConversationModel(
            id: _conversations[convIndex].id,
            otherUser: _conversations[convIndex].otherUser,
            lastMessage: message,
            unreadCount: 0,
            updatedAt: message.createdAt,
          );
        }
        
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('发送消息失败: $e');
    }
    return false;
  }
  
  // 获取通知消息
  Future<void> fetchNotifications() async {
    try {
      final result = await _messageService.getNotifications();
      if (result['success']) {
        _notifications = (result['data'] as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('获取通知消息失败: $e');
    }
  }
  
  // 标记消息为已读
  Future<void> markAsRead(String conversationId) async {
    try {
      final result = await _messageService.markAsRead(conversationId);
      if (result['success']) {
        // 更新本地会话的未读数
        final index = _conversations.indexWhere(
          (conv) => conv.id == conversationId,
        );
        if (index != -1) {
          final oldUnreadCount = _conversations[index].unreadCount;
          _conversations[index] = ConversationModel(
            id: _conversations[index].id,
            otherUser: _conversations[index].otherUser,
            lastMessage: _conversations[index].lastMessage,
            unreadCount: 0,
            updatedAt: _conversations[index].updatedAt,
          );
          
          // 更新总未读数
          _unreadCount -= oldUnreadCount;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('标记已读失败: $e');
    }
  }
  
  // 标记通知为已读
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final result = await _messageService.markNotificationAsRead(notificationId);
      if (result['success']) {
        final index = _notifications.indexWhere(
          (notification) => notification.id == notificationId,
        );
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('标记通知已读失败: $e');
    }
  }
  
  // 删除会话
  Future<bool> deleteConversation(String conversationId) async {
    try {
      final result = await _messageService.deleteConversation(conversationId);
      if (result['success']) {
        _conversations.removeWhere((conv) => conv.id == conversationId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('删除会话失败: $e');
    }
    return false;
  }
  
  // 添加新消息（用于实时消息推送）
  void addNewMessage(MessageModel message) {
    _messages.add(message);
    
    // 更新会话列表
    final convIndex = _conversations.indexWhere(
      (conv) => conv.otherUser.id == message.sender.id,
    );
    if (convIndex != -1) {
      _conversations[convIndex] = ConversationModel(
        id: _conversations[convIndex].id,
        otherUser: _conversations[convIndex].otherUser,
        lastMessage: message,
        unreadCount: _conversations[convIndex].unreadCount + 1,
        updatedAt: message.createdAt,
      );
      _unreadCount++;
    }
    
    notifyListeners();
  }
  
  // 清空消息
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
  
  // 清空所有数据
  void clearAll() {
    _conversations.clear();
    _messages.clear();
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }
}