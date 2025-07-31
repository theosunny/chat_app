import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

/// API响应模型
@JsonSerializable(genericArgumentFactories: true)
class ApiResponseModel<T> {
  @JsonKey(name: 'success')
  final bool success;
  
  @JsonKey(name: 'code')
  final int code;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'data')
  final T? data;
  
  @JsonKey(name: 'errors')
  final List<String>? errors;
  
  @JsonKey(name: 'timestamp')
  final DateTime? timestamp;
  
  @JsonKey(name: 'request_id')
  final String? requestId;
  
  @JsonKey(name: 'pagination')
  final PaginationModel? pagination;
  
  const ApiResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
    this.errors,
    this.timestamp,
    this.requestId,
    this.pagination,
  });
  
  /// 从JSON创建模型
  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseModelFromJson(json, fromJsonT);
  
  /// 转换为JSON
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$ApiResponseModelToJson(this, toJsonT);
  
  /// 创建成功响应
  factory ApiResponseModel.success({
    required T data,
    String message = 'Success',
    int code = 200,
    PaginationModel? pagination,
    String? requestId,
  }) {
    return ApiResponseModel(
      success: true,
      code: code,
      message: message,
      data: data,
      timestamp: DateTime.now(),
      requestId: requestId,
      pagination: pagination,
    );
  }
  
  /// 创建错误响应
  factory ApiResponseModel.error({
    required String message,
    int code = 400,
    List<String>? errors,
    String? requestId,
  }) {
    return ApiResponseModel(
      success: false,
      code: code,
      message: message,
      errors: errors,
      timestamp: DateTime.now(),
      requestId: requestId,
    );
  }
  
  /// 检查是否为成功响应
  bool get isSuccess => success && code >= 200 && code < 300;
  
  /// 检查是否为错误响应
  bool get isError => !success || code >= 400;
  
  /// 检查是否为客户端错误
  bool get isClientError => code >= 400 && code < 500;
  
  /// 检查是否为服务器错误
  bool get isServerError => code >= 500;
  
  /// 检查是否为认证错误
  bool get isAuthError => code == 401 || code == 403;
  
  /// 检查是否为网络错误
  bool get isNetworkError => code == 0 || code == -1;
  
  /// 获取错误信息
  String get errorMessage {
    if (errors != null && errors!.isNotEmpty) {
      return errors!.join(', ');
    }
    return message;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ApiResponseModel<T> &&
        other.success == success &&
        other.code == code &&
        other.message == message &&
        other.data == data &&
        other.errors == errors &&
        other.timestamp == timestamp &&
        other.requestId == requestId &&
        other.pagination == pagination;
  }
  
  @override
  int get hashCode {
    return success.hashCode ^
        code.hashCode ^
        message.hashCode ^
        data.hashCode ^
        errors.hashCode ^
        timestamp.hashCode ^
        requestId.hashCode ^
        pagination.hashCode;
  }
  
  @override
  String toString() {
    return 'ApiResponseModel(success: $success, code: $code, message: $message, data: $data)';
  }
}

/// 分页模型
@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'current_page')
  final int currentPage;
  
  @JsonKey(name: 'per_page')
  final int perPage;
  
  @JsonKey(name: 'total_pages')
  final int totalPages;
  
  @JsonKey(name: 'total_count')
  final int totalCount;
  
  @JsonKey(name: 'has_next')
  final bool hasNext;
  
  @JsonKey(name: 'has_prev')
  final bool hasPrev;
  
  @JsonKey(name: 'next_cursor')
  final String? nextCursor;
  
  @JsonKey(name: 'prev_cursor')
  final String? prevCursor;
  
  const PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.totalPages,
    required this.totalCount,
    required this.hasNext,
    required this.hasPrev,
    this.nextCursor,
    this.prevCursor,
  });
  
  /// 从JSON创建模型
  factory PaginationModel.fromJson(Map<String, dynamic> json) => _$PaginationModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
  
  /// 复制并修改
  PaginationModel copyWith({
    int? currentPage,
    int? perPage,
    int? totalPages,
    int? totalCount,
    bool? hasNext,
    bool? hasPrev,
    String? nextCursor,
    String? prevCursor,
  }) {
    return PaginationModel(
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      hasNext: hasNext ?? this.hasNext,
      hasPrev: hasPrev ?? this.hasPrev,
      nextCursor: nextCursor ?? this.nextCursor,
      prevCursor: prevCursor ?? this.prevCursor,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is PaginationModel &&
        other.currentPage == currentPage &&
        other.perPage == perPage &&
        other.totalPages == totalPages &&
        other.totalCount == totalCount &&
        other.hasNext == hasNext &&
        other.hasPrev == hasPrev &&
        other.nextCursor == nextCursor &&
        other.prevCursor == prevCursor;
  }
  
  @override
  int get hashCode {
    return currentPage.hashCode ^
        perPage.hashCode ^
        totalPages.hashCode ^
        totalCount.hashCode ^
        hasNext.hashCode ^
        hasPrev.hashCode ^
        nextCursor.hashCode ^
        prevCursor.hashCode;
  }
  
  @override
  String toString() {
    return 'PaginationModel(currentPage: $currentPage, totalPages: $totalPages, totalCount: $totalCount, hasNext: $hasNext)';
  }
}

