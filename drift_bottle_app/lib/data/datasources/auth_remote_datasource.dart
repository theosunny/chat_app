import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

/// 认证远程数据源接口
abstract class AuthRemoteDataSource {
  /// 发送验证码
  Future<void> sendVerificationCode({required String phone, required String type});
  
  /// 手机号登录
  Future<Map<String, dynamic>> loginWithPhone({
    required String phone,
    required String code,
  });
  
  /// 第三方登录
  Future<Map<String, dynamic>> loginWithThirdParty({
    required String provider, // 'qq' or 'wechat'
    required String code,
  });
  
  /// 获取当前用户信息
  Future<UserModel> getCurrentUser();
  
  /// 更新用户信息
  Future<UserModel> updateProfile({
    String? nickname,
    String? avatar,
    String? gender,
    int? age,
    String? location,
    String? signature,
  });
}

/// 认证远程数据源实现
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  
  AuthRemoteDataSourceImpl(this._dioClient);
  
  @override
  Future<void> sendVerificationCode({required String phone, required String type}) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/user/send-code',
        data: {'phone': phone, 'type': type},
      );
      
      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? '发送验证码失败',
          null,
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('发送验证码失败: $e');
    }
  }
  
  @override
  Future<Map<String, dynamic>> loginWithPhone({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/user/login',
        data: {
          'phone': phone,
          'code': code,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'user': UserModel.fromJson(data['user']),
          'token': data['token'],
        };
      } else {
        throw ServerException(
          response.data['message'] ?? '登录失败',
          null,
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('登录失败: $e');
    }
  }
  
  @override
  Future<Map<String, dynamic>> loginWithThirdParty({
    required String provider,
    required String code,
  }) async {
    try {
      final endpoint = provider == 'qq' ? '/api/user/login/qq' : '/api/user/login/wechat';
      final response = await _dioClient.dio.post(
        endpoint,
        data: {'code': code},
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'user': UserModel.fromJson(data['user']),
          'token': data['token'],
        };
      } else {
        throw ServerException(
          response.data['message'] ?? '第三方登录失败',
          null,
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('第三方登录失败: $e');
    }
  }
  
  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.dio.get('/api/user/profile');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserModel.fromJson(data);
      } else {
        throw ServerException(
          response.data['message'] ?? '获取用户信息失败',
          null,
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('获取用户信息失败: $e');
    }
  }
  
  @override
  Future<UserModel> updateProfile({
    String? nickname,
    String? avatar,
    String? gender,
    int? age,
    String? location,
    String? signature,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (nickname != null) data['nickname'] = nickname;
      if (avatar != null) data['avatar'] = avatar;
      if (gender != null) data['gender'] = gender;
      if (age != null) data['age'] = age;
      if (location != null) data['location'] = location;
      if (signature != null) data['signature'] = signature;
      
      final response = await _dioClient.dio.put(
        '/api/user/profile',
        data: data,
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data['data'];
        return UserModel.fromJson(responseData);
      } else {
        throw ServerException(
          response.data['message'] ?? '更新用户信息失败',
          null,
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('更新用户信息失败: $e');
    }
  }
  
  /// 处理Dio异常
  ServerException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          '请求超时，请检查网络连接',
          null,
          e.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = e.response?.data?['message'] ?? '服务器错误';
        return ServerException(
          message,
          null,
          statusCode,
        );
      case DioExceptionType.cancel:
        return ServerException('请求已取消');
      case DioExceptionType.connectionError:
        return ServerException('网络连接失败，请检查网络设置');
      default:
        return ServerException(
          e.message ?? '未知错误',
          null,
          e.response?.statusCode,
        );
    }
  }
}