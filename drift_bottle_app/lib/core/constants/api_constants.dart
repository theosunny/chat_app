/// API常量配置
class ApiConstants {
  // 基础配置
  static const String baseUrl = 'http://localhost:8080';
  static const String apiVersion = '/api/v1';
  
  // 超时配置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 认证相关
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendVerification = '/auth/resend-verification';
  
  // 用户相关
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadAvatar = '/user/avatar';
  static const String getUserInfo = '/user/info';
  static const String searchUsers = '/user/search';
  static const String followUser = '/user/follow';
  static const String unfollowUser = '/user/unfollow';
  static const String getFollowers = '/user/followers';
  static const String getFollowing = '/user/following';
  static const String blockUser = '/user/block';
  static const String unblockUser = '/user/unblock';
  static const String getBlockedUsers = '/user/blocked';
  
  // 漂流瓶相关
  static const String bottles = '/bottles';
  static const String sendBottle = '/bottles';
  static const String getBottle = '/bottles';
  static const String pickBottle = '/bottles/{id}/pick';
  static const String likeBottle = '/bottles/{id}/like';
  static const String unlikeBottle = '/bottles/{id}/unlike';
  static const String favoriteBottle = '/bottles/{id}/favorite';
  static const String unfavoriteBottle = '/bottles/{id}/unfavorite';
  static const String reportBottle = '/bottles/{id}/report';
  static const String deleteBottle = '/bottles/{id}';
  static const String getNearbyBottles = '/bottles/nearby';
  static const String getMySentBottles = '/bottles/sent';
  static const String getMyPickedBottles = '/bottles/picked';
  static const String getMyFavoriteBottles = '/bottles/favorites';
  static const String favoriteBottles = '/bottles/favorites';
  static const String getHotBottles = '/bottles/hot';
  static const String getRecommendedBottles = '/bottles/recommended';
  static const String searchBottles = '/bottles/search';
  static const String getBottleReplies = '/bottles/{id}/replies';
  static const String replyToBottle = '/bottles/{id}/replies';
  static const String getBottleStats = '/bottles/{id}/stats';
  static const String getBottleTags = '/bottles/tags';
  static const String getBottleTrack = '/bottles/{id}/track';
  static const String updateBottleLocation = '/bottles/{id}/location';
  
  // 消息相关
  static const String conversations = '/conversations';
  static const String createConversation = '/conversations';
  static const String getConversation = '/conversations/{id}';
  static const String updateConversation = '/conversations/{id}';
  static const String deleteConversation = '/conversations/{id}';
  static const String pinConversation = '/conversations/{id}/pin';
  static const String unpinConversation = '/conversations/{id}/unpin';
  static const String muteConversation = '/conversations/{id}/mute';
  static const String unmuteConversation = '/conversations/{id}/unmute';
  static const String blockConversation = '/conversations/{id}/block';
  static const String unblockConversation = '/conversations/{id}/unblock';
  
  static const String messages = '/conversations/{conversationId}/messages';
  static const String sendMessage = '/conversations/{conversationId}/messages';
  static const String getMessage = '/messages/{id}';
  static const String deleteMessage = '/messages/{id}';
  static const String recallMessage = '/messages/{id}/recall';
  static const String forwardMessage = '/messages/{id}/forward';
  static const String markAsRead = '/messages/{id}/read';
  static const String markConversationAsRead = '/conversations/{id}/read';
  static const String searchMessages = '/messages/search';
  static const String getUnreadCount = '/messages/unread-count';
  static const String uploadMedia = '/media/upload';
  static const String downloadMedia = '/media/{id}/download';
  
  // WebSocket相关
  static const String wsBaseUrl = 'ws://localhost:8080';
  static const String wsMessages = '/ws/messages';
  static const String wsNotifications = '/ws/notifications';
  static const String wsOnlineStatus = '/ws/online-status';
  static const String wsTypingStatus = '/ws/typing-status';
  
  // 文件上传相关
  static const String uploadFile = '/upload/file';
  static const String uploadImage = '/upload/image';
  static const String uploadVideo = '/upload/video';
  static const String uploadAudio = '/upload/audio';
  static const String getFileInfo = '/files/{id}';
  static const String deleteFile = '/files/{id}';
  
  // 通知相关
  static const String notifications = '/notifications';
  static const String markNotificationAsRead = '/notifications/{id}/read';
  static const String markAllNotificationsAsRead = '/notifications/read-all';
  static const String deleteNotification = '/notifications/{id}';
  static const String getNotificationSettings = '/notifications/settings';
  static const String updateNotificationSettings = '/notifications/settings';
  
