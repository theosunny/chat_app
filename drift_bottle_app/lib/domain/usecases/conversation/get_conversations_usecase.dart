import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../entities/message.dart';
import '../../repositories/message_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 获取会话列表用例
@lazySingleton
class GetConversationsUseCase implements UseCase<List<Conversation>, GetConversationsParams> {
  final MessageRepository repository;
  
  GetConversationsUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Conversation>>> call(GetConversationsParams params) async {
    return await repository.getConversations(
      offset: params.page != null ? (params.page! - 1) * (params.limit ?? 20) : null,
      limit: params.limit,
      type: params.type,
    );
  }
}

/// 获取会话列表参数
class GetConversationsParams {
  final int page;
  final int limit;
  final ConversationType? type;
  
  const GetConversationsParams({
    this.page = 1,
    this.limit = 20,
    this.type,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is GetConversationsParams &&
        other.page == page &&
        other.limit == limit &&
        other.type == type;
  }
  
  @override
  int get hashCode => page.hashCode ^ limit.hashCode ^ type.hashCode;
  
  @override
  String toString() {
    return 'GetConversationsParams(page: $page, limit: $limit, type: $type)';
  }
  
  GetConversationsParams copyWith({
    int? page,
    int? limit,
    String? type,
  }) {
    return GetConversationsParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      type: type ?? this.type,
    );
  }
}