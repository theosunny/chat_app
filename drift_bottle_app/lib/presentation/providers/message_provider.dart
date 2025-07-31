import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart' hide MessageType;
import '../../data/models/message_model.dart';
import '../../data/models/conversation_model.dart';
import '../../domain/entities/message.dart';

import '../../domain/repositories/message_repository.dart';
import '../../core/services/chat_service.dart';

class MessageProvider extends ChangeNotifier {
  final MessageRepository _messageRepository;
  final ChatService _chatService = ChatService();
  
  MessageProvider(this._messageRepository);
  
  List<ConversationModel> _conversations = [];
  List<EMConversation> _emConversations = [];
  List<MessageModel> _messages = [];
  List<MessageModel> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;
  bool _isChatInitialized = false;
  
  List<ConversationModel> get conversations => _conversations;
  List<EMConversation> get emConversations => _emConversations;
  List<MessageModel> get messages => _messages;
  List<MessageModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;
  bool get isChatInitialized => _isChatInitialized;
  
  // 初始化聊天服务
  Future<void> initializeChatService() async {
    if (_isChatInitialized) return;
    
    try {
      await _chatService.initialize();
      _isChatInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('初始化聊天服务失败: $e');
    }
  }
  
  // 获取环信会话列表
  Future<void> fetchEMConversations() async {
    if (!_isChatInitialized) {
      await initializeChatService();
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _emConversations = await _chatService.getConversations();
      
      // 计算环信未读消息总数
      int emUnreadCount = 0;
      for (var conversation in _emConversations) {
        final count = await conversation.unreadCount();
        emUnreadCount += count;
      }
      
      // 合并原有未读数和环信未读数
      _unreadCount = _conversations
          .map((conv) => conv.unreadCount)
          .fold(0, (sum, count) => sum + count) + emUnreadCount;
          
    } catch (e) {
      debugPrint('获取环信会话列表失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 发送环信消息
  Future<void> sendEMMessage(String conversationId, String content, {EMConversationType chatType = EMConversationType.Chat}) async {
    try {
      await _chatService.sendTextMessage(
        toUserId: conversationId,
        content: content,
      );
      // 刷新会话列表
      await fetchEMConversations();
    } catch (e) {
      debugPrint('发送环信消息失败: $e');
      rethrow;
    }
  }
  
  // 标记环信消息为已读
  Future<void> markEMMessagesAsRead(String conversationId) async {
    try {
      await _chatService.markMessageAsRead(conversationId: conversationId);
      // 刷新会话列表
      await fetchEMConversations();
    } catch (e) {
      debugPrint('标记环信消息已读失败: $e');
    }
  }
  
  // 删除环信会话
  Future<void> deleteEMConversation(String conversationId) async {
    try {
      await _chatService.deleteConversation(conversationId: conversationId);
      _emConversations.removeWhere((conv) => conv.id == conversationId);
      notifyListeners();
    } catch (e) {
      debugPrint('删除环信会话失败: $e');
      rethrow;
    }
  }
  
  // 获取会话列表
  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _messageRepository.getConversations(
        limit: 50,
        offset: 0,
      );
      result.fold(
        (failure) {
          debugPrint('获取会话列表失败: ${failure.message}');
          _conversations = [];
        },
        (conversations) {
          _conversations = conversations
              .map((conversation) => ConversationModel.fromEntity(conversation))
              .toList();
          
          // 计算未读消息总数
          _unreadCount = _conversations
              .map((conv) => conv.unreadCount)
              .fold(0, (sum, count) => sum + count);
        },
      );
    } catch (e) {
      debugPrint('获取会话列表失败: $e');
      _conversations = [];
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
      final result = await _messageRepository.getMessages(
        conversationId: userId, // 使用userId作为conversationId
        limit: 50,
      );
      
      result.fold(
        (failure) {
          debugPrint('获取消息记录失败: ${failure.message}');
        },
        (messages) {
          final newMessages = messages
              .map((message) => MessageModel.fromEntityWithId(message))
              .toList();
          
          if (refresh) {
            _messages = newMessages;
          } else {
            _messages.addAll(newMessages);
          }
          
          // 按时间排序
          _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        },
      );
    } catch (e) {
      debugPrint('获取消息记录失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 发送消息
  Future<bool> sendMessage(String receiverId, String content) async {
    try {
      final result = await _messageRepository.sendMessage(
        conversationId: receiverId, // 使用receiverId作为conversationId
        content: content,
        type: MessageType.text,
      );
      
      return result.fold(
        (failure) {
          debugPrint('发送消息失败: ${failure.message}');
          return false;
        },
        (message) {
          final messageModel = MessageModel.fromEntityWithId(message);
          _messages.add(messageModel);
          
          // 更新会话列表
          final convIndex = _conversations.indexWhere(
            (conv) => conv.participants.any((p) => p.id == receiverId),
          );
          if (convIndex != -1) {
            _conversations[convIndex] = _conversations[convIndex].copyWith(
              lastMessage: messageModel,
              unreadCount: 0,
              updatedAt: messageModel.createdAt,
            );
          }
          
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('发送消息失败: $e');
      return false;
    }
  }
  
  // 获取通知消息
  Future<void> fetchNotifications() async {
    try {
      final result = await _messageRepository.getNotifications();
      result.fold(
        (failure) {
          debugPrint('获取通知消息失败: ${failure.message}');
        },
        (notifications) {
          _notifications = notifications
              .map((notification) => MessageModel.fromEntityWithId(notification))
              .toList();
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('获取通知消息失败: $e');
    }
  }
  
  // 标记消息为已读
  Future<void> markAsRead(String conversationId) async {
    try {
      final result = await _messageRepository.markAsRead(conversationId);
      result.fold(
        (failure) {
          debugPrint('标记已读失败: ${failure.message}');
        },
        (_) {
          // 更新本地会话的未读数
          final index = _conversations.indexWhere(
            (conv) => conv.id == conversationId,
          );
          if (index != -1) {
            final oldUnreadCount = _conversations[index].unreadCount;
            _conversations[index] = _conversations[index].copyWith(
              unreadCount: 0,
            );
            
            // 更新总未读数
            _unreadCount -= oldUnreadCount;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      debugPrint('标记已读失败: $e');
    }
  }
  
  // 标记通知为已读
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final result = await _messageRepository.markNotificationAsRead(notificationId);
      result.fold(
        (failure) {
          debugPrint('标记通知已读失败: ${failure.message}');
        },
        (_) {
          final index = _notifications.indexWhere(
            (notification) => notification.id == notificationId,
          );
          if (index != -1) {
            _notifications[index] = _notifications[index].copyWith(isRead: true);
            notifyListeners();
          }
        },
      );
    } catch (e) {
      debugPrint('标记通知已读失败: $e');
    }
  }
  
  // 删除会话
  Future<bool> deleteConversation(String conversationId) async {
    try {
      final result = await _messageRepository.deleteConversation(conversationId);
      return result.fold(
        (failure) {
          debugPrint('删除会话失败: ${failure.message}');
          return false;
        },
        (_) {
          _conversations.removeWhere((conv) => conv.id == conversationId);
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('删除会话失败: $e');
      return false;
    }
  }
  
  // 添加新消息（用于实时消息推送）
  void addNewMessage(MessageModel message) {
    _messages.add(message);
    
    // 更新会话列表
    final convIndex = _conversations.indexWhere(
      (conv) => conv.participants.any((p) => p.id == message.sender.id),
    );
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
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