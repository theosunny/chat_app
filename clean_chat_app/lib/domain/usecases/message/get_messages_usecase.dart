import 'package:dartz/dartz.dart';
import '../../entities/message.dart';
import '../../repositories/message_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

/// 获取消息列表用例参数
class GetMessagesParams {
  final int conversationId;
  final int page;
  final int limit;
  final bool forceRefresh;

  const GetMessagesParams({
    required this.conversationId,
    this.page = 1,
    this.limit = 20,
    this.forceRefresh = false,
  });
}

/// 获取消息列表用例
class GetMessagesUseCase implements UseCase<List<Message>, GetMessagesParams> {
  final MessageRepository repository;

  const GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesParams params) async {
    if (params.forceRefresh || params.page == 1) {
      // 强制刷新或第一页时，从远程获取
      final remoteResult = await repository.getMessages(
        conversationId: params.conversationId,
        page: params.page,
        limit: params.limit,
      );

      return remoteResult.fold(
        (failure) async {
          // 远程获取失败，尝试从本地获取
          return await repository.getMessagesFromLocal(
            conversationId: params.conversationId,
            page: params.page,
            limit: params.limit,
          );
        },
        (messages) async {
          // 远程获取成功，保存到本地
          for (final message in messages) {
            await repository.saveMessageToLocal(message);
          }
          return Right(messages);
        },
      );
    } else {
      // 非第一页时，优先从本地获取
      final localResult = await repository.getMessagesFromLocal(
        conversationId: params.conversationId,
        page: params.page,
        limit: params.limit,
      );

      return localResult.fold(
        (failure) async {
          // 本地获取失败，从远程获取
          return await repository.getMessages(
            conversationId: params.conversationId,
            page: params.page,
            limit: params.limit,
          );
        },
        (localMessages) async {
          if (localMessages.isNotEmpty) {
            return Right(localMessages);
          } else {
            // 本地没有数据，从远程获取
            return await repository.getMessages(
              conversationId: params.conversationId,
              page: params.page,
              limit: params.limit,
            );
          }
        },
      );
    }
  }
}