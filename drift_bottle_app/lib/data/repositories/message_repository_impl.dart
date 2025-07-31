import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_datasource.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

/// 消息仓库实现
@LazySingleton(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  
  const MessageRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );
  
  @override
  Future<Either<Failure, Message>> sendMessage({
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
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (conversationId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '会话ID不能为空',
        ));
      }
      
      if (content.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '消息内容不能为空',
        ));
      }
      
      if (content.length > 1000) {
        return const Left(Failure.validation(
          message: '消息内容不能超过1000个字符',
        ));
      }
      
      final messageModel = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        content: content,
        messageType: messageType,
        imageUrl: imageUrl,
        audioUrl: audioUrl,
        videoUrl: videoUrl,
        fileUrl: fileUrl,
        fileName: fileName,
        fileSize: fileSize,
        metadata: metadata,
      );
      
      return Right(messageModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Message>>> getMessages({
    required String conversationId,
    int? limit,
    String? beforeMessageId,
    String? afterMessageId,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (conversationId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '会话ID不能为空',
        ));
      }
      
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      final messageListModel = await _remoteDataSource.getMessages(
        conversationId: conversationId,
        limit: limit,
        beforeMessageId: beforeMessageId,
        afterMessageId: afterMessageId,
      );
      
      final messages = messageListModel.messages
          .map((model) => model.toEntity())
          .toList();
      
      return Right(messages);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, Message>> getMessageById(String messageId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (messageId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '消息ID不能为空',
        ));
      }
      
      final messageModel = await _remoteDataSource.getMessageById(messageId);
      
      return Right(messageModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (messageId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '消息ID不能为空',
        ));
      }
      
      await _remoteDataSource.deleteMessage(messageId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> recallMessage(String messageId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (messageId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '消息ID不能为空',
        ));
      }
      
      await _remoteDataSource.recallMessage(messageId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> markMessageAsRead(String messageId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (messageId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '消息ID不能为空',
        ));
      }
      
      await _remoteDataSource.markMessageAsRead(messageId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> markMessagesAsRead(List<String> messageIds) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (messageIds.isEmpty) {
        return const Left(Failure.validation(
          message: '消息ID列表不能为空',
        ));
      }
      
      for (final messageId in messageIds) {
        if (messageId.trim().isEmpty) {
          return const Left(Failure.validation(
            message: '消息ID不能为空',
          ));
        }
      }
      
      await _remoteDataSource.markMessagesAsRead(messageIds);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> markConversationAsRead(String conversationId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (conversationId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '会话ID不能为空',
        ));
      }
      
      await _remoteDataSource.markConversationAsRead(conversationId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Conversation>>> getConversations({
    int? limit,
    int? offset,
    ConversationType? type,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      final conversationListModel = await _remoteDataSource.getConversations(
        limit: limit,
        offset: offset,
        type: type,
      );
      
      final conversations = conversationListModel.conversations
          .map((model) => model.toEntity())
          .toList();
      
      return Right(conversations);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, Conversation>> getConversationById(String conversationId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (conversationId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '会话ID不能为空',
        ));
      }
      
      final conversationModel = await _remoteDataSource.getConversationById(conversationId);
      
      return Right(conversationModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, Conversation>> createConversation({
    required String participantId,
    String? title,
    String? description,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (participantId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '参与者ID不能为空',
        ));
      }
      
      final conversationModel = await _remoteDataSource.createConversation(
        participantId: participantId,
        title: title,
        description: description,
      );
      
      return Right(conversationModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteConversation(String conversationId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (conversationId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '会话ID不能为空',
        ));
      }
      
      await _remoteDataSource.deleteConversation(conversationId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, Conversation>> updateConversation({
    required String conversationId,
    String? name,
    String? avatar,
    String? description,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (conversationId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '会话ID不能为空',
        ));
      }
      
      final conversationModel = await _remoteDataSource.updateConversation(
        conversationId: conversationId,
        name: name,
        avatar: avatar,
        description: description,
      );
      
      return Right(conversationModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Message>>> searchMessages({
    required String query,
    String? conversationId,
    int? limit,
    String? beforeMessageId,
    String? afterMessageId,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (query.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '搜索关键词不能为空',
        ));
      }
      
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      final messageListModel = await _remoteDataSource.searchMessages(
        query: query,
        conversationId: conversationId,
        limit: limit,
        beforeMessageId: beforeMessageId,
        afterMessageId: afterMessageId,
      );
      
      final messages = messageListModel.messages
          .map((model) => model.toEntity())
          .toList();
      
      return Right(messages);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, int>> getUnreadMessageCount({
    String? conversationId,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      final count = await _remoteDataSource.getUnreadMessageCount(
        conversationId: conversationId,
      );
      
      return Right(count);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, String>> uploadFile({
    required String filePath,
    required String fileType,
    String? conversationId,
    void Function(int, int)? onProgress,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (filePath.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '文件路径不能为空',
        ));
      }
      
      if (fileType.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '文件类型不能为空',
        ));
      }
      
      final fileUrl = await _remoteDataSource.uploadFile(
        filePath: filePath,
        fileType: fileType,
        conversationId: conversationId,
        onProgress: onProgress,
      );
      
      return Right(fileUrl);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, String>> downloadFile({
    required String fileUrl,
    required String savePath,
    void Function(int, int)? onProgress,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (fileUrl.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '文件URL不能为空',
        ));
      }
      
      if (savePath.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '保存路径不能为空',
        ));
      }
      
      final savedPath = await _remoteDataSource.downloadFile(
        fileUrl: fileUrl,
        savePath: savePath,
        onProgress: onProgress,
      );
      
      return Right(savedPath);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> reportMessage({
    required String messageId,
    required String reason,
    String? description,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (messageId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '消息ID不能为空',
        ));
      }
      
      if (reason.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '举报原因不能为空',
        ));
      }
      
      await _remoteDataSource.reportMessage(
        messageId: messageId,
        reason: reason,
        description: description,
      );
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  /// 处理异常
  Failure _handleException(dynamic e) {
    final errorMessage = e.toString();
    
    // 网络相关错误
    if (errorMessage.contains('网络') || 
        errorMessage.contains('连接') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('connection')) {
      return Failure.network(
        message: errorMessage.contains('网络') ? errorMessage : '网络连接失败',
      );
    }
    
    // 认证相关错误
    if (errorMessage.contains('401') || 
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('token')) {
      return const Failure.auth(
        message: '认证失败，请重新登录',
      );
    }
    
    // 权限相关错误
    if (errorMessage.contains('403') || 
        errorMessage.contains('forbidden')) {
      return const Failure.auth(
        message: '权限不足，无法执行此操作',
      );
    }
    
    // 验证相关错误
    if (errorMessage.contains('422') || 
        errorMessage.contains('validation')) {
      return Failure.validation(
        message: errorMessage.contains('validation') ? errorMessage : '数据验证失败',
      );
    }
    
    // 服务器错误
    if (errorMessage.contains('500') || 
        errorMessage.contains('502') ||
        errorMessage.contains('503') ||
        errorMessage.contains('504')) {
      return const Failure.server(
        message: '服务器错误，请稍后重试',
      );
    }
    
    // 默认为未知错误
    return Failure.unknown(
      message: errorMessage.isNotEmpty ? errorMessage : '未知错误',
      error: e,
    );
  }
  
  @override
  Future<Either<Failure, void>> markAsRead(String conversationId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (conversationId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '会话ID不能为空',
        ));
      }
      
      await _remoteDataSource.markConversationAsRead(conversationId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Message>>> getNotifications() async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      final messageListModel = await _remoteDataSource.getNotifications();
      
      final messages = messageListModel.messages
          .map((model) => model.toEntity())
          .toList();
      
      return Right(messages);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> markNotificationAsRead(String notificationId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (notificationId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '通知ID不能为空',
        ));
      }
      
      await _remoteDataSource.markNotificationAsRead(notificationId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
}