/// 应用异常基类
abstract class AppException implements Exception {
  final String message;
  final String? errorCode;
  
  const AppException(this.message, [this.errorCode]);
  
  @override
  String toString() => 'AppException: $message${errorCode != null ? ' (Code: $errorCode)' : ''}';
}

/// 网络异常
class NetworkException extends AppException {
  final int? statusCode;
  
  const NetworkException(super.message, [super.errorCode, this.statusCode]);
  
  @override
  String toString() => 'NetworkException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}${errorCode != null ? ' (Code: $errorCode)' : ''}';
}

/// 服务器异常
class ServerException extends AppException {
  final int? statusCode;
  final Map<String, dynamic>? data;
  
  const ServerException(super.message, [super.errorCode, this.statusCode, this.data]);
  
  @override
  String toString() => 'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}${errorCode != null ? ' (Code: $errorCode)' : ''}';
}

/// 缓存异常
class CacheException extends AppException {
  const CacheException(super.message, [super.errorCode]);
  
  @override
  String toString() => 'CacheException: $message${errorCode != null ? ' (Code: $errorCode)' : ''}';
}

/// 认证异常
class AuthException extends AppException {
  const AuthException(super.message, [super.errorCode]);
  
  @override
  String toString() => 'AuthException: $message${errorCode != null ? ' (Code: $errorCode)' : ''}';
}

/// 验证异常
class ValidationException extends AppException {
  final Map<String, String>? errors;
  
  const ValidationException(super.message, [super.errorCode, this.errors]);
  
  @override
  String toString() => 'ValidationException: $message${errorCode != null ? ' (Code: $errorCode)' : ''}${errors != null ? ' (Errors: $errors)' : ''}';
}

/// 权限异常
class PermissionException extends AppException {
  final String? permission;
  
  const PermissionException(super.message, [super.errorCode, this.permission]);
  
  @override
  String toString() => 'PermissionException: $message${permission != null ? ' (Permission: $permission)' : ''}${errorCode != null ? ' (Code: $errorCode)' : ''}';
}

/// 文件异常
class FileException extends AppException {
  final String? filePath;
  
  const FileException(super.message, [super.errorCode, this.filePath]);
  
  @override
  String toString() => 'FileException: $message${filePath != null ? ' (File: $filePath)' : ''}${errorCode != null ? ' (Code: $errorCode)' : ''}';
}

/// 解析异常
class ParseException extends AppException {
  final Object? originalError;
  
  const ParseException(super.message, [super.errorCode, this.originalError]);
  
  @override
  String toString() => 'ParseException: $message${errorCode != null ? ' (Code: $errorCode)' : ''}${originalError != null ? ' (Original: $originalError)' : ''}';
}