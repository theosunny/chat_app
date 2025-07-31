import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 注册用例
@lazySingleton
class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;
  
  RegisterUseCase(this.repository);
  
  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    // 验证参数
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(Failure.validation(message: validationResult));
    }
    
    // 执行注册
    return await repository.register(
      username: params.username,
      email: params.email,
      phone: params.phone,
      password: params.password,
      nickname: params.nickname,
      birthday: params.birthday,
      inviteCode: params.inviteCode,
      deviceInfo: params.deviceInfo,
    );
  }
  
  /// 验证注册参数
  String? _validateParams(RegisterParams params) {
    // 验证用户名
    if (params.username.trim().isEmpty) {
      return '用户名不能为空';
    }
    if (!_isValidUsername(params.username)) {
      return '用户名格式不正确，只能包含字母、数字、下划线，长度3-20位';
    }
    
    // 验证邮箱
    if (params.email != null && params.email!.trim().isNotEmpty) {
      if (!_isValidEmail(params.email!)) {
        return '邮箱格式不正确';
      }
    }
    
    // 验证手机号
    if (params.phone != null && params.phone!.trim().isNotEmpty) {
      if (!_isValidPhone(params.phone!)) {
        return '手机号格式不正确';
      }
    }
    
    // 至少需要邮箱或手机号其中一个
    if ((params.email == null || params.email!.trim().isEmpty) &&
        (params.phone == null || params.phone!.trim().isEmpty)) {
      return '邮箱和手机号至少填写一个';
    }
    
    // 验证密码
    if (params.password.trim().isEmpty) {
      return '密码不能为空';
    }
    if (params.password.length < 6) {
      return '密码长度不能少于6位';
    }
    if (params.password.length > 20) {
      return '密码长度不能超过20位';
    }
    if (!_isValidPassword(params.password)) {
      return '密码必须包含字母和数字';
    }
    
    // 验证确认密码
    if (params.confirmPassword != params.password) {
      return '两次输入的密码不一致';
    }
    
    // 验证昵称
    if (params.nickname != null && params.nickname!.trim().isNotEmpty) {
      if (params.nickname!.length > 20) {
        return '昵称长度不能超过20位';
      }
      if (!_isValidNickname(params.nickname!)) {
        return '昵称包含非法字符';
      }
    }
    
    // 验证生日
    if (params.birthday != null) {
      final now = DateTime.now();
      final age = now.year - params.birthday!.year;
      if (age < 13) {
        return '年龄不能小于13岁';
      }
      if (age > 120) {
        return '请输入正确的出生日期';
      }
    }
    
    return null;
  }
  
  /// 验证用户名格式
  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(username);
  }
  
  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// 验证手机号格式
  bool _isValidPhone(String phone) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }
  
  /// 验证密码格式
  bool _isValidPassword(String password) {
    // 必须包含字母和数字
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,20}$').hasMatch(password);
  }
  
  /// 验证昵称格式
  bool _isValidNickname(String nickname) {
    // 不能包含特殊字符，允许中文、英文、数字
    return RegExp(r'^[\u4e00-\u9fa5a-zA-Z0-9\s]{1,20}$').hasMatch(nickname);
  }
}

/// 注册参数
class RegisterParams {
  final String username;
  final String? email;
  final String? phone;
  final String password;
  final String confirmPassword;
  final String? nickname;
  final String? avatar;
  final String? gender;
  final DateTime? birthday;
  final String? inviteCode;
  final Map<String, dynamic>? deviceInfo;
  
  const RegisterParams({
    required this.username,
    this.email,
    this.phone,
    required this.password,
    required this.confirmPassword,
    this.nickname,
    this.avatar,
    this.gender,
    this.birthday,
    this.inviteCode,
    this.deviceInfo,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterParams &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.nickname == nickname &&
        other.avatar == avatar &&
        other.gender == gender &&
        other.birthday == birthday &&
        other.inviteCode == inviteCode &&
        other.deviceInfo == deviceInfo;
  }
  
  @override
  int get hashCode {
    return username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        confirmPassword.hashCode ^
        nickname.hashCode ^
        avatar.hashCode ^
        gender.hashCode ^
        birthday.hashCode ^
        inviteCode.hashCode ^
        deviceInfo.hashCode;
  }
  
  @override
  String toString() {
    return 'RegisterParams(username: $username, email: $email, phone: $phone, nickname: $nickname, gender: $gender, birthday: $birthday, inviteCode: $inviteCode, deviceInfo: $deviceInfo)';
  }
  
  RegisterParams copyWith({
    String? username,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    String? nickname,
    String? avatar,
    String? gender,
    DateTime? birthday,
    String? inviteCode,
    Map<String, dynamic>? deviceInfo,
  }) {
    return RegisterParams(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      inviteCode: inviteCode ?? this.inviteCode,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }
}