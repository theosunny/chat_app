import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../storage/token_storage.dart';

/// 企业级HTTP客户端
@lazySingleton
class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  final TokenStorage _tokenStorage;
  
  DioClient(this._tokenStorage) {
    _dio = Dio(_getBaseOptions());
    _setupInterceptors();
  }
  
  Dio get dio => _dio;
  
  /// 基础配置
  BaseOptions _getBaseOptions() {
    return BaseOptions(
      baseUrl: EnvironmentConfig.baseUrl + AppConstants.apiVersion,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }
  
  /// 设置拦截器
  void _setupInterceptors() {
    // 请求拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
    
    // 日志拦截器（仅在调试模式下）
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => _logger.d(obj),
        ),
      );
    }
  }
  
  /// 请求拦截
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 添加认证token
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // 添加设备信息
    options.headers['User-Agent'] = await _getUserAgent();
    
    _logger.i('🚀 Request: ${options.method} ${options.uri}');
    handler.next(options);
  }
  
  /// 响应拦截
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.i('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }
  
  /// 错误拦截
  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logger.e('❌ Error: ${err.type} ${err.requestOptions.uri}');
    
    // 处理token过期
    if (err.response?.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        // 重试原请求
        final options = err.requestOptions;
        final token = await _tokenStorage.getAccessToken();
        options.headers['Authorization'] = 'Bearer $token';
        
        try {
          final response = await _dio.fetch(options);
          handler.resolve(response);
          return;
        } catch (e) {
          // 重试失败，继续原错误流程
        }
      }
    }
    
    handler.next(err);
  }
  
  /// 刷新token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;
      
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // 移除旧token
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        await _tokenStorage.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        return true;
      }
    } catch (e) {
      _logger.e('Token refresh failed: $e');
      await _tokenStorage.clearTokens();
    }
    
    return false;
  }
  
  /// 获取User-Agent
  Future<String> _getUserAgent() async {
    return '${AppConstants.appName}/${AppConstants.appVersion} (Flutter)';
  }
  
  /// GET请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  /// POST请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  /// PUT请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  /// DELETE请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  /// 文件上传
  Future<Response<T>> upload<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// 文件下载
  Future<Response> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  /// 创建MultipartFile
  static MultipartFile multipartFile(
    List<int> bytes, {
    String? filename,
    String? contentType,
  }) {
    return MultipartFile.fromBytes(
      bytes,
      filename: filename,
      contentType: contentType != null ? MediaType.parse(contentType) : null,
    );
  }

  /// POST FormData请求
  Future<Response<T>> postFormData<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// 处理Dio异常
  AppException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('网络连接超时', 'TIMEOUT');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? '服务器错误';
        return ServerException(message, 'SERVER_ERROR', statusCode);
      
      case DioExceptionType.cancel:
        return NetworkException('请求已取消', 'CANCELLED');
      
      case DioExceptionType.connectionError:
        return NetworkException('网络连接失败', 'CONNECTION_ERROR');
      
      case DioExceptionType.badCertificate:
        return NetworkException('证书验证失败', 'BAD_CERTIFICATE');
      
      case DioExceptionType.unknown:
      default:
        return NetworkException('未知网络错误: ${e.message}', 'UNKNOWN');
    }
  }
}