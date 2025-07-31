import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/message.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

/// 消息远程数据源抽象类
abstract class MessageRemoteDataSource {
  /// 发送消息
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    String? messageType,
    String? imageUrl,
    String? audioUrl,
    String? videoUrl,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    Map<String, dynamic>? metadata,
  });
  
  /// 获取消息列表
  Future<MessageListModel> getMessages({
    required String conversationId,
    int? limit,
    String? beforeMessageId,
    String? afterMessageId,
  });
  
  /// 获取消息详情
  Future<MessageModel> getMessageById(String messageId);
  
  /// 删除消息
  Future<void> deleteMessage(String messageId);
  
  /// 撤回消息
  Future<void> recallMessage(String messageId);
  
  /// 标记消息为已读
  Future<void> markMessageAsRead(String messageId);
  
  /// 批量标记消息为已读
  Future<void> markMessagesAsRead(List<String> messageIds);
  
  /// 标记会话所有消息为已读
  Future<void> markConversationAsRead(String conversationId);
  
  /// 获取通知消息
  Future<MessageListModel> getNotifications();
  
  /// 标记通知为已读
  Future<void> markNotificationAsRead(String notificationId);
  
  /// 获取会话列表
  Future<ConversationListModel> getConversations({
    int? limit,
    int? offset,
    ConversationType? type,
  });
  
  /// 获取会话详情
  Future<ConversationModel> getConversationById(String conversationId);
  
  /// 创建会话
  Future<ConversationModel> createConversation({
    required String participantId,
    String? title,
    String? description,
  });
  
  /// 删除会话
  Future<void> deleteConversation(String conversationId);
  
  /// 更新会话信息
  Future<ConversationModel> updateConversation({
    required String conversationId,
    String? title,
    String? description,
    bool? isMuted,
    bool? isPinned,
  });
  
  /// 搜索消息
  Future<MessageListModel> searchMessages({
    required String query,
    String? conversationId,
    int? limit,
    String? beforeMessageId,
    String? afterMessageId,
  });
  
  /// 获取未读消息数量
  Future<int> getUnreadMessageCount({
    String? conversationId,
  });
  
  /// 上传文件
  Future<String> uploadFile({
    required String filePath,
    required String fileType,
    String? conversationId,
    void Function(int, int)? onProgress,
  });
  
  /// 下载文件
  Future<String> downloadFile({
    required String fileUrl,
    required String savePath,
    void Function(int, int)? onProgress,
  });
  
  /// 举报消息
  Future<void> reportMessage({
    required String messageId,
    required String reason,
    String? description,
  });
  
  /// 获取消息统计信息
  Future<MessageStatsModel> getMessageStats({
    String? conversationId,
    String? timeRange,
  });
}

