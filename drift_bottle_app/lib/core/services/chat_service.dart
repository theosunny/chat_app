import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:flutter/foundation.dart';

/// 基于环信IM的聊天服务
class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  bool _isInitialized = false;
  final List<EMChatEventHandler> _messageListeners = [];
  final List<EMContactEventHandler> _contactListeners = [];
  final List<EMGroupEventHandler> _groupListeners = [];

  /// 初始化聊天服务
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // 添加消息监听器
    EMClient.getInstance.chatManager.addEventHandler(
      'CHAT_SERVICE_MESSAGE',
      _ChatMessageHandler(),
    );
    
    // 添加联系人监听器
    EMClient.getInstance.contactManager.addEventHandler(
      'CHAT_SERVICE_CONTACT',
      _ChatContactHandler(),
    );
    
    // 添加群组监听器
    EMClient.getInstance.groupManager.addEventHandler(
      'CHAT_SERVICE_GROUP',
      _ChatGroupHandler(),
    );
    
    _isInitialized = true;
  }

  /// 发送文本消息
  Future<EMMessage> sendTextMessage({
    required String toUserId,
    required String content,
    ChatType chatType = ChatType.Chat,
  }) async {
    final message = EMMessage.createTxtSendMessage(
      targetId: toUserId,
      content: content,
      chatType: chatType,
    );
    
    await EMClient.getInstance.chatManager.sendMessage(message);
    return message;
  }

  /// 发送图片消息
  Future<EMMessage> sendImageMessage({
    required String toUserId,
    required String imagePath,
    ChatType chatType = ChatType.Chat,
  }) async {
    final message = EMMessage.createImageSendMessage(
      targetId: toUserId,
      filePath: imagePath,
      chatType: chatType,
    );
    
    await EMClient.getInstance.chatManager.sendMessage(message);
    return message;
  }

  /// 发送语音消息
  Future<EMMessage> sendVoiceMessage({
    required String toUserId,
    required String voicePath,
    required int duration,
    ChatType chatType = ChatType.Chat,
  }) async {
    final message = EMMessage.createVoiceSendMessage(
      targetId: toUserId,
      filePath: voicePath,
      duration: duration,
      chatType: chatType,
    );
    
    await EMClient.getInstance.chatManager.sendMessage(message);
    return message;
  }

  /// 发送视频消息
  Future<EMMessage> sendVideoMessage({
    required String toUserId,
    required String videoPath,
    required int duration,
    String? thumbnailPath,
    ChatType chatType = ChatType.Chat,
  }) async {
    final message = EMMessage.createVideoSendMessage(
      targetId: toUserId,
      filePath: videoPath,
      duration: duration,
      thumbnailLocalPath: thumbnailPath,
      chatType: chatType,
    );
    
    await EMClient.getInstance.chatManager.sendMessage(message);
    return message;
  }

  /// 发送文件消息
  Future<EMMessage> sendFileMessage({
    required String toUserId,
    required String filePath,
    ChatType chatType = ChatType.Chat,
  }) async {
    final message = EMMessage.createFileSendMessage(
      targetId: toUserId,
      filePath: filePath,
      chatType: chatType,
    );
    
    await EMClient.getInstance.chatManager.sendMessage(message);
    return message;
  }

  /// 发送位置消息
  Future<EMMessage> sendLocationMessage({
    required String toUserId,
    required double latitude,
    required double longitude,
    required String address,
    ChatType chatType = ChatType.Chat,
  }) async {
    final message = EMMessage.createLocationSendMessage(
      targetId: toUserId,
      latitude: latitude,
      longitude: longitude,
      address: address,
      chatType: chatType,
    );
    
    await EMClient.getInstance.chatManager.sendMessage(message);
    return message;
  }

  /// 发送自定义消息
  Future<EMMessage> sendCustomMessage({
    required String toUserId,
    required String event,
    Map<String, String>? params,
    ChatType chatType = ChatType.Chat,
  }) async {
    final message = EMMessage.createCustomSendMessage(
      targetId: toUserId,
      event: event,
      params: params,
      chatType: chatType,
    );
    
    await EMClient.getInstance.chatManager.sendMessage(message);
    return message;
  }

  /// 获取会话列表
  Future<List<EMConversation>> getConversations() async {
    return await EMClient.getInstance.chatManager.loadAllConversations();
  }

  /// 获取指定会话
  Future<EMConversation?> getConversation({
    required String conversationId,
    EMConversationType type = EMConversationType.Chat,
  }) async {
    return await EMClient.getInstance.chatManager.getConversation(
      conversationId,
      type: type,
    );
  }

  /// 获取历史消息
  Future<List<EMMessage>> getMessages({
    required String conversationId,
    EMConversationType type = EMConversationType.Chat,
    String? startMsgId,
    int count = 20,
    EMSearchDirection direction = EMSearchDirection.Up,
  }) async {
    final conversation = await EMClient.getInstance.chatManager.getConversation(
      conversationId,
      type: type,
      createIfNeed: true,
    );
    
    if (conversation == null) {
      return [];
    }
    
    return await conversation.loadMessages(
      startMsgId: startMsgId ?? '',
      loadCount: count,
      direction: direction,
    ) ?? [];
  }

  /// 标记消息为已读
  Future<void> markMessageAsRead({
    required String conversationId,
    EMConversationType type = EMConversationType.Chat,
  }) async {
    final conversation = await getConversation(
      conversationId: conversationId,
      type: type,
    );
    
    if (conversation != null) {
      await conversation.markAllMessagesAsRead();
    }
  }

  /// 删除消息
  Future<void> deleteMessage(String messageId, String conversationId) async {
    final conversation = await getConversation(conversationId: conversationId);
    await conversation?.deleteMessage(messageId);
  }

  /// 删除会话
  Future<void> deleteConversation({
    required String conversationId,
    bool deleteMessages = true,
  }) async {
    await EMClient.getInstance.chatManager.deleteConversation(
      conversationId,
      deleteMessages: deleteMessages,
    );
  }

  /// 撤回消息
  Future<void> recallMessage(String messageId) async {
    await EMClient.getInstance.chatManager.recallMessage(messageId);
  }

  /// 搜索消息
  Future<List<EMMessage>> searchMessages({
    required String keyword,
    String? conversationId,
    int maxCount = 20,
    int? startTime,
    int? endTime,
  }) async {
    return await EMClient.getInstance.chatManager.searchMsgFromDB(
      keyword,
      maxCount: maxCount,
    );
  }

  /// 获取未读消息数
  Future<int> getUnreadMessageCount() async {
    return await EMClient.getInstance.chatManager.getUnreadMessageCount();
  }

  /// 获取指定会话的未读消息数
  Future<Object?> getConversationUnreadCount(String conversationId) async {
    try {
      final conversation = await getConversation(conversationId: conversationId);
      return conversation?.unreadCount;
    } catch (e) {
      debugPrint('获取会话未读消息数失败: $e');
      return 0;
    }
  }

  /// 添加消息监听器
  void addMessageListener(EMChatEventHandler listener) {
    _messageListeners.add(listener);
    EMClient.getInstance.chatManager.addEventHandler(
      'LISTENER_${listener.hashCode}',
      listener,
    );
  }

  /// 移除消息监听器
  void removeMessageListener(EMChatEventHandler listener) {
    _messageListeners.remove(listener);
    EMClient.getInstance.chatManager.removeEventHandler(
      'LISTENER_${listener.hashCode}',
    );
  }

  /// 添加联系人监听器
  void addContactListener(EMContactEventHandler listener) {
    _contactListeners.add(listener);
    EMClient.getInstance.contactManager.addEventHandler(
      'CONTACT_LISTENER_${listener.hashCode}',
      listener,
    );
  }

  /// 移除联系人监听器
  void removeContactListener(EMContactEventHandler listener) {
    _contactListeners.remove(listener);
    EMClient.getInstance.contactManager.removeEventHandler(
      'CONTACT_LISTENER_${listener.hashCode}',
    );
  }

  /// 添加群组监听器
  void addGroupListener(EMGroupEventHandler listener) {
    _groupListeners.add(listener);
    EMClient.getInstance.groupManager.addEventHandler(
      'GROUP_LISTENER_${listener.hashCode}',
      listener,
    );
  }

  /// 移除群组监听器
  void removeGroupListener(EMGroupEventHandler listener) {
    _groupListeners.remove(listener);
    EMClient.getInstance.groupManager.removeEventHandler(
      'GROUP_LISTENER_${listener.hashCode}',
    );
  }

  /// 清理资源
  void dispose() {
    EMClient.getInstance.chatManager.removeEventHandler('CHAT_SERVICE_MESSAGE');
    EMClient.getInstance.contactManager.removeEventHandler('CHAT_SERVICE_CONTACT');
    EMClient.getInstance.groupManager.removeEventHandler('CHAT_SERVICE_GROUP');
    
    for (final listener in _messageListeners) {
      EMClient.getInstance.chatManager.removeEventHandler(
        'LISTENER_${listener.hashCode}',
      );
    }
    
    for (final listener in _contactListeners) {
      EMClient.getInstance.contactManager.removeEventHandler(
        'CONTACT_LISTENER_${listener.hashCode}',
      );
    }
    
    for (final listener in _groupListeners) {
      EMClient.getInstance.groupManager.removeEventHandler(
        'GROUP_LISTENER_${listener.hashCode}',
      );
    }
    
    _messageListeners.clear();
    _contactListeners.clear();
    _groupListeners.clear();
    
    _isInitialized = false;
  }
}

