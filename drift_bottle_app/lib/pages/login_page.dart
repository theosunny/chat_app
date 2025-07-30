import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isCodeSent = false;
  bool _isLoading = false;
  int _countdown = 0;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('请输入用户名和密码');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.loginWithPhone(
        _usernameController.text,
        _passwordController.text,
      );
      
      if (success && mounted) {
        context.go('/home');
      } else {
        _showSnackBar('登录失败，请检查用户名和密码');
      }
    } catch (e) {
      _showSnackBar('登录失败：$e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _countdown--;
        });
      }
      return _countdown > 0 && mounted;
    });
  }
  
  Future<void> _sendCode() async {
    if (_phoneController.text.length != 11) {
      _showSnackBar('请输入正确的手机号');
      return;
    }
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // 这里应该调用发送验证码的API
      // final success = await authProvider.sendVerificationCode(_phoneController.text);
      
      // 模拟发送成功
      setState(() {
        _isCodeSent = true;
      });
      _startCountdown();
      _showSnackBar('验证码已发送');
    } catch (e) {
      _showSnackBar('发送验证码失败');
    }
  }
  
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      final success = await authProvider.loginWithPhone(
        _phoneController.text,
        _codeController.text,
      );
      
      if (success) {
        if (mounted) {
          context.go('/main');
        }
      } else {
        _showSnackBar('登录失败，请检查验证码');
      }
    } catch (e) {
      _showSnackBar('登录失败: $e');
    }
  }
  
  Future<void> _loginWithWechat() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      final success = await authProvider.loginWithWechat();
      
      if (success) {
        if (mounted) {
          context.go('/main');
        }
      } else {
        _showSnackBar('微信登录失败');
      }
    } catch (e) {
      _showSnackBar('微信登录失败: $e');
    }
  }
  
  Future<void> _loginWithQQ() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      final success = await authProvider.loginWithQQ();
      
      if (success) {
        if (mounted) {
          context.go('/main');
        }
      } else {
        _showSnackBar('QQ登录失败');
      }
    } catch (e) {
      _showSnackBar('QQ登录失败: $e');
    }
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 星空背景
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F0F23),
                    Color(0xFF1A1B3A),
                    Color(0xFF252659),
                  ],
                ),
              ),
            ),
          ),
          // 星星装饰
          Positioned.fill(
            child: CustomPaint(
              painter: StarsPainter(_fadeAnimation),
            ),
          ),
          // 主要内容
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildContent(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent() {
    return Column(
      children: [
        // 顶部机器人区域
        Expanded(
          flex: 2,
          child: _buildRobotSection(),
        ),
        
        // 底部登录区域
        Expanded(
          flex: 3,
          child: _buildLoginSection(),
        ),
      ],
    );
  }
  
  Widget _buildRobotSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 星空漂流瓶图标
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 漂流瓶主体
                Container(
                  width: 60.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: const Color(0xFFFBBF24),
                      width: 2,
                    ),
                  ),
                ),
                // 瓶塞
                Positioned(
                  top: 15.w,
                  child: Container(
                    width: 20.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                // 信件
                Positioned(
                  child: Container(
                    width: 30.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: const Color(0xFFEC4899),
                        size: 12.w,
                      ),
                    ),
                  ),
                ),
                // 星光效果
                ...List.generate(6, (index) {
                  final angle = (index * 60) * 3.14159 / 180;
                  final radius = 70.w;
                  return Positioned(
                    left: 60.w + radius * 0.8 * cos(angle),
                    top: 60.w + radius * 0.8 * sin(angle),
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBBF24),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          
          SizedBox(height: 40.h),
          
          // 欢迎文字
          Text(
            '星空漂流瓶',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w300,
              color: const Color(0xFFE2E8F0),
              shadows: [
                Shadow(
                  color: const Color(0xFF6366F1).withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            '在星海中遇见你',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFFCBD5E1),
            ),
          ),
          
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
  
  Widget _buildLoginSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // 顶部指示器
            Container(
              width: 40.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            SizedBox(height: 30.h),
            
            // 登录标题
            Text(
              '欢迎回来',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Text(
              '请登录您的账号',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
           ),
           
           SizedBox(height: 30.h),
           
           // 用户名输入框
           CustomTextField(
             controller: _usernameController,
             hintText: '用户名',
             prefixIcon: Icons.person_outline,
           ),
           
           SizedBox(height: 16.h),
           
           // 密码输入框
            CustomTextField(
              controller: _passwordController,
              hintText: '密码',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
            ),
           
           SizedBox(height: 24.h),
           
           // 登录按钮
           CustomButton(
             text: '登录',
             onPressed: _isLoading ? null : _handleLogin,
             isLoading: _isLoading,
           ),
           
           SizedBox(height: 16.h),
           
           // 注册链接
           TextButton(
             onPressed: () => context.go('/register'),
             child: Text(
               '还没有账号？立即注册',
               style: TextStyle(
                 color: AppColors.primary,
                 fontSize: 14.sp,
               ),
             ),
           ),
            
            SizedBox(height: 30.h),
            
            // 登录表单
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 手机号输入
                    _buildModernTextField(
                      controller: _phoneController,
                      hintText: '手机号',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入手机号';
                        }
                        if (value.length != 11) {
                          return '请输入正确的手机号';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // 验证码输入
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernTextField(
                            controller: _codeController,
                            hintText: '验证码',
                            icon: Icons.security_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入验证码';
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        SizedBox(width: 12.w),
                        
                        // 发送验证码按钮
                        Container(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: _countdown > 0 ? null : _sendCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4FC3F7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                            ),
                            child: Text(
                              _countdown > 0 ? '${_countdown}s' : '获取验证码',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // 登录按钮
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Container(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4FC3F7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: authProvider.isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    '登录',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 30.h),
                    
                    // 第三方登录
                    _buildThirdPartyLogin(),
                    
                    const Spacer(),
                    
                    // 用户协议
                    _buildUserAgreement(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildThirdPartyLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                '其他登录方式',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        
        SizedBox(height: 20.h),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 微信登录
            _buildThirdPartyButton(
              icon: FontAwesomeIcons.weixin,
              color: const Color(0xFF07C160),
              onTap: _loginWithWechat,
            ),
            
            SizedBox(width: 40.w),
            
            // QQ登录
            _buildThirdPartyButton(
              icon: FontAwesomeIcons.qq,
              color: const Color(0xFF12B7F5),
              onTap: _loginWithQQ,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildThirdPartyButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 24.w,
          color: color,
        ),
      ),
    );
  }
  
  Widget _buildUserAgreement() {
    return Text.rich(
      TextSpan(
        text: '登录即表示同意',
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
        children: [
          TextSpan(
            text: '《用户协议》',
            style: TextStyle(
              color: const Color(0xFF4FC3F7),
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: '和'),
          TextSpan(
            text: '《隐私政策》',
            style: TextStyle(
              color: const Color(0xFF4FC3F7),
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.starryCardBackground.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.starryAccent.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.starryAccent.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: TextStyle(
          fontSize: 16.sp,
          color: AppColors.starryTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: AppColors.starryTextSecondary,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.starryAccent,
            size: 22.w,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),
        ),
      ),
    );
  }
}

// 星空背景绘制器
class StarsPainter extends CustomPainter {
  final Animation<double> animation;
  
  StarsPainter(this.animation) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = Random(42); // 固定种子确保星星位置一致
    
    // 绘制星星
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = (sin(animation.value * 2 * pi + i) + 1) / 2;
      
      paint.color = Colors.white.withOpacity(opacity * 0.8);
      
      if (i % 10 == 0) {
        // 大星星
        paint.strokeWidth = 2;
        canvas.drawCircle(Offset(x, y), 2, paint);
        
        // 星星光芒
        paint.strokeWidth = 1;
        canvas.drawLine(
          Offset(x - 6, y),
          Offset(x + 6, y),
          paint,
        );
        canvas.drawLine(
          Offset(x, y - 6),
          Offset(x, y + 6),
          paint,
        );
      } else {
        // 小星星
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
    
    // 绘制流星
    final meteorOpacity = (sin(animation.value * pi) + 1) / 2;
    if (meteorOpacity > 0.5) {
      paint.color = Colors.white.withOpacity(meteorOpacity * 0.6);
      paint.strokeWidth = 2;
      
      final meteorX = (animation.value * size.width * 1.5) % (size.width + 100) - 50;
      final meteorY = size.height * 0.3;
      
      canvas.drawLine(
        Offset(meteorX, meteorY),
        Offset(meteorX - 30, meteorY + 15),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}