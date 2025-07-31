/// 基础异常类
abstract class AppException implements Exception {
  final String message;
  final int? code;
  
  const AppException(this.message, {this.code});
  
  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// 服务器异常
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

/// 网络异常
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// 缓存异常
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

/// 验证异常
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

/// 权限异常
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});
}

/// 未找到异常
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code});
}

/// 未授权异常
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.code});
}