/// 消息事件处理器
class _ChatMessageHandler implements EMChatEventHandler {
  @override
  void Function(List<EMMessage> messages)? get onMessagesReceived => (messages) {
    debugPrint('收到消息: ${messages.length}条');
    // 这里可以添加全局消息处理逻辑
  };

  @override
  void Function(List<EMMessage> messages)? get onMessagesRead => (messages) {
    debugPrint('消息已读: ${messages.length}条');
  };

  @override
  void Function(List<EMMessage> messages)? get onMessagesDelivered => (messages) {
    debugPrint('消息已送达: ${messages.length}条');
  };

  @override
  void Function(List<EMMessage> messages)? get onMessagesRecalled => (messages) {
    debugPrint('消息被撤回: ${messages.length}条');
  };

  @override
  void Function()? get onConversationsUpdate => () {
    debugPrint('会话列表更新');
  };

  @override
  void Function(String from, String to)? get onConversationRead => (from, to) {
    debugPrint('会话已读: $from -> $to');
  };

  @override
  void Function(List<EMMessage> messages)? get onCmdMessagesReceived => null;

  @override
  void Function(List<EMGroupMessageAck>)? get onGroupMessageRead => null;

  @override
  void Function(List<EMMessageReactionEvent>)? get onMessageReactionDidChange => null;

