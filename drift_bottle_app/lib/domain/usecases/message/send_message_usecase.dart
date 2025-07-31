import 'package:dartz/dartz.dart';
import '../../entities/message.dart';
import '../../repositories/message_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 发送消息用例
class SendMessageUseCase implements UseCase<Message, SendMessageParams> {
  final MessageRepository repository;
  
  SendMessageUseCase(this.repository);
  
  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    // 验证参数
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }
    
    // 根据消息类型发送消息
    switch (params.type) {
      case MessageType.text:
        return await repository.sendTextMessage(
          conversationId: params.conversationId,
          content: params.content,
          replyToMessageId: params.replyToMessageId,
          mentionedUserIds: params.mentionedUserIds,
        );
      case MessageType.image:
        return await repository.sendImageMessage(
          conversationId: params.conversationId,
          imagePath: params.filePath!,
          caption: params.content.isNotEmpty ? params.content : null,
          replyToMessageId: params.replyToMessageId,
        );
      case MessageType.audio:
        return await repository.sendAudioMessage(
          conversationId: params.conversationId,
          audioPath: params.filePath!,
          duration: params.duration!,
          replyToMessageId: params.replyToMessageId,
        );
      case MessageType.video:
        return await repository.sendVideoMessage(
          conversationId: params.conversationId,
          videoPath: params.filePath!,
          thumbnailPath: params.thumbnailPath,
          duration: params.duration,
          replyToMessageId: params.replyToMessageId,
        );
      case MessageType.file:
        return await repository.sendFileMessage(
          conversationId: params.conversationId,
          filePath: params.filePath!,
          fileName: params.fileName,
          replyToMessageId: params.replyToMessageId,
        );
      case MessageType.location:
        return await repository.sendLocationMessage(
          conversationId: params.conversationId,
          latitude: params.latitude!,
          longitude: params.longitude!,
          address: params.address,
          replyToMessageId: params.replyToMessageId,
        );
      default:
        return await repository.sendMessage(
          conversationId: params.conversationId,
          content: params.content,
          type: params.type,
          media: params.media,
          replyToMessageId: params.replyToMessageId,
          mentionedUserIds: params.mentionedUserIds,
        );
    }
  }
  
  /// 验证参数
  String? _validateParams(SendMessageParams params) {
    // 验证会话ID
    if (params.conversationId.trim().isEmpty) {
      return '会话ID不能为空';
    }
    
    // 根据消息类型验证参数
    switch (params.type) {
      case MessageType.text:
        if (params.content.trim().isEmpty) {
          return '文本消息内容不能为空';
        }
        if (params.content.length > 5000) {
          return '文本消息长度不能超过5000字符';
        }
        break;
        
      case MessageType.image:
      case MessageType.audio:
      case MessageType.video:
      case MessageType.file:
        if (params.filePath == null || params.filePath!.trim().isEmpty) {
          return '文件路径不能为空';
        }
        break;
        
      case MessageType.location:
        if (params.latitude == null || params.longitude == null) {
          return '位置信息不能为空';
        }
        if (params.latitude! < -90 || params.latitude! > 90) {
          return '纬度范围必须在-90到90之间';
        }
        if (params.longitude! < -180 || params.longitude! > 180) {
          return '经度范围必须在-180到180之间';
        }
        break;
        
      default:
        if (params.content.trim().isEmpty && params.media == null) {
          return '消息内容不能为空';
        }
        break;
    }
    
    // 验证提及用户
    if (params.mentionedUserIds != null && params.mentionedUserIds!.length > 20) {
      return '单条消息最多只能@20个用户';
    }
    
    return null;
  }
}

/// 发送消息参数
class SendMessageParams {
  final String conversationId;
  final String content;
  final MessageType type;
  final MessageMedia? media;
  final String? replyToMessageId;
  final List<String>? mentionedUserIds;
  final String? filePath;
  final String? fileName;
  final String? thumbnailPath;
  final int? duration;
  final double? latitude;
  final double? longitude;
  final String? address;
  
  const SendMessageParams({
    required this.conversationId,
    this.content = '',
    required this.type,
    this.media,
    this.replyToMessageId,
    this.mentionedUserIds,
    this.filePath,
    this.fileName,
    this.thumbnailPath,
    this.duration,
    this.latitude,
    this.longitude,
    this.address,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SendMessageParams &&
        other.conversationId == conversationId &&
        other.content == content &&
        other.type == type &&
        other.media == media &&
        other.replyToMessageId == replyToMessageId &&
        other.mentionedUserIds == mentionedUserIds &&
        other.filePath == filePath &&
        other.fileName == fileName &&
        other.thumbnailPath == thumbnailPath &&
        other.duration == duration &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address;
  }
  
  @override
  int get hashCode {
    return conversationId.hashCode ^
        content.hashCode ^
        type.hashCode ^
        media.hashCode ^
        replyToMessageId.hashCode ^
        mentionedUserIds.hashCode ^
        filePath.hashCode ^
        fileName.hashCode ^
        thumbnailPath.hashCode ^
        duration.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        address.hashCode;
  }
  
  @override
  String toString() {
    return 'SendMessageParams(conversationId: $conversationId, content: $content, type: $type, media: $media, replyToMessageId: $replyToMessageId, mentionedUserIds: $mentionedUserIds, filePath: $filePath, fileName: $fileName, thumbnailPath: $thumbnailPath, duration: $duration, latitude: $latitude, longitude: $longitude, address: $address)';
  }
  
  SendMessageParams copyWith({
    String? conversationId,
    String? content,
    MessageType? type,
    MessageMedia? media,
    String? replyToMessageId,
    List<String>? mentionedUserIds,
    String? filePath,
    String? fileName,
    String? thumbnailPath,
    int? duration,
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return SendMessageParams(
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      type: type ?? this.type,
      media: media ?? this.media,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      duration: duration ?? this.duration,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
}