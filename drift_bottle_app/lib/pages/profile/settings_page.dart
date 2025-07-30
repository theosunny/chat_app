import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? Colors.grey[700],
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? iconColor,
  }) {
    return _buildSettingItem(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconColor: iconColor,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(!value),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除应用缓存吗？这将删除临时文件和图片缓存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现清除缓存功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清除')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('隐私政策'),
        content: const SingleChildScrollView(
          child: Text(
            '隐私政策\n\n'
            '1. 信息收集\n'
            '我们收集您提供的个人信息，包括但不限于昵称、头像、联系方式等。\n\n'
            '2. 信息使用\n'
            '我们使用收集的信息来提供和改进服务，包括个性化推荐、用户支持等。\n\n'
            '3. 信息保护\n'
            '我们采用行业标准的安全措施来保护您的个人信息。\n\n'
            '4. 信息共享\n'
            '除法律要求外，我们不会与第三方共享您的个人信息。\n\n'
            '5. 联系我们\n'
            '如有任何隐私相关问题，请联系我们的客服团队。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('用户协议'),
        content: const SingleChildScrollView(
          child: Text(
            '用户协议\n\n'
            '1. 服务条款\n'
            '使用本应用即表示您同意遵守以下条款和条件。\n\n'
            '2. 用户行为\n'
            '用户应当遵守法律法规，不得发布违法、有害、虚假信息。\n\n'
            '3. 知识产权\n'
            '应用中的内容受知识产权法保护，未经许可不得复制或传播。\n\n'
            '4. 免责声明\n'
            '我们不对用户生成的内容承担责任，用户应对自己的行为负责。\n\n'
            '5. 协议变更\n'
            '我们保留随时修改本协议的权利，修改后的协议将在应用内公布。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  void _showAccountDeletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('注销账户'),
        content: const Text(
          '注销账户将永久删除您的所有数据，包括：\n\n'
          '• 个人资料和设置\n'
          '• 发布的动态和漂流瓶\n'
          '• 聊天记录\n'
          '• 点赞和评论记录\n\n'
          '此操作不可恢复，请谨慎考虑。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现账户注销功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('账户注销功能开发中')),
              );
            },
            child: const Text(
              '确定注销',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 通知设置
            _buildSectionTitle('通知设置'),
            _buildSwitchItem(
              icon: Icons.notifications,
              title: '推送通知',
              subtitle: '接收新消息和互动通知',
              value: _notificationEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationEnabled = value;
                });
              },
            ),
            _buildSwitchItem(
              icon: Icons.volume_up,
              title: '声音提醒',
              subtitle: '新消息时播放提示音',
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
              },
            ),
            _buildSwitchItem(
              icon: Icons.vibration,
              title: '震动提醒',
              subtitle: '新消息时震动提醒',
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
              },
            ),

            // 外观设置
            _buildSectionTitle('外观设置'),
            _buildSwitchItem(
              icon: Icons.dark_mode,
              title: '深色模式',
              subtitle: '使用深色主题',
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
                // TODO: 实现主题切换
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('主题切换功能开发中')),
                );
              },
            ),

            // 存储设置
            _buildSectionTitle('存储设置'),
            _buildSettingItem(
              icon: Icons.cleaning_services,
              title: '清除缓存',
              subtitle: '清除临时文件和图片缓存',
              trailing: const Icon(Icons.chevron_right),
              onTap: _showClearCacheDialog,
            ),

            // 隐私与安全
            _buildSectionTitle('隐私与安全'),
            _buildSettingItem(
              icon: Icons.privacy_tip,
              title: '隐私政策',
              subtitle: '了解我们如何保护您的隐私',
              trailing: const Icon(Icons.chevron_right),
              onTap: _showPrivacyDialog,
            ),
            _buildSettingItem(
              icon: Icons.description,
              title: '用户协议',
              subtitle: '查看服务条款和使用规则',
              trailing: const Icon(Icons.chevron_right),
              onTap: _showTermsDialog,
            ),
            _buildSettingItem(
              icon: Icons.block,
              title: '黑名单管理',
              subtitle: '管理被屏蔽的用户',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: 跳转到黑名单管理页面
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('黑名单管理功能开发中')),
                );
              },
            ),

            // 关于
            _buildSectionTitle('关于'),
            _buildSettingItem(
              icon: Icons.info,
              title: '版本信息',
              subtitle: 'v1.0.0',
              trailing: const Icon(Icons.chevron_right),
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
                    const SizedBox(height: 16),
                    const Text('开发团队：Flutter开发者'),
                    const Text('联系邮箱：support@example.com'),
                  ],
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.feedback,
              title: '意见反馈',
              subtitle: '帮助我们改进应用',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: 跳转到反馈页面
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('意见反馈功能开发中')),
                );
              },
            ),

            // 危险操作
            _buildSectionTitle('账户管理'),
            _buildSettingItem(
              icon: Icons.delete_forever,
              title: '注销账户',
              subtitle: '永久删除账户和所有数据',
              iconColor: Colors.red,
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: _showAccountDeletionDialog,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}