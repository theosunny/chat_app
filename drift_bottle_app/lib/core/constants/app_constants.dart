/// 应用核心常量配置
class AppConstants {
  // 应用信息
  static const String appName = '漂流瓶';
  static const String appVersion = '1.0.0';
  static const String appDescription = '企业级漂流瓶社交应用';
  
  // API配置
  static const String baseUrl = 'http://localhost:8080';
  static const String apiVersion = '/api/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 环信配置
  static const String emAppKey = 'your_easemob_app_key';
  static const bool emAutoLogin = false;
  static const bool emDebugMode = true;
  
  // 缓存配置
  static const String cacheBoxName = 'app_cache';
  static const String userBoxName = 'user_data';
  static const String settingsBoxName = 'app_settings';
  
  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // 文件上传配置
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi', 'mkv'];
  
  // 本地存储键
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserInfo = 'user_info';
  static const String keyAppSettings = 'app_settings';
  static const String keyFirstLaunch = 'first_launch';
  
  // 路由路径
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeMain = '/main';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeChat = '/chat';
  static const String routeBottleDetail = '/bottle/detail';
  
  // 动画配置
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // 防抖配置
  static const Duration debounceDelay = Duration(milliseconds: 500);
  
  // 重试配置
  static const int maxRetryCount = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}

/// 环境配置
enum Environment {
  development,
  staging,
  production,
}

/// 当前环境配置
class EnvironmentConfig {
  static const Environment current = Environment.development;
  
  static String get baseUrl {
    switch (current) {
      case Environment.development:
        return 'http://localhost:8080';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }
  
  static bool get isDebug => current == Environment.development;
  static bool get isProduction => current == Environment.production;
}