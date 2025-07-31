import 'package:dartz/dartz.dart';
import '../../entities/message.dart';
import '../../repositories/message_repository.dart';
import '../../repositories/conversation_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

/// 发送消息用例参数
class SendMessageParams {
  final int conversationId;
  final int receiverId;
  final String content;
  final MessageType messageType;

  const SendMessageParams({
    required this.conversationId,
    required this.receiverId,
    required this.content,
    this.messageType = MessageType.text,
  });
}

/// 发送消息用例
class SendMessageUseCase implements UseCase<Message, SendMessageParams> {
  final MessageRepository messageRepository;
  final ConversationRepository conversationRepository;

  const SendMessageUseCase(
    this.messageRepository,
    this.conversationRepository,
  );

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    // 验证输入参数
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('消息内容不能为空'));
    }

    if (params.content.length > 1000) {
      return const Left(ValidationFailure('消息内容不能超过1000个字符'));
    }

    // 发送消息
    final result = await messageRepository.sendMessage(
      conversationId: params.conversationId,
      receiverId: params.receiverId,
      content: params.content.trim(),
      messageType: params.messageType,
    );

    return result.fold(
      (failure) => Left(failure),
      (message) async {
        // 发送成功后更新会话的最后消息信息
        await conversationRepository.updateLastMessage(
          conversationId: params.conversationId,
          messageId: message.id,
          content: message.content,
          timestamp: message.createdAt,
        );

        // 保存消息到本地
        await messageRepository.saveMessageToLocal(message);

        return Right(message);
      },
    );
  }
}