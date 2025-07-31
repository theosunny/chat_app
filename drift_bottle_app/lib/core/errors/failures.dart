import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// 应用错误基类
@freezed
class Failure with _$Failure {
  /// 网络错误
  const factory Failure.network({
    required String message,
    int? statusCode,
    String? errorCode,
  }) = NetworkFailure;
  
  /// 服务器错误
  const factory Failure.server({
    required String message,
    int? statusCode,
    String? errorCode,
  }) = ServerFailure;
  
  /// 缓存错误
  const factory Failure.cache({
    required String message,
    String? errorCode,
  }) = CacheFailure;
  
  /// 认证错误
  const factory Failure.auth({
    required String message,
    String? errorCode,
  }) = AuthFailure;
  
  /// 验证错误
  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationFailure;
  
  /// 权限错误
  const factory Failure.permission({
    required String message,
    String? permission,
  }) = PermissionFailure;
  
  /// 未知错误
  const factory Failure.unknown({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = UnknownFailure;
}

/// 错误扩展方法
extension FailureExtension on Failure {
  /// 获取用户友好的错误消息
  String get userMessage {
    return when(
      network: (message, statusCode, errorCode) {
        if (statusCode == 404) return '请求的资源不存在';
        if (statusCode == 500) return '服务器内部错误，请稍后重试';
        if (statusCode == 401) return '登录已过期，请重新登录';
        if (statusCode == 403) return '没有权限访问此资源';
        return '网络连接失败，请检查网络设置';
      },
      server: (message, statusCode, errorCode) => '服务器错误：$message',
      cache: (message, errorCode) => '本地数据错误：$message',
      auth: (message, errorCode) => '认证失败：$message',
      validation: (message, errors) => message,
      permission: (message, permission) => '权限不足：$message',
      unknown: (message, error, stackTrace) => '未知错误：$message',
    );
  }
  
  /// 是否为网络相关错误
  bool get isNetworkError {
    return when(
      network: (_, __, ___) => true,
      server: (_, __, ___) => true,
      auth: (_, __) => true,
      cache: (_, __) => false,
      validation: (_, __) => false,
      permission: (_, __) => false,
      unknown: (_, __, ___) => false,
    );
  }
  
  /// 是否需要重新登录
  bool get requiresReauth {
    return when(
      network: (_, statusCode, __) => statusCode == 401,
      server: (_, statusCode, __) => statusCode == 401,
      auth: (_, __) => true,
      cache: (_, __) => false,
      validation: (_, __) => false,
      permission: (_, __) => false,
      unknown: (_, __, ___) => false,
    );
  }
}