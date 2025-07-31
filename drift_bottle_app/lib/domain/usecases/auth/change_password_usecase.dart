import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 修改密码用例
@lazySingleton
class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final AuthRepository repository;
  
  ChangePasswordUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    // 验证参数
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(Failure.validation(message: validationResult));
    }
    
    // 执行修改密码
    return await repository.changePassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
  
  /// 验证修改密码参数
  String? _validateParams(ChangePasswordParams params) {
    if (params.oldPassword.trim().isEmpty) {
      return '原密码不能为空';
    }
    
    if (params.newPassword.trim().isEmpty) {
      return '新密码不能为空';
    }
    
    if (params.newPassword.length < 6) {
      return '新密码长度不能少于6位';
    }
    
    if (params.newPassword.length > 20) {
      return '新密码长度不能超过20位';
    }
    
    if (params.oldPassword == params.newPassword) {
      return '新密码不能与原密码相同';
    }
    
    // 验证新密码格式（必须包含字母和数字）
    if (!_isValidPassword(params.newPassword)) {
      return '新密码必须包含字母和数字，长度6-20位';
    }
    
    return null;
  }
  
  /// 验证密码格式
  bool _isValidPassword(String password) {
    // 必须包含字母和数字
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,20}$').hasMatch(password);
  }
}

/// 修改密码参数
class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;
  
  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ChangePasswordParams &&
        other.oldPassword == oldPassword &&
        other.newPassword == newPassword;
  }
  
  @override
  int get hashCode => oldPassword.hashCode ^ newPassword.hashCode;
  
  @override
  String toString() {
    return 'ChangePasswordParams(oldPassword: [HIDDEN], newPassword: [HIDDEN])';
  }
  
  ChangePasswordParams copyWith({
    String? oldPassword,
    String? newPassword,
  }) {
    return ChangePasswordParams(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
    );
  }
}