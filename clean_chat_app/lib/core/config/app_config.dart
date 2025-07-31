/// 应用配置类
class AppConfig {
  static const String appName = 'Clean Chat App';
  static const String appVersion = '1.0.0';
  
  // API配置
  static const String baseUrl = 'http://localhost:8080/api';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // 存储配置
  static const String userBoxName = 'user_box';
  static const String messageBoxName = 'message_box';
  static const String conversationBoxName = 'conversation_box';
  
  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // 缓存配置
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // UI配置
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;
  
  // 调试模式
  static const bool isDebugMode = true;
}