  @override
  void Function()? get onReadAckForGroupMessageUpdated => null;
}

/// 联系人事件处理器
class _ChatContactHandler implements EMContactEventHandler {
  @override
  void Function(String userId)? get onContactAdded => (userId) {
    debugPrint('添加联系人: $userId');
  };

  @override
  void Function(String userId)? get onContactDeleted => (userId) {
    debugPrint('删除联系人: $userId');
  };

  @override
  void Function(String userId, String? reason)? get onContactInvited => (userId, reason) {
    debugPrint('收到好友请求: $userId, 原因: $reason');
  };

  @override
  void Function(String userId)? get onFriendRequestAccepted => (userId) {
    debugPrint('好友请求被接受: $userId');
  };

  @override
  void Function(String userId)? get onFriendRequestDeclined => (userId) {
    debugPrint('好友请求被拒绝: $userId');
  };
}

/// 群组事件处理器
class _ChatGroupHandler extends EMGroupEventHandler {
  @override
  void Function(String groupId, String groupName, String inviter, String reason)? get onInvitationReceived => (groupId, groupName, inviter, reason) {
    debugPrint('收到群组邀请: $groupName ($groupId), 邀请人: $inviter');
  };

  @override
  void Function(String groupId, String groupName, String applicant, String reason)? get onRequestToJoinReceived => (groupId, groupName, applicant, reason) {
    debugPrint('收到入群申请: $groupName ($groupId), 申请人: $applicant');
  };

