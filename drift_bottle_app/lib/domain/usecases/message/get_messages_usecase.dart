import 'package:dartz/dartz.dart';
import '../../entities/message.dart';
import '../../repositories/message_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 获取消息列表用例
class GetMessagesUseCase implements UseCase<List<Message>, GetMessagesParams> {
  final MessageRepository repository;
  
  GetMessagesUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesParams params) async {
    // 验证参数
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }
    
    // 获取消息列表
    return await repository.getMessages(
      conversationId: params.conversationId,
      limit: params.limit,
      beforeMessageId: params.beforeMessageId,
      afterMessageId: params.afterMessageId,
    );
  }
  
  /// 验证参数
  String? _validateParams(GetMessagesParams params) {
    // 验证会话ID
    if (params.conversationId.trim().isEmpty) {
      return '会话ID不能为空';
    }
    
    // 验证分页参数
    if (params.limit != null) {
      if (params.limit! <= 0) {
        return '每页数量必须大于0';
      }
      if (params.limit! > 100) {
        return '每页数量不能超过100';
      }
    }
    
    // beforeMessageId 和 afterMessageId 不能同时存在
    if (params.beforeMessageId != null && params.afterMessageId != null) {
      return 'beforeMessageId 和 afterMessageId 不能同时指定';
    }
    
    return null;
  }
}

/// 获取消息列表参数
class GetMessagesParams {
  final String conversationId;
  final int? limit;
  final String? beforeMessageId; // 获取此消息之前的消息
  final String? afterMessageId;  // 获取此消息之后的消息
  
  const GetMessagesParams({
    required this.conversationId,
    this.limit,
    this.beforeMessageId,
    this.afterMessageId,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetMessagesParams &&
        other.conversationId == conversationId &&
        other.limit == limit &&
        other.beforeMessageId == beforeMessageId &&
        other.afterMessageId == afterMessageId;
  }
  
  @override
  int get hashCode {
    return conversationId.hashCode ^
        limit.hashCode ^
        beforeMessageId.hashCode ^
        afterMessageId.hashCode;
  }
  
  @override
  String toString() {
    return 'GetMessagesParams(conversationId: $conversationId, limit: $limit, beforeMessageId: $beforeMessageId, afterMessageId: $afterMessageId)';
  }
  
  GetMessagesParams copyWith({
    String? conversationId,
    int? limit,
    String? beforeMessageId,
    String? afterMessageId,
  }) {
    return GetMessagesParams(
      conversationId: conversationId ?? this.conversationId,
      limit: limit ?? this.limit,
      beforeMessageId: beforeMessageId ?? this.beforeMessageId,
      afterMessageId: afterMessageId ?? this.afterMessageId,
    );
  }
}