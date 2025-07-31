import 'package:equatable/equatable.dart';

/// 基础失败类
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  
  const Failure(this.message, {this.code});
  
  @override
  List<Object?> get props => [message, code];
}

/// 服务器错误
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// 网络错误
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// 缓存错误
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// 验证错误
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// 权限错误
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

/// 未知错误
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}