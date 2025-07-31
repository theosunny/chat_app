import 'package:flutter/material.dart';

/// 应用尺寸和间距系统
class AppDimensions {
  // 私有构造函数，防止实例化
  AppDimensions._();
  
  // ============ 基础间距单位 ============
  /// 基础间距单位 - 4dp
  static const double baseUnit = 4.0;
  
  // ============ 内边距系统 ============
  /// 超小间距 - 2dp
  static const double paddingXXSmall = baseUnit * 0.5;
  
  /// 极小间距 - 4dp
  static const double paddingXSmall = baseUnit;
  
  /// 小间距 - 8dp
  static const double paddingSmall = baseUnit * 2;
  
  /// 中等间距 - 12dp
  static const double paddingMedium = baseUnit * 3;
  
  /// 大间距 - 16dp
  static const double paddingLarge = baseUnit * 4;
  
  /// 超大间距 - 20dp
  static const double paddingXLarge = baseUnit * 5;
  
  /// 极大间距 - 24dp
  static const double paddingXXLarge = baseUnit * 6;
  
  /// 巨大间距 - 32dp
  static const double paddingHuge = baseUnit * 8;
  
  // ============ 外边距系统 ============
  /// 超小外边距 - 2dp
  static const double marginXXSmall = paddingXXSmall;
  
  /// 极小外边距 - 4dp
  static const double marginXSmall = paddingXSmall;
  
  /// 小外边距 - 8dp
  static const double marginSmall = paddingSmall;
  
  /// 中等外边距 - 12dp
  static const double marginMedium = paddingMedium;
  
  /// 大外边距 - 16dp
  static const double marginLarge = paddingLarge;
  
  /// 超大外边距 - 20dp
  static const double marginXLarge = paddingXLarge;
  
  /// 极大外边距 - 24dp
  static const double marginXXLarge = paddingXXLarge;
  
  /// 巨大外边距 - 32dp
  static const double marginHuge = paddingHuge;
  
  // ============ 圆角系统 ============
  /// 无圆角
  static const double radiusNone = 0.0;
  
  /// 极小圆角 - 2dp
  static const double radiusXSmall = 2.0;
  
  /// 小圆角 - 4dp
  static const double radiusSmall = 4.0;
  
  /// 中等圆角 - 8dp
  static const double radiusMedium = 8.0;
  
  /// 大圆角 - 12dp
  static const double radiusLarge = 12.0;
  
  /// 超大圆角 - 16dp
  static const double radiusXLarge = 16.0;
  
  /// 极大圆角 - 20dp
  static const double radiusXXLarge = 20.0;
  
  /// 圆形
  static const double radiusCircular = 999.0;
  
  // ============ 高度系统 ============
  /// 分割线高度
  static const double dividerHeight = 1.0;
  
  /// 薄分割线高度
  static const double thinDividerHeight = 0.5;
  
  /// 按钮最小高度
  static const double buttonMinHeight = 48.0;
  
  /// 小按钮高度
  static const double buttonSmallHeight = 36.0;
  
  /// 大按钮高度
  static const double buttonLargeHeight = 56.0;
  
  /// 输入框高度
  static const double inputHeight = 48.0;
  
  /// 小输入框高度
  static const double inputSmallHeight = 36.0;
  
  /// 大输入框高度
  static const double inputLargeHeight = 56.0;
  
  /// AppBar高度
  static const double appBarHeight = 56.0;
  
  /// 底部导航栏高度
  static const double bottomNavHeight = 80.0;
  
  /// 标签栏高度
  static const double tabBarHeight = 48.0;
  
  /// 列表项最小高度
  static const double listItemMinHeight = 56.0;
  
  /// 小列表项高度
  static const double listItemSmallHeight = 48.0;
  
  /// 大列表项高度
  static const double listItemLargeHeight = 72.0;
  
  /// 卡片最小高度
  static const double cardMinHeight = 80.0;
  
  /// 头像小尺寸
  static const double avatarSmallSize = 32.0;
  
  /// 头像中等尺寸
  static const double avatarMediumSize = 40.0;
  
  /// 头像大尺寸
  static const double avatarLargeSize = 56.0;
  
  /// 头像超大尺寸
  static const double avatarXLargeSize = 80.0;
  
  // ============ 宽度系统 ============
  /// 最小触摸目标尺寸
  static const double minTouchTarget = 48.0;
  
  /// 图标小尺寸
  static const double iconSmallSize = 16.0;
  
  /// 图标中等尺寸
  static const double iconMediumSize = 24.0;
  
  /// 图标大尺寸
  static const double iconLargeSize = 32.0;
  
  /// 图标超大尺寸
  static const double iconXLargeSize = 48.0;
  
  /// 徽章尺寸
  static const double badgeSize = 16.0;
  
  /// 小徽章尺寸
  static const double badgeSmallSize = 12.0;
  
  /// 大徽章尺寸
  static const double badgeLargeSize = 20.0;
  
  /// 进度条高度
  static const double progressBarHeight = 4.0;
  
  /// 滑块轨道高度
  static const double sliderTrackHeight = 4.0;
  
  /// 开关宽度
  static const double switchWidth = 52.0;
  
  /// 开关高度
  static const double switchHeight = 32.0;
  
  // ============ 阴影和高程 ============
  /// 无阴影
  static const double elevationNone = 0.0;
  
  /// 轻微阴影
  static const double elevationLight = 1.0;
  