/// 文件上传响应模型
@JsonSerializable()
class FileUploadResponseModel {
  @JsonKey(name: 'file_id')
  final String fileId;
  
  @JsonKey(name: 'file_name')
  final String fileName;
  
  @JsonKey(name: 'file_url')
  final String fileUrl;
  
  @JsonKey(name: 'file_size')
  final int fileSize;
  
  @JsonKey(name: 'file_type')
  final String fileType;
  
  @JsonKey(name: 'mime_type')
  final String mimeType;
  
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  
  @JsonKey(name: 'duration')
  final int? duration;
  
  @JsonKey(name: 'width')
  final int? width;
  
  @JsonKey(name: 'height')
  final int? height;
  
  @JsonKey(name: 'uploaded_at')
  final DateTime uploadedAt;
  
  const FileUploadResponseModel({
    required this.fileId,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.fileType,
    required this.mimeType,
    this.thumbnailUrl,
    this.duration,
    this.width,
    this.height,
    required this.uploadedAt,
  });
  
  /// 从JSON创建模型
  factory FileUploadResponseModel.fromJson(Map<String, dynamic> json) => _$FileUploadResponseModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$FileUploadResponseModelToJson(this);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is FileUploadResponseModel &&
        other.fileId == fileId &&
        other.fileName == fileName &&
        other.fileUrl == fileUrl &&
        other.fileSize == fileSize &&
        other.fileType == fileType &&
        other.mimeType == mimeType &&
        other.thumbnailUrl == thumbnailUrl &&
        other.duration == duration &&
        other.width == width &&
        other.height == height &&
        other.uploadedAt == uploadedAt;
  }
  
  @override
  int get hashCode {
    return fileId.hashCode ^
        fileName.hashCode ^
        fileUrl.hashCode ^
        fileSize.hashCode ^
        fileType.hashCode ^
        mimeType.hashCode ^
        thumbnailUrl.hashCode ^
        duration.hashCode ^
        width.hashCode ^
        height.hashCode ^
        uploadedAt.hashCode;
  }
  
  @override
  String toString() {
    return 'FileUploadResponseModel(fileId: $fileId, fileName: $fileName, fileSize: $fileSize)';
  }
}

/// 令牌响应模型
@JsonSerializable()
class TokenResponseModel {
  @JsonKey(name: 'access_token')
  final String accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  
  @JsonKey(name: 'token_type')
  final String tokenType;
  
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  
  @JsonKey(name: 'scope')
  final String? scope;
  
  const TokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.expiresAt,
    this.scope,
  });
  
  /// 从JSON创建模型
  factory TokenResponseModel.fromJson(Map<String, dynamic> json) => _$TokenResponseModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$TokenResponseModelToJson(this);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is TokenResponseModel &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.tokenType == tokenType &&
        other.expiresIn == expiresIn &&
        other.expiresAt == expiresAt &&
        other.scope == scope;
  }
  
  @override
  int get hashCode {
    return accessToken.hashCode ^
        refreshToken.hashCode ^
        tokenType.hashCode ^
        expiresIn.hashCode ^
        expiresAt.hashCode ^
        scope.hashCode;
  }
  
  @override
  String toString() {
    return 'TokenResponseModel(tokenType: $tokenType, expiresIn: $expiresIn)';
  }
}