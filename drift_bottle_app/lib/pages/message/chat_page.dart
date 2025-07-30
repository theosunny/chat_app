import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';
import '../../providers/message_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../constants/app_colors.dart';
import '../../utils/image_utils.dart';

class ChatPage extends StatefulWidget {
  final UserModel otherUser;
  final String? conversationId;

  const ChatPage({
    super.key,
    required this.otherUser,
    this.conversationId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;
  bool _isSending = false;
  List<MessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (widget.conversationId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      await messageProvider.fetchMessages(widget.otherUser.id, refresh: true);
      final messages = messageProvider.messages;
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      
      // 标记消息为已读
      await messageProvider.markAsRead(widget.conversationId!);
      
      // 滚动到底部
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载消息失败: $e')),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage({String? content, File? image}) async {
    if ((content == null || content.trim().isEmpty) && image == null) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await messageProvider.sendMessage(
        widget.otherUser.id,
        content ?? '',
      );

      if (success) {
        await messageProvider.fetchMessages(widget.otherUser.id);
        setState(() {
          _messages = messageProvider.messages;
        });
      }

      _messageController.clear();
      
      // 滚动到底部
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败: $e')),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      // 请求相册权限
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('需要相册权限才能选择图片')),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );

      if (image != null) {
        await _sendMessage(image: File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择图片失败: $e')),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      // 请求相机权限
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('需要相机权限才能拍照')),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );

      if (image != null) {
        await _sendMessage(image: File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('拍照失败: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('取消'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageViewer(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: ImageUtils.buildImageUrl(imageUrl),
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month}-${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildMessage(MessageModel message) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isMe = message.sender.id == authProvider.user?.id;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...
              [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: widget.otherUser.avatar?.isNotEmpty == true
                        ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(widget.otherUser.avatar!))
                        : null,
                  child: widget.otherUser.avatar?.isEmpty != false
                      ? Text(
                          widget.otherUser.nickname[0],
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
              ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Theme.of(context).primaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: message.type == MessageType.image
                        ? GestureDetector(
                            onTap: () => _showImageViewer(message.content),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: ImageUtils.buildImageUrl(message.content),
                                width: 200.w,
                                height: 200.w,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 200.w,
                                  height: 200.w,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 200.w,
                                  height: 200.w,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            ),
                          )
                        : Text(
                            message.content,
                            style: TextStyle(
                              color: isMe ? Colors.white : AppColors.textPrimary,
                              fontSize: 16.sp,
                            ),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isMe) ...
              [
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundImage: authProvider.user!.avatar?.isNotEmpty == true
                      ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(authProvider.user!.avatar!))
                      : null,
                  child: authProvider.user?.avatar?.isEmpty != false
                      ? Text(
                          authProvider.user!.nickname[0],
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
                ),
              ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.otherUser.avatar?.isNotEmpty == true
                    ? CachedNetworkImageProvider(widget.otherUser.avatar!)
                    : null,
              child: widget.otherUser.avatar?.isEmpty != false
                  ? Text(
                      widget.otherUser.nickname[0],
                      style: const TextStyle(fontSize: 12),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(widget.otherUser.nickname),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: 显示更多选项（举报、屏蔽等）
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('更多功能开发中')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '开始聊天吧',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessage(_messages[index]);
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate),
                    onPressed: _isSending ? null : _showImageSourceDialog,
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: _messageController,
                      hintText: '输入消息...',
                      maxLines: 4,
                      minLines: 1,
                      enabled: !_isSending,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _sendMessage(content: value.trim());
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    onPressed: _isSending
                        ? null
                        : () {
                            final content = _messageController.text.trim();
                            if (content.isNotEmpty) {
                              _sendMessage(content: content);
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}