  // 系统相关
  static const String systemInfo = '/system/info';
  static const String appVersion = '/system/version';
  static const String checkUpdate = '/system/update';
  static const String feedback = '/system/feedback';
  static const String reportBug = '/system/bug-report';
  
  // 统计相关
  static const String userStats = '/stats/user';
  static const String bottleStats = '/stats/bottles';
  static const String messageStats = '/stats/messages';
  static const String dailyLimits = '/stats/daily-limits';
  
  // 地理位置相关
  static const String geocoding = '/location/geocoding';
  static const String reverseGeocoding = '/location/reverse-geocoding';
  static const String nearbyPlaces = '/location/nearby';
  
  // 内容审核相关
  static const String moderateContent = '/moderation/content';
  static const String reportContent = '/moderation/report';
  static const String getReports = '/moderation/reports';
  
  // 分页默认值
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // 文件大小限制
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const int maxAudioSize = 50 * 1024 * 1024; // 50MB
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
  
  // 内容长度限制
  static const int maxTextLength = 5000;
  static const int maxBottleContentLength = 1000;
  static const int maxUsernameLength = 20;
  static const int maxNicknameLength = 20;
  static const int maxBioLength = 200;
  static const int maxTagLength = 20;
  static const int maxTagCount = 5;
  
  // 缓存相关
  static const Duration cacheExpiration = Duration(hours: 1);
  static const Duration imageCacheExpiration = Duration(days: 7);
  
  // 重试配置
  static const int maxRetryCount = 3;
  static const Duration retryDelay = Duration(seconds: 1);
  
  /// 构建带参数的URL
  static String buildUrl(String template, Map<String, String> params) {
    String url = template;
    params.forEach((key, value) {
      url = url.replaceAll('{$key}', value);
    });
    return url;
  }
  
  /// 构建查询参数
  static String buildQuery(Map<String, dynamic> params) {
    if (params.isEmpty) return '';
    
    final query = params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    
    return query.isNotEmpty ? '?$query' : '';
  }
  
  /// 验证文件大小
  static bool isValidFileSize(int size, String type) {
    switch (type.toLowerCase()) {
      case 'image':
        return size <= maxImageSize;
      case 'video':
        return size <= maxVideoSize;
      case 'audio':
        return size <= maxAudioSize;
      default:
        return size <= maxFileSize;
    }
  }
  
  /// 验证内容长度
  static bool isValidContentLength(String content, String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return content.length <= maxTextLength;
      case 'bottle':
        return content.length <= maxBottleContentLength;
      case 'username':
        return content.length <= maxUsernameLength;
      case 'nickname':
        return content.length <= maxNicknameLength;
      case 'bio':
        return content.length <= maxBioLength;
      case 'tag':
        return content.length <= maxTagLength;
      default:
        return true;
    }
  }

  // 动态URL构建方法
  static String getConversationById(String conversationId) {
    return buildUrl(getConversation, {'id': conversationId});
  }

  static String deleteConversationById(String conversationId) {
    return buildUrl(deleteConversation, {'id': conversationId});
  }

  static String updateConversationById(String conversationId) {
    return buildUrl(updateConversation, {'id': conversationId});
  }

  static String recallMessageById(String messageId) {
    return buildUrl('/messages/{id}/recall', {'id': messageId});
  }

  static String markMessageAsRead(String messageId) {
    return buildUrl(markAsRead, {'id': messageId});
  }

  static String markConversationAsReadById(String conversationId) {
    return buildUrl(markConversationAsRead, {'id': conversationId});
  }

  static String reportMessage(String messageId) {
    return '/messages/$messageId/report';
  }

  static String getMessageById(String messageId) {
    return buildUrl(getMessage, {'id': messageId});
  }

  static String deleteMessageById(String messageId) {
    return buildUrl('/messages/{id}', {'id': messageId});
  }

  static String getBottleById(String bottleId) {
    return '/bottles/$bottleId';
  }

  static String deleteBottleById(String bottleId) {
    return '/bottles/$bottleId';
  }

  static String reportBottleById(String bottleId) {
    return buildUrl(reportBottle, {'id': bottleId});
  }

  static String likeBottleById(String bottleId) {
    return buildUrl('/bottles/{id}/like', {'id': bottleId});
  }

  static String favoriteBottleById(String bottleId) {
    return buildUrl('/bottles/{id}/favorite', {'id': bottleId});
  }

  static const String getUnreadMessageCount = '/messages/unread-count';
  static const String getMessageStats = '/stats/messages';
  static const String markMessagesAsRead = '/messages/mark-read';
  static const String getMessages = '/messages';
  static const String getTrendingBottles = '/bottles/trending';
  static const String getNotifications = '/notifications';
}