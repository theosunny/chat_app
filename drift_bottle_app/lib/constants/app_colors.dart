import 'package:flutter/material.dart';

class AppColors {
  // 星空主题 - 主色调
  static const Color primary = Color(0xFF6366F1); // 星空紫
  static const Color primaryLight = Color(0xFF8B5CF6); // 浅星空紫
  static const Color primaryDark = Color(0xFF4338CA); // 深星空紫
  
  // 星空背景色
  static const Color background = Color(0xFF0F0F23); // 深夜蓝
  static const Color cardBackground = Color(0xFF1A1B3A); // 深紫蓝
  static const Color surfaceBackground = Color(0xFF252659); // 中等紫蓝
  
  // 星空文字颜色
  static const Color textPrimary = Color(0xFFE2E8F0); // 星光白
  static const Color textSecondary = Color(0xFFCBD5E1); // 月光银
  static const Color textHint = Color(0xFF94A3B8); // 星尘灰
  static const Color textAccent = Color(0xFFFBBF24); // 星光金
  
  // 功能色 - 星空主题
  static const Color success = Color(0xFF10B981); // 极光绿
  static const Color warning = Color(0xFFF59E0B); // 星光橙
  static const Color error = Color(0xFFEF4444); // 火星红
  static const Color info = Color(0xFF3B82F6); // 星海蓝
  
  // 分割线和边框 - 星空主题
  static const Color divider = Color(0xFF374151); // 星际灰
  static const Color border = Color(0xFF4B5563); // 星云边界
  
  // 漂流瓶颜色列表 - 星空主题
  static const List<Color> bottleColors = [
    Color(0xFF8B5CF6), // 紫色星云
    Color(0xFF06B6D4), // 青色星海
    Color(0xFF10B981), // 绿色极光
    Color(0xFFF59E0B), // 金色星光
    Color(0xFFEF4444), // 红色星辰
    Color(0xFFEC4899), // 粉色星云
    Color(0xFF6366F1), // 蓝紫星空
    Color(0xFF84CC16), // 青绿极光
  ];
  
  // 星空渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF3730A3), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient starryGradient = LinearGradient(
    colors: [Color(0xFF0F0F23), Color(0xFF1A1B3A), Color(0xFF252659)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient galaxyGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // 瓶子相关颜色 - 星空主题
  static const Color bottleGlass = Color(0xFF3B82F6); // 星海蓝玻璃
  static const Color bottleCork = Color(0xFFF59E0B); // 星光金软木塞
  
  // Tab栏颜色 - 星空主题
  static const Color tabSelected = Color(0xFFFBBF24); // 选中的星光金
  static const Color tabUnselected = Color(0xFF64748B); // 未选中的星尘
  
  // 特效颜色
  static const Color starGlow = Color(0xFFFBBF24); // 星光效果
  static const Color nebulaGlow = Color(0xFF8B5CF6); // 星云光晕
  static const Color galaxyCore = Color(0xFFEC4899); // 银河核心
  
  // 星空主题专用颜色
  static const Color starryPrimary = Color(0xFF6366F1); // 星空主色
  static const Color starrySecondary = Color(0xFF8B5CF6); // 星空次色
  static const Color starryBackground = Color(0xFF0F0F23); // 星空背景
  static const Color starryCardBackground = Color(0xFF1A1B3A); // 星空卡片背景
  static const Color starryAccent = Color(0xFFFBBF24); // 星空强调色
  static const Color starryTextPrimary = Color(0xFFE2E8F0); // 星空主文字
  static const Color starryTextSecondary = Color(0xFFCBD5E1); // 星空次文字
}