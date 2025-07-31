import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/storage/token_storage.dart';
import '../../core/di/injection.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  final TokenStorage _tokenStorage;
  
  User? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  
  AuthProvider(this._authRepository, this._tokenStorage) {
    _checkLoginStatus();
  }
  
  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  
  /// 检查登录状态
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final result = await _authRepository.getCurrentUser();
        result.fold(
          (failure) {
            _isLoggedIn = false;
            _user = null;
          },
          (user) {
            _isLoggedIn = true;
            _user = user;
          },
        );
      } else {
        _isLoggedIn = false;
        _user = null;
      }
    } catch (e) {
      _isLoggedIn = false;
      _user = null;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// 发送验证码
  Future<String?> sendVerificationCode(String phone, {String type = 'login'}) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _authRepository.sendVerificationCode(
      phone: phone,
      type: type,
    );
    
    _isLoading = false;
    notifyListeners();
    
    return result.fold(
      (failure) => failure.message,
      (_) => null,
    );
  }
  
  /// 手机号登录
  Future<String?> loginWithPhone({
    required String phone,
    required String verificationCode,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _authRepository.loginWithPhone(
      phone: phone,
      verificationCode: verificationCode,
    );
    
    result.fold(
      (failure) {
        _isLoggedIn = false;
        _user = null;
      },
      (user) {
        _isLoggedIn = true;
        _user = user;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    
    return result.fold(
      (failure) => failure.message,
      (_) => null,
    );
  }
  
  /// QQ登录
  Future<String?> loginWithQQ(String accessToken) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _authRepository.loginWithThirdParty(
      provider: 'qq',
      accessToken: accessToken,
    );
    
    result.fold(
      (failure) {
        _isLoggedIn = false;
        _user = null;
      },
      (user) {
        _isLoggedIn = true;
        _user = user;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    
    return result.fold(
      (failure) => failure.message,
      (_) => null,
    );
  }
  
  /// 微信登录
  Future<String?> loginWithWechat(String accessToken) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _authRepository.loginWithThirdParty(
      provider: 'wechat',
      accessToken: accessToken,
    );
    
    result.fold(
      (failure) {
        _isLoggedIn = false;
        _user = null;
      },
      (user) {
        _isLoggedIn = true;
        _user = user;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    
    return result.fold(
      (failure) => failure.message,
      (_) => null,
    );
  }
  
  /// 登出
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    await _authRepository.logout();
    
    _isLoggedIn = false;
    _user = null;
    _isLoading = false;
    notifyListeners();
  }
  
  /// 更新用户资料
  Future<String?> updateProfile({
    String? nickname,
    String? avatar,
    String? signature,
    int? gender,
    DateTime? birthday,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _authRepository.updateUserProfile(
      nickname: nickname,
      avatar: avatar,
      bio: signature,
      gender: gender,
      birthday: birthday,
    );
    
    result.fold(
      (failure) {},
      (user) {
        _user = user;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    
    return result.fold(
      (failure) => failure.message,
      (_) => null,
    );
  }
}