  @override
  void Function(String groupId, String groupName, String accepter)? get onRequestToJoinAccepted => (groupId, groupName, accepter) {
    debugPrint('入群申请被接受: $groupName ($groupId), 接受人: $accepter');
  };

  @override
  void Function(String groupId, String groupName, String decliner, String reason)? get onRequestToJoinDeclined => (groupId, groupName, decliner, reason) {
    debugPrint('入群申请被拒绝: $groupName ($groupId), 拒绝人: $decliner');
  };

  @override
  void Function(String groupId, String invitee, String reason)? get onInvitationAccepted => (groupId, invitee, reason) {
    debugPrint('群组邀请被接受: $groupId, 被邀请人: $invitee');
  };

  @override
  void Function(String groupId, String invitee, String reason)? get onInvitationDeclined => (groupId, invitee, reason) {
    debugPrint('群组邀请被拒绝: $groupId, 被邀请人: $invitee');
  };

  @override
  void Function(String groupId, String groupName)? get onUserRemoved => (groupId, groupName) {
    debugPrint('被移出群组: $groupName ($groupId)');
  };

  @override
  void Function(String groupId, String? groupName)? get onGroupDestroyed => (groupId, groupName) {
    debugPrint('群组被解散: $groupName ($groupId)');
  };

  @override
  void Function(String groupId, String inviter, String? inviteMessage)? get onAutoAcceptInvitationFromGroup => (groupId, inviter, inviteMessage) {
    debugPrint('自动接受群组邀请: $groupId, 邀请人: $inviter');
  };

  @override
  void Function(String groupId, List<String> mutes, int muteExpire)? get onMuteListAdded => (groupId, mutes, muteExpire) {
    debugPrint('群组禁言列表更新: $groupId, 禁言用户: $mutes');
  };

  @override
  void Function(String groupId, List<String> mutes)? get onMuteListRemoved => (groupId, mutes) {
    debugPrint('群组解除禁言: $groupId, 解禁用户: $mutes');
  };

  @override
  void Function(String groupId, String administrator)? get onAdminAdded => (groupId, administrator) {
    debugPrint('群组添加管理员: $groupId, 管理员: $administrator');
  };

  @override
  void Function(String groupId, String administrator)? get onAdminRemoved => (groupId, administrator) {
    debugPrint('群组移除管理员: $groupId, 管理员: $administrator');
  };

  @override
  void Function(String groupId, String newOwner, String oldOwner)? get onOwnerChanged => (groupId, newOwner, oldOwner) {
    debugPrint('群组转让: $groupId, 新群主: $newOwner, 原群主: $oldOwner');
  };

  @override
  void Function(String groupId, String member)? get onMemberJoined => (groupId, member) {
    debugPrint('新成员加入群组: $groupId, 成员: $member');
  };

  @override
  void Function(String groupId, String member)? get onMemberExited => (groupId, member) {
    debugPrint('成员退出群组: $groupId, 成员: $member');
  };

  @override
  void Function(String groupId, String announcement)? get onAnnouncementChanged => (groupId, announcement) {
    debugPrint('群组公告更新: $groupId, 公告: $announcement');
  };

  @override
  void Function(String groupId, EMGroupSharedFile sharedFile)? get onSharedFileAdded => (groupId, sharedFile) {
    debugPrint('群组添加共享文件: $groupId, 文件: ${sharedFile.fileName}');
  };

  @override
  void Function(String groupId, String fileId)? get onSharedFileDeleted => (groupId, fileId) {
    debugPrint('群组删除共享文件: $groupId, 文件ID: $fileId');
  };
}