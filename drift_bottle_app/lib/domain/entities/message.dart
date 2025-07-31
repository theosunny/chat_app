import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'message.freezed.dart';

/// 消息实体
@freezed
class Message with _$Message {
  const factory Message({
    /// 消息ID
    required String id,
    
    /// 会话ID
    required String conversationId,
    
    /// 发送者ID
    required String senderId,
    
    /// 接收者ID
    String? receiverId,
    
    /// 消息类型
    @Default(MessageType.text) MessageType type,
    
    /// 消息内容
    required String content,
    
    /// 媒体附件
    MessageMedia? media,
    
    /// 消息状态
    @Default(MessageStatus.sending) MessageStatus status,
    
    /// 消息方向
    @Default(MessageDirection.sent) MessageDirection direction,
    
    /// 是否已读
    @Default(false) bool isRead,
    
    /// 是否已删除
    @Default(false) bool isDeleted,
    
    /// 是否被撤回
    @Default(false) bool isRecalled,
    
    /// 是否置顶
    @Default(false) bool isPinned,
    
    /// 回复的消息ID
    String? replyToMessageId,
    
    /// 回复的消息内容预览
    String? replyToContent,
    
    /// 转发的消息ID
    String? forwardFromMessageId,
    
    /// 提及的用户ID列表
    @Default([]) List<String> mentionedUserIds,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 更新时间
    required DateTime updatedAt,
    
    /// 发送时间
    DateTime? sentAt,
    
    /// 送达时间
    DateTime? deliveredAt,
    
    /// 已读时间
    DateTime? readAt,
    
    /// 撤回时间
    DateTime? recalledAt,
    
    /// 本地消息ID (用于离线消息)
    String? localId,
    
    /// 重试次数
    @Default(0) int retryCount,
    
    /// 扩展数据
    Map<String, dynamic>? extra,
  }) = _Message;
  
  const Message._();
  
  /// 是否为发送的消息
  bool get isSent => direction == MessageDirection.sent;
  
  /// 是否为接收的消息
  bool get isReceived => direction == MessageDirection.received;
  
  /// 是否为系统消息
  bool get isSystem => type == MessageType.system;
  
  /// 是否可以撤回
  bool get canRecall {
    if (isRecalled || isDeleted || !isSent) return false;
    if (status != MessageStatus.delivered && status != MessageStatus.read) return false;
    
    // 只能撤回2分钟内的消息
    final now = DateTime.now();
    final sentTime = sentAt ?? createdAt;
    return now.difference(sentTime).inMinutes <= 2;
  }
  
  /// 是否可以重发
  bool get canResend {
    return status == MessageStatus.failed && isSent;
  }
  
  /// 是否可以删除
  bool get canDelete {
    return !isDeleted;
  }
  
  /// 是否可以回复
  bool get canReply {
    return !isDeleted && !isRecalled && type != MessageType.system;
  }
  
  /// 是否可以转发
  bool get canForward {
    return !isDeleted && !isRecalled && type != MessageType.system;
  }
  
  /// 是否可以复制
  bool get canCopy {
    return type == MessageType.text && !isDeleted && !isRecalled;
  }
  
  /// 获取显示内容
  String get displayContent {
    if (isRecalled) return '[消息已撤回]';
    if (isDeleted) return '[消息已删除]';
    
    switch (type) {
      case MessageType.text:
        return content;
      case MessageType.image:
        return '[图片]';
      case MessageType.audio:
        return '[语音]';
      case MessageType.video:
        return '[视频]';
      case MessageType.file:
        return '[文件]';
      case MessageType.location:
        return '[位置]';
      case MessageType.contact:
        return '[联系人]';
      case MessageType.system:
        return content;
      case MessageType.custom:
        return '[自定义消息]';
    }
  }
  
