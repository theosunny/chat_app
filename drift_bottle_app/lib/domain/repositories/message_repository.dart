import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

/// 消息仓库接口
abstract class MessageRepository {
  /// 发送消息
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String content,
    required MessageType type,
    MessageMedia? media,
    String? replyToMessageId,
    List<String>? mentionedUserIds,
  });
  
  /// 发送文本消息
  Future<Either<Failure, Message>> sendTextMessage({
    required String conversationId,
    required String content,
    String? replyToMessageId,
    List<String>? mentionedUserIds,
  });
  
  /// 发送图片消息
  Future<Either<Failure, Message>> sendImageMessage({
    required String conversationId,
    required String imagePath,
    String? caption,
    String? replyToMessageId,
  });
  
  /// 发送语音消息
  Future<Either<Failure, Message>> sendAudioMessage({
    required String conversationId,
    required String audioPath,
    required int duration,
    String? replyToMessageId,
  });
  
  /// 发送视频消息
  Future<Either<Failure, Message>> sendVideoMessage({
    required String conversationId,
    required String videoPath,
    String? thumbnailPath,
    int? duration,
    String? replyToMessageId,
  });
  
  /// 发送文件消息
  Future<Either<Failure, Message>> sendFileMessage({
    required String conversationId,
    required String filePath,
    String? fileName,
    String? replyToMessageId,
  });
  
  /// 发送位置消息
  Future<Either<Failure, Message>> sendLocationMessage({
    required String conversationId,
    required double latitude,
    required double longitude,
    String? address,
    String? replyToMessageId,
  });
  
  /// 转发消息
  Future<Either<Failure, Message>> forwardMessage({
    required String conversationId,
    required String messageId,
  });
  
  /// 撤回消息
  Future<Either<Failure, void>> recallMessage(String messageId);
  
  /// 删除消息
  Future<Either<Failure, void>> deleteMessage({
    required String messageId,
    bool deleteForEveryone = false,
  });
  
  /// 标记消息为已读
  Future<Either<Failure, void>> markMessageAsRead(String messageId);
  
  /// 标记会话消息为已读
  Future<Either<Failure, void>> markConversationAsRead(String conversationId);
  
  /// 标记消息为已读（简化版）
  Future<Either<Failure, void>> markAsRead(String conversationId);
  
  /// 获取通知消息
  Future<Either<Failure, List<Message>>> getNotifications();
  
  /// 标记通知为已读
  Future<Either<Failure, void>> markNotificationAsRead(String notificationId);
  
  /// 获取会话消息列表
  Future<Either<Failure, List<Message>>> getMessages({
    required String conversationId,
    int? limit,
    String? beforeMessageId,
    String? afterMessageId,
  });
  
  /// 获取消息详情
  Future<Either<Failure, Message>> getMessageDetail(String messageId);
  
  /// 搜索消息
  Future<Either<Failure, List<Message>>> searchMessages({
    required String keyword,
    String? conversationId,
    MessageType? type,
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
    int? offset,
  });
  
  /// 获取会话列表
  Future<Either<Failure, List<Conversation>>> getConversations({
    int? limit,
    int? offset,
    ConversationType? type,
  });
  
  /// 获取会话详情
  Future<Either<Failure, Conversation>> getConversationDetail(String conversationId);
  
  /// 创建单聊会话
  Future<Either<Failure, Conversation>> createSingleConversation(String userId);
  
  /// 创建群聊会话
  Future<Either<Failure, Conversation>> createGroupConversation({
    required String name,
    required List<String> userIds,
    String? avatar,
    String? description,
  });
  
  /// 更新会话信息
  Future<Either<Failure, Conversation>> updateConversation({
    required String conversationId,
    String? name,
    String? avatar,
    String? description,
  });
  
  /// 删除会话
  Future<Either<Failure, void>> deleteConversation(String conversationId);
  
  /// 置顶会话
  Future<Either<Failure, void>> pinConversation(String conversationId);
  
  /// 取消置顶会话
  Future<Either<Failure, void>> unpinConversation(String conversationId);
  
  /// 设置会话免打扰
  Future<Either<Failure, void>> muteConversation(String conversationId);
  
  /// 取消会话免打扰
  Future<Either<Failure, void>> unmuteConversation(String conversationId);
  
  /// 拉黑会话
  Future<Either<Failure, void>> blockConversation(String conversationId);
  
  /// 取消拉黑会话
  Future<Either<Failure, void>> unblockConversation(String conversationId);
  
  /// 保存草稿
  Future<Either<Failure, void>> saveDraft({
    required String conversationId,
    required String content,
  });
  
  /// 清除草稿
  Future<Either<Failure, void>> clearDraft(String conversationId);
  
  /// 获取草稿
  Future<Either<Failure, String?>> getDraft(String conversationId);
  
  /// 上传媒体文件
  Future<Either<Failure, MessageMedia>> uploadMedia({
    required String filePath,
    required MediaType type,
    Function(double progress)? onProgress,
  });
  
  /// 下载媒体文件
  Future<Either<Failure, String>> downloadMedia({
    required String mediaId,
    required String url,
    Function(double progress)? onProgress,
  });
  
  /// 获取未读消息数
  Future<Either<Failure, int>> getUnreadCount({
    String? conversationId,
    ConversationType? type,
  });
  
  /// 获取会话未读数
  Future<Either<Failure, Map<String, int>>> getConversationUnreadCounts();
  
  /// 清除所有未读数
  Future<Either<Failure, void>> clearAllUnreadCounts();
  
  /// 重发失败消息
  Future<Either<Failure, Message>> resendMessage(String messageId);
  
  /// 获取消息发送状态
  Future<Either<Failure, MessageStatus>> getMessageStatus(String messageId);
  
  /// 获取在线用户列表
  Future<Either<Failure, List<User>>> getOnlineUsers();
  
  /// 获取用户在线状态
  Future<Either<Failure, UserOnlineStatus>> getUserOnlineStatus(String userId);
  
  /// 更新在线状态
  Future<Either<Failure, void>> updateOnlineStatus(UserOnlineStatus status);
  
  /// 发送正在输入状态
  Future<Either<Failure, void>> sendTypingStatus({
    required String conversationId,
    required bool isTyping,
  });
  
  /// 监听消息变化
  Stream<Message> get messageStream;
  
  /// 监听会话变化
  Stream<Conversation> get conversationStream;
  
  /// 监听未读数变化
  Stream<Map<String, int>> get unreadCountStream;
  
  /// 监听在线状态变化
  Stream<Map<String, UserOnlineStatus>> get onlineStatusStream;
  
  /// 监听正在输入状态
  Stream<Map<String, bool>> get typingStatusStream;
  
  /// 监听连接状态
  Stream<ConnectionStatus> get connectionStatusStream;
  
  /// 连接IM服务
  Future<Either<Failure, void>> connect();
  
  /// 断开IM服务
  Future<Either<Failure, void>> disconnect();
  
  /// 重连IM服务
  Future<Either<Failure, void>> reconnect();
  
  /// 获取连接状态
  Future<ConnectionStatus> getConnectionStatus();
  
  /// 同步离线消息
  Future<Either<Failure, List<Message>>> syncOfflineMessages();
  
  /// 同步会话列表
  Future<Either<Failure, List<Conversation>>> syncConversations();
  
  /// 清除本地消息数据
  Future<Either<Failure, void>> clearLocalData();
  
  /// 导出聊天记录
  Future<Either<Failure, String>> exportChatHistory({
    required String conversationId,
    DateTime? startTime,
    DateTime? endTime,
    String? format, // 'txt', 'json', 'html'
  });
  
  /// 导入聊天记录
  Future<Either<Failure, void>> importChatHistory({
    required String filePath,
    required String conversationId,
  });
}

/// 连接状态枚举
enum ConnectionStatus {
  /// 已连接
  connected,
  
  /// 连接中
  connecting,
  
  /// 已断开
  disconnected,
  
  /// 重连中
  reconnecting,
  
  /// 连接失败
  failed,
}

/// 连接状态扩展
extension ConnectionStatusExtension on ConnectionStatus {
  String get displayText {
    switch (this) {
      case ConnectionStatus.connected:
        return '已连接';
      case ConnectionStatus.connecting:
        return '连接中';
      case ConnectionStatus.disconnected:
        return '已断开';
      case ConnectionStatus.reconnecting:
        return '重连中';
      case ConnectionStatus.failed:
        return '连接失败';
    }
  }
  
  bool get isConnected => this == ConnectionStatus.connected;
  bool get isConnecting => this == ConnectionStatus.connecting;
  bool get isDisconnected => this == ConnectionStatus.disconnected;
  bool get isReconnecting => this == ConnectionStatus.reconnecting;
  bool get isFailed => this == ConnectionStatus.failed;
}