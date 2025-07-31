import 'package:dartz/dartz.dart';
import '../../entities/conversation.dart';
import '../../repositories/conversation_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

/// 获取会话列表用例参数
class GetConversationsParams {
  final int page;
  final int limit;
  final bool forceRefresh;

  const GetConversationsParams({
    this.page = 1,
    this.limit = 20,
    this.forceRefresh = false,
  });
}

/// 获取会话列表用例
class GetConversationsUseCase implements UseCase<List<Conversation>, GetConversationsParams> {
  final ConversationRepository repository;

  const GetConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Conversation>>> call(GetConversationsParams params) async {
    if (params.forceRefresh || params.page == 1) {
      // 强制刷新或第一页时，从远程获取
      final remoteResult = await repository.getConversations(
        page: params.page,
        limit: params.limit,
      );

      return remoteResult.fold(
        (failure) async {
          // 远程获取失败，尝试从本地获取
          return await repository.getConversationsFromLocal(
            page: params.page,
            limit: params.limit,
          );
        },
        (conversations) async {
          // 远程获取成功，保存到本地
          for (final conversation in conversations) {
            await repository.saveConversationToLocal(conversation);
          }
          return Right(conversations);
        },
      );
    } else {
      // 非第一页时，优先从本地获取
      final localResult = await repository.getConversationsFromLocal(
        page: params.page,
        limit: params.limit,
      );

      return localResult.fold(
        (failure) async {
          // 本地获取失败，从远程获取
          return await repository.getConversations(
            page: params.page,
            limit: params.limit,
          );
        },
        (localConversations) async {
          if (localConversations.isNotEmpty) {
            return Right(localConversations);
          } else {
            // 本地没有数据，从远程获取
            return await repository.getConversations(
              page: params.page,
              limit: params.limit,
            );
          }
        },
      );
    }
  }
}