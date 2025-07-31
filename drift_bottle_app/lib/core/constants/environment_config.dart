/// 环境配置
class EnvironmentConfig {
  // 当前环境
  static const Environment currentEnvironment = Environment.development;
  
  // 根据环境获取配置
  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'http://localhost:8080';
      case Environment.staging:
        return 'https://staging-api.driftbottle.com';
      case Environment.production:
        return 'https://api.driftbottle.com';
    }
  }
  
  static String get wsBaseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'ws://localhost:8080';
      case Environment.staging:
        return 'wss://staging-api.driftbottle.com';
      case Environment.production:
        return 'wss://api.driftbottle.com';
    }
  }
  
  static bool get enableLogging {
    switch (currentEnvironment) {
      case Environment.development:
        return true;
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }
  
  static bool get enableAnalytics {
    switch (currentEnvironment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return true;
      case Environment.production:
        return true;
    }
  }
  
  static bool get enableCrashReporting {
    switch (currentEnvironment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return true;
      case Environment.production:
        return true;
    }
  }
  
  static String get databaseName {
    switch (currentEnvironment) {
      case Environment.development:
        return 'drift_bottle_dev.db';
      case Environment.staging:
        return 'drift_bottle_staging.db';
      case Environment.production:
        return 'drift_bottle.db';
    }
  }
  
  static String get mapApiKey {
    switch (currentEnvironment) {
      case Environment.development:
        return const String.fromEnvironment('DEV_MAP_API_KEY', defaultValue: '');
      case Environment.staging:
        return const String.fromEnvironment('STAGING_MAP_API_KEY', defaultValue: '');
      case Environment.production:
        return const String.fromEnvironment('PROD_MAP_API_KEY', defaultValue: '');
    }
  }
  
  static String get pushNotificationKey {
    switch (currentEnvironment) {
      case Environment.development:
        return const String.fromEnvironment('DEV_PUSH_KEY', defaultValue: '');
      case Environment.staging:
        return const String.fromEnvironment('STAGING_PUSH_KEY', defaultValue: '');
      case Environment.production:
        return const String.fromEnvironment('PROD_PUSH_KEY', defaultValue: '');
    }
  }
  
  static String get analyticsKey {
    switch (currentEnvironment) {
      case Environment.development:
        return const String.fromEnvironment('DEV_ANALYTICS_KEY', defaultValue: '');
      case Environment.staging:
        return const String.fromEnvironment('STAGING_ANALYTICS_KEY', defaultValue: '');
      case Environment.production:
        return const String.fromEnvironment('PROD_ANALYTICS_KEY', defaultValue: '');
    }
  }
  
  static Duration get cacheExpiration {
    switch (currentEnvironment) {
      case Environment.development:
        return const Duration(minutes: 5); // 开发环境短缓存
      case Environment.staging:
        return const Duration(minutes: 30);
      case Environment.production:
        return const Duration(hours: 1);
    }
  }
  
  static int get maxRetryCount {
    switch (currentEnvironment) {
      case Environment.development:
        return 1; // 开发环境少重试
      case Environment.staging:
        return 2;
      case Environment.production:
        return 3;
    }
  }
  
  static Duration get requestTimeout {
    switch (currentEnvironment) {
      case Environment.development:
        return const Duration(seconds: 60); // 开发环境长超时
      case Environment.staging:
        return const Duration(seconds: 30);
      case Environment.production:
        return const Duration(seconds: 30);
    }
  }
}

/// 环境枚举
enum Environment {
  development,
  staging,
  production,
}

/// 环境扩展
extension EnvironmentExtension on Environment {
  String get name {
    switch (this) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
  
  String get displayName {
    switch (this) {
      case Environment.development:
        return '开发环境';
      case Environment.staging:
        return '测试环境';
      case Environment.production:
        return '生产环境';
    }
  }
  
  bool get isDevelopment => this == Environment.development;
  bool get isStaging => this == Environment.staging;
  bool get isProduction => this == Environment.production;
}