/// 消息远程数据源实现
@LazySingleton(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final DioClient _dioClient;
  
  const MessageRemoteDataSourceImpl(this._dioClient);
  
  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    String? messageType,
    String? imageUrl,
    String? audioUrl,
    String? videoUrl,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final data = {
        'conversation_id': conversationId,
        'content': content,
        if (messageType != null) 'message_type': messageType,
        if (imageUrl != null) 'image_url': imageUrl,
        if (audioUrl != null) 'audio_url': audioUrl,
        if (videoUrl != null) 'video_url': videoUrl,
        if (fileUrl != null) 'file_url': fileUrl,
        if (fileName != null) 'file_name': fileName,
        if (fileSize != null) 'file_size': fileSize,
        if (metadata != null) 'metadata': metadata,
      };
      
      final response = await _dioClient.post(
        ApiConstants.sendMessage,
        data: data,
      );
      
      return MessageModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('发送消息失败: $e');
    }
  }
  
  @override
  Future<MessageListModel> getMessages({
    required String conversationId,
    int? limit,
    String? beforeMessageId,
    String? afterMessageId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'conversation_id': conversationId,
      };
      if (limit != null) queryParams['limit'] = limit;
      if (beforeMessageId != null) queryParams['before_message_id'] = beforeMessageId;
      if (afterMessageId != null) queryParams['after_message_id'] = afterMessageId;
      
      final response = await _dioClient.get(
        ApiConstants.getMessages,
        queryParameters: queryParams,
      );
      
      return MessageListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取消息列表失败: $e');
    }
  }
  
  @override
  Future<MessageModel> getMessageById(String messageId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getMessageById(messageId),
      );
      
      return MessageModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取消息详情失败: $e');
    }
  }
  
  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await _dioClient.delete(
        ApiConstants.deleteMessageById(messageId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('删除消息失败: $e');
    }
  }
  
  @override
  Future<void> recallMessage(String messageId) async {
    try {
      await _dioClient.post(
        ApiConstants.recallMessageById(messageId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('撤回消息失败: $e');
    }
  }
  
  @override
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _dioClient.post(
        ApiConstants.markMessageAsRead(messageId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('标记消息已读失败: $e');
    }
  }
  
  @override
  Future<void> markMessagesAsRead(List<String> messageIds) async {
    try {
      final data = {
        'message_ids': messageIds,
      };
      
      await _dioClient.post(
        ApiConstants.markMessagesAsRead,
        data: data,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('批量标记消息已读失败: $e');
    }
  }
  
  @override
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      await _dioClient.post(
        ApiConstants.markConversationAsReadById(conversationId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('标记会话已读失败: $e');
    }
  }
  
  @override
  Future<MessageListModel> getNotifications() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getNotifications,
      );
      
      return MessageListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取通知消息失败: $e');
    }
  }
  
  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _dioClient.post(
        ApiConstants.markNotificationAsRead(notificationId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('标记通知已读失败: $e');
    }
  }
  
  @override
  Future<ConversationListModel> getConversations({
    int? limit,
    int? offset,
    ConversationType? type,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;
      if (type != null) queryParams['type'] = type.name;
      
      final response = await _dioClient.get(
        ApiConstants.conversations,
        queryParameters: queryParams,
      );
      
      return ConversationListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取会话列表失败: $e');
    }
  }
  
  @override
  Future<ConversationModel> getConversationById(String conversationId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getConversationById(conversationId),
      );
      
      return ConversationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取会话详情失败: $e');
    }
  }
  
  @override
  Future<ConversationModel> createConversation({
    required String participantId,
    String? title,
    String? description,
  }) async {
    try {
      final data = {
        'participant_id': participantId,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
      };
      
      final response = await _dioClient.post(
        ApiConstants.createConversation,
        data: data,
      );
      
      return ConversationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('创建会话失败: $e');
    }
  }
  
  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _dioClient.delete(
        ApiConstants.deleteConversationById(conversationId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('删除会话失败: $e');
    }
  }
  
  @override
  Future<ConversationModel> updateConversation({
    required String conversationId,
    String? title,
    String? description,
    bool? isMuted,
    bool? isPinned,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (isMuted != null) data['is_muted'] = isMuted;
      if (isPinned != null) data['is_pinned'] = isPinned;
      
      final response = await _dioClient.put(
        ApiConstants.updateConversationById(conversationId),
        data: data,
      );
      
      return ConversationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('更新会话失败: $e');
    }
  }
  
  @override
  Future<MessageListModel> searchMessages({
    required String query,
    String? conversationId,
    int? limit,
    String? beforeMessageId,
    String? afterMessageId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
      };
      if (conversationId != null) queryParams['conversation_id'] = conversationId;
      if (limit != null) queryParams['limit'] = limit;
      if (beforeMessageId != null) queryParams['before_message_id'] = beforeMessageId;
      if (afterMessageId != null) queryParams['after_message_id'] = afterMessageId;
      
      final response = await _dioClient.get(
        ApiConstants.searchMessages,
        queryParameters: queryParams,
      );
      
      return MessageListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('搜索消息失败: $e');
    }
  }
  
  @override
  Future<int> getUnreadMessageCount({
    String? conversationId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (conversationId != null) queryParams['conversation_id'] = conversationId;
      
      final response = await _dioClient.get(
        ApiConstants.getUnreadMessageCount,
        queryParameters: queryParams,
      );
      
      return response.data['data']['count'] as int;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取未读消息数量失败: $e');
    }
  }
  
  @override
  Future<String> uploadFile({
    required String filePath,
    required String fileType,
    String? conversationId,
    void Function(int, int)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'file_type': fileType,
        if (conversationId != null) 'conversation_id': conversationId,
      });
      
      final response = await _dioClient.upload(
        ApiConstants.uploadFile,
        formData,
        onSendProgress: onProgress,
      );
      
      return response.data['data']['file_url'] as String;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('上传文件失败: $e');
    }
  }
  
  @override
  Future<String> downloadFile({
    required String fileUrl,
    required String savePath,
    void Function(int, int)? onProgress,
  }) async {
    try {
      await _dioClient.download(
        fileUrl,
        savePath,
        onReceiveProgress: onProgress,
      );
      
      return savePath;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('下载文件失败: $e');
    }
  }
  
  @override
  Future<void> reportMessage({
    required String messageId,
    required String reason,
    String? description,
  }) async {
    try {
      final data = {
        'reason': reason,
        if (description != null) 'description': description,
      };
      
      await _dioClient.post(
        ApiConstants.reportMessage(messageId),
        data: data,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('举报消息失败: $e');
    }
  }
  
  @override
  Future<MessageStatsModel> getMessageStats({
    String? conversationId,
    String? timeRange,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (conversationId != null) queryParams['conversation_id'] = conversationId;
      if (timeRange != null) queryParams['time_range'] = timeRange;
      
      final response = await _dioClient.get(
        ApiConstants.getMessageStats,
        queryParameters: queryParams,
      );
      
      return MessageStatsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取消息统计信息失败: $e');
    }
  }
  
  /// 处理Dio异常
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('网络连接超时，请检查网络设置');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? '请求失败';
        return Exception('请求失败 ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('请求已取消');
      case DioExceptionType.connectionError:
        return Exception('网络连接失败，请检查网络设置');
      default:
        return Exception('网络请求失败: ${e.message}');
    }
  }
}