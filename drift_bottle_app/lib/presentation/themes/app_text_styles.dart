import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 应用文字样式系统
class AppTextStyles {
  // 私有构造函数，防止实例化
  AppTextStyles._();
  
  // ============ 字体家族 ============
  /// 默认字体家族
  static const String defaultFontFamily = 'PingFang SC';
  
  /// 数字字体家族
  static const String numberFontFamily = 'SF Pro Display';
  
  /// 代码字体家族
  static const String codeFontFamily = 'SF Mono';
  
  // ============ 字体权重 ============
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
  
  // ============ Material 3 文字样式 ============
  
  /// Display Large - 57sp
  static const TextStyle displayLarge = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 57,
    fontWeight: regular,
    height: 1.12,
    letterSpacing: -0.25,
  );
  
  /// Display Medium - 45sp
  static const TextStyle displayMedium = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 45,
    fontWeight: regular,
    height: 1.16,
    letterSpacing: 0,
  );
  
  /// Display Small - 36sp
  static const TextStyle displaySmall = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 36,
    fontWeight: regular,
    height: 1.22,
    letterSpacing: 0,
  );
  
  /// Headline Large - 32sp
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 32,
    fontWeight: regular,
    height: 1.25,
    letterSpacing: 0,
  );
  
  /// Headline Medium - 28sp
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 28,
    fontWeight: regular,
    height: 1.29,
    letterSpacing: 0,
  );
  
  /// Headline Small - 24sp
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 24,
    fontWeight: regular,
    height: 1.33,
    letterSpacing: 0,
  );
  
  /// Title Large - 22sp
  static const TextStyle titleLarge = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 22,
    fontWeight: regular,
    height: 1.27,
    letterSpacing: 0,
  );
  
  /// Title Medium - 16sp
  static const TextStyle titleMedium = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: medium,
    height: 1.50,
    letterSpacing: 0.15,
  );
  
  /// Title Small - 14sp
  static const TextStyle titleSmall = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.43,
    letterSpacing: 0.1,
  );
  
  /// Label Large - 14sp
  static const TextStyle labelLarge = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.43,
    letterSpacing: 0.1,
  );
  
  /// Label Medium - 12sp
  static const TextStyle labelMedium = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.33,
    letterSpacing: 0.5,
  );
  
  /// Label Small - 11sp
  static const TextStyle labelSmall = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 11,
    fontWeight: medium,
    height: 1.45,
    letterSpacing: 0.5,
  );
  
  /// Body Large - 16sp
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.50,
    letterSpacing: 0.15,
  );
  
  /// Body Medium - 14sp
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.43,
    letterSpacing: 0.25,
  );
  
  /// Body Small - 12sp
  static const TextStyle bodySmall = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.33,
    letterSpacing: 0.4,
  );
  
  // ============ 自定义文字样式 ============
  
  /// 超大标题 - 用于启动页、欢迎页
  static const TextStyle heroTitle = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 48,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  /// 页面标题
  static const TextStyle pageTitle = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.4,
    letterSpacing: 0,
  );
  
  /// 卡片标题
  static const TextStyle cardTitle = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.44,
    letterSpacing: 0,
  );
  
  /// 列表标题
  static const TextStyle listTitle = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: medium,
    height: 1.5,
    letterSpacing: 0.15,
  );
  
  /// 列表副标题
  static const TextStyle listSubtitle = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.43,
    letterSpacing: 0.25,
  );
  
  /// 按钮文字
  static const TextStyle buttonText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.43,
    letterSpacing: 0.1,
  );
  
  /// 输入框文字
  static const TextStyle inputText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.15,
  );
  
  /// 输入框提示文字
  static const TextStyle hintText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.15,
  );
  
  /// 错误文字
  static const TextStyle errorText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.33,
    letterSpacing: 0.4,
  );
  
  /// 帮助文字
  static const TextStyle helperText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.33,
    letterSpacing: 0.4,
  );
  
  /// 时间戳
  static const TextStyle timestamp = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 11,
    fontWeight: regular,
    height: 1.45,
    letterSpacing: 0.5,
  );
  
  /// 数字样式
  static const TextStyle number = TextStyle(
    fontFamily: numberFontFamily,
    fontSize: 16,
    fontWeight: medium,
    height: 1.5,
    letterSpacing: 0,
  );
  
  /// 代码样式
  static const TextStyle code = TextStyle(
    fontFamily: codeFontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.43,
    letterSpacing: 0,
  );
  
  // ============ 聊天相关样式 ============
  
  /// 聊天消息文字
  static const TextStyle chatMessage = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0.15,
  );
  
  /// 聊天时间
  static const TextStyle chatTime = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 11,
    fontWeight: regular,
    height: 1.45,
    letterSpacing: 0.5,
  );
  
  /// 聊天用户名
  static const TextStyle chatUsername = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.33,
    letterSpacing: 0.5,
  );
  
  /// 聊天状态
  static const TextStyle chatStatus = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 10,
    fontWeight: regular,
    height: 1.6,
    letterSpacing: 0.5,
  );
  
  // ============ 漂流瓶相关样式 ============
  
  /// 漂流瓶内容
  static const TextStyle bottleContent = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.6,
    letterSpacing: 0.15,
  );
  
  /// 漂流瓶标签
  static const TextStyle bottleTag = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.33,
    letterSpacing: 0.5,
  );
  
  /// 漂流瓶距离
  static const TextStyle bottleDistance = TextStyle(
    fontFamily: numberFontFamily,
    fontSize: 11,
    fontWeight: regular,
    height: 1.45,
    letterSpacing: 0.5,
  );
  
  // ============ Material 3 文字主题 ============
  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );
  
  // ============ 工具方法 ============
  
  /// 获取带颜色的文字样式
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  /// 获取带权重的文字样式
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  /// 获取带大小的文字样式
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
  
  /// 获取带行高的文字样式
  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }
  
  /// 获取带字间距的文字样式
  static TextStyle withLetterSpacing(TextStyle style, double letterSpacing) {
    return style.copyWith(letterSpacing: letterSpacing);
  }
}