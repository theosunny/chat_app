import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../../core/error/failures.dart';

/// 消息仓库接口
abstract class MessageRepository {
  /// 发送消息
  Future<Either<Failure, Message>> sendMessage({
    required int conversationId,
    required int receiverId,
    required String content,
    MessageType messageType = MessageType.text,
  });

  /// 获取会话消息列表
  Future<Either<Failure, List<Message>>> getMessages({
    required int conversationId,
    int page = 1,
    int limit = 20,
  });

  /// 标记消息为已读
  Future<Either<Failure, void>> markMessageAsRead(int messageId);

  /// 标记会话所有消息为已读
  Future<Either<Failure, void>> markConversationAsRead(int conversationId);

  /// 删除消息
  Future<Either<Failure, void>> deleteMessage(int messageId);

  /// 获取未读消息数量
  Future<Either<Failure, int>> getUnreadMessageCount();

  /// 搜索消息
  Future<Either<Failure, List<Message>>> searchMessages({
    required String query,
    int? conversationId,
    int page = 1,
    int limit = 20,
  });

  /// 获取最新消息
  Future<Either<Failure, List<Message>>> getLatestMessages({
    int limit = 10,
  });

  /// 保存消息到本地
  Future<Either<Failure, void>> saveMessageToLocal(Message message);

  /// 从本地获取消息
  Future<Either<Failure, List<Message>>> getMessagesFromLocal({
    required int conversationId,
    int page = 1,
    int limit = 20,
  });

  /// 清除本地消息
  Future<Either<Failure, void>> clearLocalMessages(int conversationId);

  /// 同步消息
  Future<Either<Failure, void>> syncMessages(int conversationId);
}