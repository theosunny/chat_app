import 'package:dartz/dartz.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/conversation_remote_datasource.dart';
import '../datasources/local/conversation_local_datasource.dart';
import '../models/conversation_model.dart';

/// 会话仓库实现
class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;
  final ConversationLocalDataSource localDataSource;

  const ConversationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Conversation>>> getConversations({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final conversationModels = await remoteDataSource.getConversations(page, limit);
      
      // 保存到本地
      await localDataSource.saveConversations(conversationModels);
      
      final conversations = conversationModels.map((model) => model.toEntity()).toList();
      return Right(conversations);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Conversation>> createConversation({
    required int otherUserId,
  }) async {
    try {
      final conversationModel = await remoteDataSource.createConversation(otherUserId);
      
      // 保存到本地
      await localDataSource.saveConversation(conversationModel);
      
      return Right(conversationModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Conversation>> getConversationById(int conversationId) async {
    try {
      final conversationModel = await remoteDataSource.getConversationById(conversationId);
      
      // 保存到本地
      await localDataSource.saveConversation(conversationModel);
      
      return Right(conversationModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Conversation?>> getConversationByUserId(int otherUserId) async {
    try {
      final conversationModel = await remoteDataSource.getConversationByUserId(otherUserId);
      
      if (conversationModel != null) {
        // 保存到本地
        await localDataSource.saveConversation(conversationModel);
        return Right(conversationModel.toEntity());
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
  Future<Either<Failure, void>> deleteConversation(int conversationId) async {
    try {
      await remoteDataSource.deleteConversation(conversationId);
      
      // 从本地删除
      await localDataSource.deleteConversation(conversationId);
      
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
  Future<Either<Failure, void>> updateLastMessage({
    required int conversationId,
    required int messageId,
    required String content,
    required DateTime timestamp,
  }) async {
    try {
      await remoteDataSource.updateLastMessage(
        conversationId,
        messageId,
        content,
        timestamp.toIso8601String(),
      );
      
      // 更新本地会话
      final localConversation = await localDataSource.getConversationById(conversationId);
      if (localConversation != null) {
        final updatedConversation = localConversation.copyWith(
          lastMessageId: messageId,
          lastMessageContent: content,
          lastMessageTime: timestamp,
          updatedAt: DateTime.now(),
        );
        await localDataSource.updateConversation(updatedConversation);
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
  Future<Either<Failure, void>> updateUnreadCount({
    required int conversationId,
    required int userId,
    required int count,
  }) async {
    try {
      await remoteDataSource.updateUnreadCount(conversationId, userId, count);
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
  Future<Either<Failure, void>> clearUnreadCount({
    required int conversationId,
    required int userId,
  }) async {
    try {
      await remoteDataSource.clearUnreadCount(conversationId, userId);
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
  Future<Either<Failure, List<Conversation>>> searchConversations(String query) async {
    try {
      final conversationModels = await remoteDataSource.searchConversations(query);
      final conversations = conversationModels.map((model) => model.toEntity()).toList();
      return Right(conversations);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalUnreadCount() async {
    try {
      final count = await remoteDataSource.getTotalUnreadCount();
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
  Future<Either<Failure, void>> saveConversationToLocal(Conversation conversation) async {
    try {
      final conversationModel = ConversationModel.fromEntity(conversation);
      await localDataSource.saveConversation(conversationModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Conversation>>> getConversationsFromLocal({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final conversationModels = await localDataSource.getConversations(page, limit);
      final conversations = conversationModels.map((model) => model.toEntity()).toList();
      return Right(conversations);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearLocalConversations() async {
    try {
      await localDataSource.clearConversations();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncConversations() async {
    try {
      // 获取远程会话
      final conversationModels = await remoteDataSource.getConversations(1, 100);
      
      // 清除本地旧会话
      await localDataSource.clearConversations();
      
      // 保存新会话到本地
      await localDataSource.saveConversations(conversationModels);
      
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