  /// 中等阴影
  static const double elevationMedium = 2.0;
  
  /// 明显阴影
  static const double elevationHigh = 4.0;
  
  /// 强烈阴影
  static const double elevationStrong = 8.0;
  
  /// 极强阴影
  static const double elevationExtreme = 16.0;
  
  // ============ 边框宽度 ============
  /// 无边框
  static const double borderNone = 0.0;
  
  /// 细边框
  static const double borderThin = 0.5;
  
  /// 标准边框
  static const double borderStandard = 1.0;
  
  /// 粗边框
  static const double borderThick = 2.0;
  
  /// 超粗边框
  static const double borderExtraThick = 4.0;
  
  // ============ 聊天相关尺寸 ============
  /// 消息气泡最大宽度比例
  static const double messageBubbleMaxWidthRatio = 0.75;
  
  /// 消息气泡内边距
  static const EdgeInsets messageBubblePadding = EdgeInsets.symmetric(
    horizontal: paddingMedium,
    vertical: paddingSmall,
  );
  
  /// 消息间距
  static const double messageSpacing = paddingSmall;
  
  /// 消息头像尺寸
  static const double messageAvatarSize = avatarMediumSize;
  
  /// 输入框容器高度
  static const double inputContainerHeight = 60.0;
  
  /// 语音按钮尺寸
  static const double voiceButtonSize = 40.0;
  
  /// 表情按钮尺寸
  static const double emojiButtonSize = 32.0;
  
  // ============ 漂流瓶相关尺寸 ============
  /// 漂流瓶卡片高度
  static const double bottleCardHeight = 200.0;
  
  /// 漂流瓶卡片最小高度
  static const double bottleCardMinHeight = 150.0;
  
  /// 漂流瓶卡片最大高度
  static const double bottleCardMaxHeight = 300.0;
  
  /// 漂流瓶图标尺寸
  static const double bottleIconSize = 64.0;
  
  /// 漂流瓶动画尺寸
  static const double bottleAnimationSize = 120.0;
  
  // ============ 响应式断点 ============
  /// 手机断点
  static const double mobileBreakpoint = 600.0;
  
  /// 平板断点
  static const double tabletBreakpoint = 900.0;
  
  /// 桌面断点
  static const double desktopBreakpoint = 1200.0;
  
  // ============ 常用EdgeInsets ============
  /// 页面内边距
  static const EdgeInsets pagePadding = EdgeInsets.all(paddingLarge);
  
  /// 卡片内边距
  static const EdgeInsets cardPadding = EdgeInsets.all(paddingMedium);
  
  /// 列表项内边距
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: paddingLarge,
    vertical: paddingMedium,
  );
  
  /// 按钮内边距
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: paddingLarge,
    vertical: paddingMedium,
  );
  
  /// 小按钮内边距
  static const EdgeInsets buttonSmallPadding = EdgeInsets.symmetric(
    horizontal: paddingMedium,
    vertical: paddingSmall,
  );
  
  /// 输入框内边距
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: paddingMedium,
    vertical: paddingMedium,
  );
  
  /// 对话框内边距
  static const EdgeInsets dialogPadding = EdgeInsets.all(paddingXLarge);
  
  /// 底部弹窗内边距
  static const EdgeInsets bottomSheetPadding = EdgeInsets.all(paddingLarge);
  
  /// 安全区域内边距
  static const EdgeInsets safeAreaPadding = EdgeInsets.only(
    top: paddingLarge,
    bottom: paddingLarge,
  );
  
  // ============ 常用BorderRadius ============
  /// 小圆角
  static const BorderRadius borderRadiusSmall = BorderRadius.all(
    Radius.circular(radiusSmall),
  );
  
  /// 中等圆角
  static const BorderRadius borderRadiusMedium = BorderRadius.all(
    Radius.circular(radiusMedium),
  );
  
  /// 大圆角
  static const BorderRadius borderRadiusLarge = BorderRadius.all(
    Radius.circular(radiusLarge),
  );
  
  /// 超大圆角
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(
    Radius.circular(radiusXLarge),
  );
  
  /// 顶部圆角
  static const BorderRadius borderRadiusTop = BorderRadius.vertical(
    top: Radius.circular(radiusLarge),
  );
  
  /// 底部圆角
  static const BorderRadius borderRadiusBottom = BorderRadius.vertical(
    bottom: Radius.circular(radiusLarge),
  );
  
  /// 左侧圆角
  static const BorderRadius borderRadiusLeft = BorderRadius.horizontal(
    left: Radius.circular(radiusLarge),
  );
  
  /// 右侧圆角
  static const BorderRadius borderRadiusRight = BorderRadius.horizontal(
    right: Radius.circular(radiusLarge),
  );
  
  // ============ 工具方法 ============
  
  /// 获取响应式内边距
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < mobileBreakpoint) {
      return pagePadding;
    } else if (screenWidth < tabletBreakpoint) {
      return const EdgeInsets.all(paddingXLarge);
    } else {
      return const EdgeInsets.all(paddingXXLarge);
    }
  }
  
  /// 获取响应式字体大小
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < mobileBreakpoint) {
      return baseSize;
    } else if (screenWidth < tabletBreakpoint) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.2;
    }
  }
  
  /// 判断是否为移动设备
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
  
  /// 判断是否为平板设备
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= mobileBreakpoint && screenWidth < desktopBreakpoint;
  }
  
  /// 判断是否为桌面设备
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }
}