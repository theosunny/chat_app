import 'package:flutter/material.dart';

/// 应用颜色系统
class AppColors {
  // 私有构造函数，防止实例化
  AppColors._();
  
  // ============ 品牌色彩 ============
  /// 主品牌色 - 海洋蓝
  static const Color primaryBlue = Color(0xFF1976D2);
  
  /// 主色调（别名）
  static const Color primary = primaryBlue;
  
  /// 背景色
  static const Color background = grey50;
  
  /// 主要文本色
  static const Color textPrimary = grey900;
  
  /// 次要文本色
  static const Color textSecondary = grey600;
  
  /// 成功色（别名）
  static const Color success = successGreen;
  
  /// 次要品牌色 - 青绿色
  static const Color secondaryTeal = Color(0xFF00ACC1);
  
  /// 强调色 - 橙色
  static const Color accentOrange = Color(0xFFFF9800);
  
  /// 成功色 - 绿色
  static const Color successGreen = Color(0xFF4CAF50);
  
  /// 警告色 - 琥珀色
  static const Color warningAmber = Color(0xFFFFC107);
  
  /// 错误色 - 红色
  static const Color errorRed = Color(0xFFF44336);
  
  /// 信息色 - 蓝色
  static const Color infoBlue = Color(0xFF2196F3);
  
  // ============ 中性色彩 ============
  /// 纯白色
  static const Color white = Color(0xFFFFFFFF);
  
  /// 纯黑色
  static const Color black = Color(0xFF000000);
  
  /// 灰色系列
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // ============ 功能色彩 ============
  /// 在线状态
  static const Color onlineGreen = Color(0xFF4CAF50);
  
  /// 离线状态
  static const Color offlineGrey = Color(0xFF9E9E9E);
  
  /// 忙碌状态
  static const Color busyOrange = Color(0xFFFF9800);
  
  /// 勿扰状态
  static const Color dndRed = Color(0xFFF44336);
  
  /// 未读消息
  static const Color unreadRed = Color(0xFFE53935);
  
  /// 已读消息
  static const Color readBlue = Color(0xFF1976D2);
  
  /// 发送中消息
  static const Color sendingGrey = Color(0xFF9E9E9E);
  
  /// 发送失败
  static const Color failedRed = Color(0xFFD32F2F);
  
  // ============ 星空主题颜色 ============
  /// 星空主色调
  static const Color starryPrimary = Color(0xFF6366F1);
  static const Color starrySecondary = Color(0xFF8B5CF6);
  static const Color starryBackground = Color(0xFF0F0F23);
  static const Color starryCardBackground = Color(0xFF1A1B3A);
  static const Color starryAccent = Color(0xFFFBBF24);
  static const Color starryTextPrimary = Color(0xFFE2E8F0);
  
  /// 错误色别名
  static const Color error = errorRed;

  // ============ 渐变色彩 ============
  /// 主要渐变 - 蓝色到青色
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, secondaryTeal],
  );

  /// 次要渐变 - 橙色到红色
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentOrange, Color(0xFFE91E63)],
  );
  
  /// 成功渐变
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successGreen, Color(0xFF8BC34A)],
  );
  
  /// 警告渐变
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warningAmber, accentOrange],
  );
  
  /// 错误渐变
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [errorRed, Color(0xFFD32F2F)],
  );
  
  // ============ Material 3 颜色方案 ============
  /// 浅色主题颜色方案
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryBlue,
    onPrimary: white,
    primaryContainer: Color(0xFFBBDEFB),
    onPrimaryContainer: Color(0xFF0D47A1),
    secondary: secondaryTeal,
    onSecondary: white,
    secondaryContainer: Color(0xFFB2EBF2),
    onSecondaryContainer: Color(0xFF006064),
    tertiary: accentOrange,
    onTertiary: white,
    tertiaryContainer: Color(0xFFFFE0B2),
    onTertiaryContainer: Color(0xFFE65100),
    error: errorRed,
    onError: white,
    errorContainer: Color(0xFFFFCDD2),
    onErrorContainer: Color(0xFFB71C1C),
    // background: grey50, // 已弃用，使用surface代替
    // onBackground: grey900, // 已弃用，使用onSurface代替
    surface: white,
    onSurface: grey900,
    surfaceContainer: grey100,
    outline: grey400,
    outlineVariant: grey300,
    shadow: black,
    scrim: black,
    inverseSurface: grey800,
    onInverseSurface: grey100,
    inversePrimary: Color(0xFF90CAF9),
    surfaceTint: primaryBlue,
  );
  
  /// 深色主题颜色方案
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9),
    onPrimary: Color(0xFF0D47A1),
    primaryContainer: Color(0xFF1565C0),
    onPrimaryContainer: Color(0xFFE3F2FD),
    secondary: Color(0xFF80DEEA),
    onSecondary: Color(0xFF006064),
    secondaryContainer: Color(0xFF00838F),
    onSecondaryContainer: Color(0xFFE0F7FA),
    tertiary: Color(0xFFFFCC02),
    onTertiary: Color(0xFFE65100),
    tertiaryContainer: Color(0xFFF57C00),
    onTertiaryContainer: Color(0xFFFFF3E0),
    error: Color(0xFFEF5350),
    onError: Color(0xFFB71C1C),
    errorContainer: Color(0xFFD32F2F),
    onErrorContainer: Color(0xFFFFEBEE),
    // background: Color(0xFF121212), // 已弃用，使用surface代替
    // onBackground: Color(0xFFE0E0E0), // 已弃用，使用onSurface代替
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
    surfaceContainer: Color(0xFF424242),
    outline: grey600,
    outlineVariant: grey700,
    shadow: black,
    scrim: black,
    inverseSurface: grey200,
    onInverseSurface: grey800,
    inversePrimary: primaryBlue,
    surfaceTint: Color(0xFF90CAF9),
  );
  
  // ============ 透明度变体 ============
  /// 获取颜色的透明度变体
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
  
  /// 常用透明度
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.6;
  static const double opacityLight = 0.12;
  static const double opacityHover = 0.04;
  static const double opacityFocus = 0.12;
  static const double opacityPressed = 0.16;
  
  // ============ 聊天相关颜色 ============
  /// 发送消息气泡
  static const Color sentMessageBubble = primaryBlue;
  
  /// 接收消息气泡
  static const Color receivedMessageBubble = grey200;
  
  /// 系统消息
  static const Color systemMessage = grey400;
  
  /// 时间戳
  static const Color timestamp = grey500;
  
  /// 消息状态
  static const Color messageDelivered = grey500;
  static const Color messageRead = primaryBlue;
  static const Color messageFailed = errorRed;
  
  // ============ 漂流瓶相关颜色 ============
  /// 漂流瓶背景渐变
  static const LinearGradient bottleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF64B5F6),
      Color(0xFF42A5F5),
      Color(0xFF2196F3),
      Color(0xFF1E88E5),
    ],
  );
  
  /// 海洋背景渐变
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF87CEEB),
      Color(0xFF4682B4),
      Color(0xFF1E3A8A),
    ],
  );
}