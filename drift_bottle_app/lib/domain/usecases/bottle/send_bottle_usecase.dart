import 'package:dartz/dartz.dart';
import '../../entities/bottle.dart';
import '../../repositories/bottle_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 发送漂流瓶用例
class SendBottleUseCase implements UseCase<Bottle, SendBottleParams> {
  final BottleRepository repository;
  
  SendBottleUseCase(this.repository);
  
  @override
  Future<Either<Failure, Bottle>> call(SendBottleParams params) async {
    // 验证参数
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }
    
    // 执行发送
    return await repository.sendBottle(
      content: params.content,
      contentType: params.contentType,
      mediaFiles: params.mediaFiles,
      tags: params.tags,
      isAnonymous: params.isAnonymous,
      isPrivate: params.isPrivate,
      validDuration: params.validDuration,
      maxDistance: params.maxDistance,
      priority: params.priority,
      location: params.location,
    );
  }
  
  /// 验证发送参数
  String? _validateParams(SendBottleParams params) {
    // 验证内容
    if (params.content.trim().isEmpty && 
        (params.mediaFiles == null || params.mediaFiles!.isEmpty)) {
      return '漂流瓶内容不能为空';
    }
    
    // 验证文本内容长度
    if (params.content.trim().isNotEmpty) {
      if (params.content.length > 1000) {
        return '文本内容不能超过1000字符';
      }
      if (params.content.length < 5) {
        return '文本内容不能少于5个字符';
      }
    }
    
    // 验证媒体文件
    if (params.mediaFiles != null && params.mediaFiles!.isNotEmpty) {
      if (params.mediaFiles!.length > 9) {
        return '最多只能上传9个媒体文件';
      }
      
      // 验证文件大小
      for (final file in params.mediaFiles!) {
        if (file.size > 50 * 1024 * 1024) { // 50MB
          return '单个文件大小不能超过50MB';
        }
      }
    }
    
    // 验证标签
    if (params.tags != null && params.tags!.isNotEmpty) {
      if (params.tags!.length > 5) {
        return '最多只能添加5个标签';
      }
      
      for (final tag in params.tags!) {
        if (tag.trim().isEmpty) {
          return '标签不能为空';
        }
        if (tag.length > 20) {
          return '单个标签长度不能超过20个字符';
        }
      }
    }
    
    // 验证有效期
    if (params.validDuration != null) {
      if (params.validDuration!.inMinutes < 30) {
        return '有效期不能少于30分钟';
      }
      if (params.validDuration!.inDays > 30) {
        return '有效期不能超过30天';
      }
    }
    
    // 验证最大漂流距离
    if (params.maxDistance != null) {
      if (params.maxDistance! < 1000) {
        return '最大漂流距离不能少于1公里';
      }
      if (params.maxDistance! > 10000000) {
        return '最大漂流距离不能超过10000公里';
      }
    }
    
    return null;
  }
}

/// 发送漂流瓶参数
class SendBottleParams {
  final String content;
  final BottleContentType contentType;
  final List<BottleMedia>? mediaFiles;
  final List<String>? tags;
  final bool isAnonymous;
  final bool isPrivate;
  final Duration? validDuration;
  final double? maxDistance;
  final BottlePriority priority;
  final BottleLocation? location;
  
  const SendBottleParams({
    required this.content,
    this.contentType = BottleContentType.text,
    this.mediaFiles,
    this.tags,
    this.isAnonymous = false,
    this.isPrivate = false,
    this.validDuration,
    this.maxDistance,
    this.priority = BottlePriority.normal,
    this.location,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SendBottleParams &&
        other.content == content &&
        other.contentType == contentType &&
        other.mediaFiles == mediaFiles &&
        other.tags == tags &&
        other.isAnonymous == isAnonymous &&
        other.isPrivate == isPrivate &&
        other.validDuration == validDuration &&
        other.maxDistance == maxDistance &&
        other.priority == priority &&
        other.location == location;
  }
  
  @override
  int get hashCode {
    return content.hashCode ^
        contentType.hashCode ^
        mediaFiles.hashCode ^
        tags.hashCode ^
        isAnonymous.hashCode ^
        isPrivate.hashCode ^
        validDuration.hashCode ^
        maxDistance.hashCode ^
        priority.hashCode ^
        location.hashCode;
  }
  
  @override
  String toString() {
    return 'SendBottleParams(content: $content, contentType: $contentType, mediaFiles: $mediaFiles, tags: $tags, isAnonymous: $isAnonymous, isPrivate: $isPrivate, validDuration: $validDuration, maxDistance: $maxDistance, priority: $priority, location: $location)';
  }
  
  SendBottleParams copyWith({
    String? content,
    BottleContentType? contentType,
    List<BottleMedia>? mediaFiles,
    List<String>? tags,
    bool? isAnonymous,
    bool? isPrivate,
    Duration? validDuration,
    double? maxDistance,
    BottlePriority? priority,
    BottleLocation? location,
  }) {
    return SendBottleParams(
      content: content ?? this.content,
      contentType: contentType ?? this.contentType,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      tags: tags ?? this.tags,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isPrivate: isPrivate ?? this.isPrivate,
      validDuration: validDuration ?? this.validDuration,
      maxDistance: maxDistance ?? this.maxDistance,
      priority: priority ?? this.priority,
      location: location ?? this.location,
    );
  }
}