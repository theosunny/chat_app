import 'package:dartz/dartz.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/message_remote_datasource.dart';
import '../datasources/local/message_local_datasource.dart';
import '../models/message_model.dart';

/// 消息仓库实现
class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;
  final MessageLocalDataSource localDataSource;

  const MessageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Message>> sendMessage({
    required int conversationId,
    required int receiverId,
    required String content,
    MessageType messageType = MessageType.text,
  }) async {
    try {
      final messageModel = await remoteDataSource.sendMessage(
        conversationId,
        receiverId,
        content,
        messageType.toString().split('.').last,
      );
      
      // 保存到本地
      await localDataSource.saveMessage(messageModel);
      
      return Right(messageModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages({
    required int conversationId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final messageModels = await remoteDataSource.getMessages(conversationId, page, limit);
      
      // 保存到本地
      await localDataSource.saveMessages(messageModels);
      
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMessageAsRead(int messageId) async {
    try {
      await remoteDataSource.markMessageAsRead(messageId);
      
      // 更新本地消息状态
      final localMessage = await localDataSource.getMessageById(messageId);
      if (localMessage != null) {
        final updatedMessage = localMessage.copyWith(isRead: true);
        await localDataSource.updateMessage(updatedMessage);
      }
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markConversationAsRead(int conversationId) async {
    try {
      await remoteDataSource.markConversationAsRead(conversationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(int messageId) async {
    try {
      await remoteDataSource.deleteMessage(messageId);
      
      // 从本地删除
      await localDataSource.deleteMessage(messageId);
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadMessageCount() async {
    try {
      final count = await remoteDataSource.getUnreadMessageCount();
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> searchMessages({
    required String query,
    int? conversationId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final messageModels = await remoteDataSource.searchMessages(query, conversationId, page, limit);
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getLatestMessages({
    int limit = 10,
  }) async {
    try {
      final messageModels = await remoteDataSource.getLatestMessages(limit);
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessageToLocal(Message message) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      await localDataSource.saveMessage(messageModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessagesFromLocal({
    required int conversationId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final messageModels = await localDataSource.getMessages(conversationId, page, limit);
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearLocalMessages(int conversationId) async {
    try {
      await localDataSource.clearMessages(conversationId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncMessages(int conversationId) async {
    try {
      // 获取远程消息
      final messageModels = await remoteDataSource.getMessages(conversationId, 1, 50);
      
      // 清除本地旧消息
      await localDataSource.clearMessages(conversationId);
      
      // 保存新消息到本地
      await localDataSource.saveMessages(messageModels);
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}