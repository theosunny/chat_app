import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/auth_provider.dart';
import '../providers/message_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 预加载字体，避免文本渲染乱码
    _preloadFonts();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
    
    _checkLoginStatus();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // 预加载字体，确保文本渲染稳定
  void _preloadFonts() {
    // 通过创建隐藏的Text组件来预加载字体
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // 预渲染中文字符，确保字体加载
        const preloadText = Text(
          '星空漂流瓶在浩瀚星空中遇见美好发现美好，分享心情正在为您准备精彩内容...',
          style: TextStyle(
            fontFamily: 'PingFang SC',
            fontSize: 0,
            color: Colors.transparent,
          ),
        );
      }
    });
  }
  
  Future<void> _checkLoginStatus() async {
    // 等待动画完成
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // 调试：检查本地存储的token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    debugPrint('SplashPage: 检查到的token: ${token ?? "无token"}');
    debugPrint('SplashPage: AuthProvider状态 - isLoading: ${authProvider.isLoading}, isLoggedIn: ${authProvider.isLoggedIn}');
    
    // 等待认证检查完成
    while (authProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    if (!mounted) return;
    
    debugPrint('SplashPage: 认证检查完成 - isLoggedIn: ${authProvider.isLoggedIn}');
    
    if (authProvider.isLoggedIn) {
      debugPrint('SplashPage: 用户已登录，初始化环信聊天服务');
      // 用户已登录，初始化环信聊天服务
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      await messageProvider.initializeChatService();
      
      debugPrint('SplashPage: 跳转到主页面');
      context.go('/main');
    } else {
      debugPrint('SplashPage: 跳转到登录页面');
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // SVG背景
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667eea),
                    Color(0xFF764ba2),
                    Color(0xFFf093fb),
                  ],
                ),
              ),
              child: SvgPicture.asset(
                'assets/images/splash_background.svg',
                fit: BoxFit.cover,
                placeholderBuilder: (context) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                        Color(0xFFf093fb),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 主要内容
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        // 顶部空间
                        SizedBox(height: 80.h),
                        
                        // 主标题区域
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 应用图标
                              Container(
                                width: 120.w,
                                height: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.r),
                                  child: SvgPicture.asset(
                                    'assets/images/app_icon.svg',
                                    width: 120.w,
                                    height: 120.w,
                                    placeholderBuilder: (context) => Container(
                                      width: 120.w,
                                      height: 120.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.r),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF667eea),
                                            Color(0xFF764ba2),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.local_post_office,
                                        size: 60.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 40.h),
                              
                              // 应用名称
                              Text(
                                '星空漂流瓶',
                                style: TextStyle(
                                  fontFamily: 'PingFang SC',
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: 16.h),
                              
                              // 副标题
                              Text(
                                '在浩瀚星空中遇见美好',
                                style: TextStyle(
                                  fontFamily: 'PingFang SC',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  letterSpacing: 1.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // 中间装饰区域
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 40.w,
                                vertical: 20.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 20.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    '发现美好，分享心情',
                                    style: TextStyle(
                                      fontFamily: 'PingFang SC',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Icon(
                                    Icons.local_post_office,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 20.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // 底部加载指示器
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // 加载动画
                              Container(
                                width: 40.w,
                                height: 40.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 20.h),
                              
                              // 加载文字
                              Text(
                                '正在为您准备精彩内容...',
                                style: TextStyle(
                                  fontFamily: 'PingFang SC',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              
                              SizedBox(height: 60.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  }
