import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../constants/app_colors.dart';
import '../../utils/image_utils.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ImagePicker _picker = ImagePicker();

  Future<void> _updateAvatar() async {
    try {
      // 请求相册权限
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('需要相册权限才能选择头像')),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        // TODO: 实现头像更新功能
        // await authProvider.updateAvatar(File(image.path));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('头像更新成功')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新头像失败: $e')),
      );
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('退出', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout();
        
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('退出失败: $e')),
        );
      }
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.grey[700],
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          if (authProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (user == null) {
            return const Center(
              child: Text('用户信息加载失败'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // 用户信息卡片
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // 头像
                      GestureDetector(
                        onTap: _updateAvatar,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: user.avatar?.isNotEmpty == true
                                  ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(user.avatar!))
                                  : null,
                              child: user.avatar?.isEmpty != false
                                  ? Text(
                                      user.nickname[0],
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 用户名
                      Text(
                        user.nickname,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // 个性签名
                      Text(
                        user.signature?.isNotEmpty == true ? user.signature! : '这个人很懒，什么都没留下',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // 统计信息
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('动态', '0'),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildStatItem('漂流瓶', '0'),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildStatItem('获赞', '0'),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 功能菜单
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.edit,
                        title: '编辑资料',
                        subtitle: '修改昵称、个性签名等',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfilePage(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: '我的动态',
                        subtitle: '查看我发布的动态',
                        onTap: () {
                          // TODO: 跳转到我的动态页面
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('功能开发中')),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildMenuItem(
                        icon: Icons.local_post_office,
                        title: '我的漂流瓶',
                        subtitle: '查看我发布和捞到的漂流瓶',
                        onTap: () {
                          Navigator.pushNamed(context, '/my-bottles');
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 其他功能
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.favorite,
                        title: '我的点赞',
                        subtitle: '查看我点赞的内容',
                        onTap: () {
                          // TODO: 跳转到我的点赞页面
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('功能开发中')),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: '帮助与反馈',
                        subtitle: '使用帮助和问题反馈',
                        onTap: () {
                          // TODO: 跳转到帮助页面
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('功能开发中')),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: '关于我们',
                        subtitle: '了解更多应用信息',
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: '漂流瓶',
                            applicationVersion: '1.0.0',
                            applicationIcon: const Icon(
                              Icons.local_post_office,
                              size: 48,
                            ),
                            children: [
                              const Text('一个简单有趣的社交应用'),
                              const SizedBox(height: 8),
                              const Text('在这里，你可以：'),
                              const Text('• 发布和捞取漂流瓶'),
                              const Text('• 分享生活动态'),
                              const Text('• 与其他用户聊天'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // 退出登录按钮
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: '退出登录',
                    onPressed: _logout,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    width: double.infinity,
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}