  /// 获取时间显示文本
  String get timeText {
    final time = sentAt ?? createdAt;
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${time.month}月${time.day}日';
    }
  }
  
  /// 获取详细时间文本
  String get detailTimeText {
    final time = sentAt ?? createdAt;
    final now = DateTime.now();
    
    if (time.year == now.year && time.month == now.month && time.day == now.day) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (time.year == now.year) {
      return '${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.year}年${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// 消息媒体附件
@freezed
class MessageMedia with _$MessageMedia {
  const factory MessageMedia({
    /// 媒体ID
    required String id,
    
    /// 媒体类型
    required MediaType type,
    
    /// 文件URL
    required String url,
    
    /// 本地文件路径
    String? localPath,
    
    /// 缩略图URL
    String? thumbnailUrl,
    
    /// 本地缩略图路径
    String? localThumbnailPath,
    
    /// 文件名
    String? fileName,
    
    /// 文件大小 (字节)
    int? fileSize,
    
    /// 持续时间 (秒，用于音频/视频)
    int? duration,
    
    /// 宽度 (像素，用于图片/视频)
    int? width,
    
    /// 高度 (像素，用于图片/视频)
    int? height,
    
    /// MIME类型
    String? mimeType,
    
    /// 下载状态
    @Default(DownloadStatus.none) DownloadStatus downloadStatus,
    
    /// 下载进度 (0.0 - 1.0)
    @Default(0.0) double downloadProgress,
    
    /// 上传状态
    @Default(UploadStatus.none) UploadStatus uploadStatus,
    
    /// 上传进度 (0.0 - 1.0)
    @Default(0.0) double uploadProgress,
    
    /// 创建时间
    required DateTime createdAt,
  }) = _MessageMedia;
  
  const MessageMedia._();
  
  /// 是否已下载
  bool get isDownloaded => downloadStatus == DownloadStatus.completed;
  
  /// 是否正在下载
  bool get isDownloading => downloadStatus == DownloadStatus.downloading;
  
  /// 是否已上传
  bool get isUploaded => uploadStatus == UploadStatus.completed;
  
  /// 是否正在上传
  bool get isUploading => uploadStatus == UploadStatus.uploading;
  
  /// 获取显示的文件大小
  String get fileSizeText {
    if (fileSize == null) return '未知大小';
    
    final size = fileSize!;
    if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)}KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }
  
  /// 获取持续时间文本
  String get durationText {
    if (duration == null) return '';
    
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// 会话实体
@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    /// 会话ID
    required String id,
    
    /// 会话类型
    @Default(ConversationType.single) ConversationType type,
    
    /// 会话名称
    String? name,
    
    /// 会话头像
    String? avatar,
    
    /// 参与者列表
    @Default([]) List<User> participants,
    
    /// 最后一条消息
    Message? lastMessage,
    
    /// 未读消息数
    @Default(0) int unreadCount,
    
    /// 是否置顶
    @Default(false) bool isPinned,
    
    /// 是否免打扰
    @Default(false) bool isMuted,
    
    /// 是否已删除
    @Default(false) bool isDeleted,
    
    /// 是否被拉黑
    @Default(false) bool isBlocked,
    
    /// 草稿内容
    String? draft,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 更新时间
    required DateTime updatedAt,
    
    /// 最后活跃时间
    DateTime? lastActiveAt,
    
    /// 扩展数据
    Map<String, dynamic>? extra,
  }) = _Conversation;
  
  const Conversation._();
  
  /// 是否为单聊
  bool get isSingle => type == ConversationType.single;
  
  /// 是否为群聊
  bool get isGroup => type == ConversationType.group;
  
  /// 是否为系统会话
  bool get isSystem => type == ConversationType.system;
  
  /// 获取显示名称
  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    
    if (isSingle && participants.isNotEmpty) {
      return participants.first.displayName;
    }
    
    if (isGroup) {
      final names = participants.take(3).map((u) => u.displayName).join('、');
      return participants.length > 3 ? '$names等${participants.length}人' : names;
    }
    
    return '未知会话';
  }
  
  /// 获取显示头像
  String? get displayAvatar {
    if (avatar != null && avatar!.isNotEmpty) return avatar;
    
    if (isSingle && participants.isNotEmpty) {
      return participants.first.avatar;
    }
    
    return null;
  }
  
  /// 获取最后消息显示文本
  String get lastMessageText {
    if (lastMessage == null) return '';
    
    final message = lastMessage!;
    String prefix = '';
    
    if (isGroup && !message.isSystem) {
      final sender = participants.firstWhere(
        (u) => u.id == message.senderId,
        orElse: () => User(
          id: '',
          nickname: '未知用户',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      prefix = '${sender.displayName}: ';
    }
    
    if (draft != null && draft!.isNotEmpty) {
      return '[草稿] $draft';
    }
    
    return '$prefix${message.displayContent}';
  }
  
  /// 获取最后活跃时间文本
  String get lastActiveTimeText {
    final time = lastActiveAt ?? updatedAt;
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${time.month}月${time.day}日';
    }
  }
}

/// 消息类型枚举
enum MessageType {
  /// 文本消息
  text,
  
  /// 图片消息
  image,
  
  /// 语音消息
  audio,
  
  /// 视频消息
  video,
  
  /// 文件消息
  file,
  
  /// 位置消息
  location,
  
  /// 联系人消息
  contact,
  
  /// 系统消息
  system,
  
  /// 自定义消息
  custom,
}

/// 消息状态枚举
enum MessageStatus {
  /// 发送中
  sending,
  
  /// 发送成功
  sent,
  
  /// 已送达
  delivered,
  
  /// 已读
  read,
  
  /// 发送失败
  failed,
}

/// 消息方向枚举
enum MessageDirection {
  /// 发送的消息
  sent,
  
  /// 接收的消息
  received,
}

/// 媒体类型枚举
enum MediaType {
  /// 图片
  image,
  
  /// 音频
  audio,
  
  /// 视频
  video,
  
  /// 文件
  file,
}

/// 下载状态枚举
enum DownloadStatus {
  /// 未下载
  none,
  
  /// 下载中
  downloading,
  
  /// 下载完成
  completed,
  
  /// 下载失败
  failed,
}

/// 上传状态枚举
enum UploadStatus {
  /// 未上传
  none,
  
  /// 上传中
  uploading,
  
  /// 上传完成
  completed,
  
  /// 上传失败
  failed,
}

/// 会话类型枚举
enum ConversationType {
  /// 单聊
  single,
  
  /// 群聊
  group,
  
  /// 系统会话
  system,
}

/// 消息状态扩展
extension MessageStatusExtension on MessageStatus {
  String get displayText {
    switch (this) {
      case MessageStatus.sending:
        return '发送中';
      case MessageStatus.sent:
        return '已发送';
      case MessageStatus.delivered:
        return '已送达';
      case MessageStatus.read:
        return '已读';
      case MessageStatus.failed:
        return '发送失败';
    }
  }
  
  String get icon {
    switch (this) {
      case MessageStatus.sending:
        return '⏳';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.read:
        return '✓✓';
      case MessageStatus.failed:
        return '❌';
    }
  }
}

/// 消息类型扩展
extension MessageTypeExtension on MessageType {
  String get displayText {
    switch (this) {
      case MessageType.text:
        return '文字';
      case MessageType.image:
        return '图片';
      case MessageType.audio:
        return '语音';
      case MessageType.video:
        return '视频';
      case MessageType.file:
        return '文件';
      case MessageType.location:
        return '位置';
      case MessageType.contact:
        return '联系人';
      case MessageType.system:
        return '系统';
      case MessageType.custom:
        return '自定义';
    }
  }
}