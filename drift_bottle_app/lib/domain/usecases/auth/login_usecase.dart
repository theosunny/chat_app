import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 登录用例
@lazySingleton
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // 验证参数
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(ValidationFailure(message: validationResult));
    }
    
    // 执行登录
    return await repository.login(
      username: params.identifier,
      password: params.password,
    );
  }
  
  /// 验证登录参数
  String? _validateParams(LoginParams params) {
    if (params.identifier.trim().isEmpty) {
      return '用户名/邮箱/手机号不能为空';
    }
    
    if (params.password.trim().isEmpty) {
      return '密码不能为空';
    }
    
    if (params.password.length < 6) {
      return '密码长度不能少于6位';
    }
    
    // 根据登录类型验证格式
    switch (params.loginType) {
      case LoginType.email:
        if (!_isValidEmail(params.identifier)) {
          return '邮箱格式不正确';
        }
        break;
      case LoginType.phone:
        if (!_isValidPhone(params.identifier)) {
          return '手机号格式不正确';
        }
        break;
      case LoginType.username:
        if (!_isValidUsername(params.identifier)) {
          return '用户名格式不正确';
        }
        break;
    }
    
    return null;
  }
  
  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// 验证手机号格式
  bool _isValidPhone(String phone) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }
  
  /// 验证用户名格式
  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(username);
  }
}

/// 登录参数
class LoginParams {
  final String identifier; // 用户名/邮箱/手机号
  final String password;
  final LoginType loginType;
  final Map<String, dynamic>? deviceInfo;
  
  const LoginParams({
    required this.identifier,
    required this.password,
    required this.loginType,
    this.deviceInfo,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginParams &&
        other.identifier == identifier &&
        other.password == password &&
        other.loginType == loginType &&
        other.deviceInfo == deviceInfo;
  }
  
  @override
  int get hashCode {
    return identifier.hashCode ^
        password.hashCode ^
        loginType.hashCode ^
        deviceInfo.hashCode;
  }
  
  @override
  String toString() {
    return 'LoginParams(identifier: $identifier, loginType: $loginType, deviceInfo: $deviceInfo)';
  }
  
  LoginParams copyWith({
    String? identifier,
    String? password,
    LoginType? loginType,
    Map<String, dynamic>? deviceInfo,
  }) {
    return LoginParams(
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
      loginType: loginType ?? this.loginType,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }
}

/// 登录类型
enum LoginType {
  /// 用户名登录
  username,
  
  /// 邮箱登录
  email,
  
  /// 手机号登录
  phone,
}

/// 登录类型扩展
extension LoginTypeExtension on LoginType {
  String get displayText {
    switch (this) {
      case LoginType.username:
        return '用户名';
      case LoginType.email:
        return '邮箱';
      case LoginType.phone:
        return '手机号';
    }
  }
  
  String get placeholder {
    switch (this) {
      case LoginType.username:
        return '请输入用户名';
      case LoginType.email:
        return '请输入邮箱地址';
      case LoginType.phone:
        return '请输入手机号';
    }
  }
  
  String get inputHint {
    switch (this) {
      case LoginType.username:
        return '用户名由字母、数字、下划线组成，3-20位';
      case LoginType.email:
        return '请输入有效的邮箱地址';
      case LoginType.phone:
        return '请输入11位手机号码';
    }
  }
}