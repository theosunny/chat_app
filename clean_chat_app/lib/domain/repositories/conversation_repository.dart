import 'package:dartz/dartz.dart';
import '../entities/conversation.dart';
import '../../core/error/failures.dart';

/// 会话仓库接口
abstract class ConversationRepository {
  /// 获取会话列表
  Future<Either<Failure, List<Conversation>>> getConversations({
    int page = 1,
    int limit = 20,
  });

  /// 创建会话
  Future<Either<Failure, Conversation>> createConversation({
    required int otherUserId,
  });

  /// 根据ID获取会话
  Future<Either<Failure, Conversation>> getConversationById(int conversationId);

  /// 根据用户ID获取会话
  Future<Either<Failure, Conversation?>> getConversationByUserId(int otherUserId);

  /// 删除会话
  Future<Either<Failure, void>> deleteConversation(int conversationId);

  /// 更新会话最后消息
  Future<Either<Failure, void>> updateLastMessage({
    required int conversationId,
    required int messageId,
    required String content,
    required DateTime timestamp,
  });

  /// 更新未读消息数
  Future<Either<Failure, void>> updateUnreadCount({
    required int conversationId,
    required int userId,
    required int count,
  });

  /// 清零未读消息数
  Future<Either<Failure, void>> clearUnreadCount({
    required int conversationId,
    required int userId,
  });

  /// 搜索会话
  Future<Either<Failure, List<Conversation>>> searchConversations(String query);

  /// 获取总未读消息数
  Future<Either<Failure, int>> getTotalUnreadCount();

  /// 保存会话到本地
  Future<Either<Failure, void>> saveConversationToLocal(Conversation conversation);

  /// 从本地获取会话列表
  Future<Either<Failure, List<Conversation>>> getConversationsFromLocal({
    int page = 1,
    int limit = 20,
  });

  /// 清除本地会话数据
  Future<Either<Failure, void>> clearLocalConversations();

  /// 同步会话数据
  Future<Either<Failure, void>> syncConversations();
}