import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../models/moment_model.dart';

import '../../providers/moment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../constants/app_colors.dart';
import '../../utils/image_utils.dart';

class MomentDetailPage extends StatefulWidget {
  final String momentId;

  const MomentDetailPage({
    super.key,
    required this.momentId,
  });

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  MomentModel? _moment;

  @override
  void initState() {
    super.initState();
    _loadMomentDetail();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMomentDetail() async {
    try {
      final momentProvider = Provider.of<MomentProvider>(context, listen: false);
      final moment = await momentProvider.getMomentDetail(widget.momentId);
      setState(() {
        _moment = moment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  Future<void> _toggleLike() async {
    if (_moment == null) return;

    try {
      final momentProvider = Provider.of<MomentProvider>(context, listen: false);
      await momentProvider.likeMoment(_moment!.id);
      
      setState(() {
        _moment = _moment!.copyWith(
          isLiked: !_moment!.isLiked,
          likeCount: _moment!.isLiked ? _moment!.likeCount - 1 : _moment!.likeCount + 1,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败: $e')),
      );
    }
  }

  Future<void> _addComment() async {
    if (_moment == null || _commentController.text.trim().isEmpty) return;

    try {
      final momentProvider = Provider.of<MomentProvider>(context, listen: false);
      await momentProvider.commentMoment(_moment!.id, _commentController.text.trim());
      
      _commentController.clear();
      await _loadMomentDetail(); // 重新加载获取最新评论
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('评论成功')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('评论失败: $e')),
      );
    }
  }

  void _showImageViewer(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              '${initialIndex + 1}/${images.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(ImageUtils.buildImageUrl(images[index])),
                initialScale: PhotoViewComputedScale.contained,
                minScale: 0.8,
                maxScale: 2.0,
              );
            },
            itemCount: images.length,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
            pageController: PageController(initialPage: initialIndex),
          ),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isOwner = _moment?.author.id == authProvider.user?.id;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOwner)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('删除动态', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMoment();
                },
              ),
            if (!isOwner) ...
              [
                ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text('举报'),
                  onTap: () {
                    Navigator.pop(context);
                    _reportMoment();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('屏蔽用户'),
                  onTap: () {
                    Navigator.pop(context);
                    _blockUser();
                  },
                ),
              ],
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

  Future<void> _deleteMoment() async {
    if (_moment == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条动态吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final momentProvider = Provider.of<MomentProvider>(context, listen: false);
        await momentProvider.deleteMoment(_moment!.id);
        
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('删除成功')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('删除失败: $e')),
        );
      }
    }
  }

  Future<void> _reportMoment() async {
    // 举报功能实现
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('举报已提交')),
    );
  }

  Future<void> _blockUser() async {
    // 屏蔽用户功能实现
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('用户已屏蔽')),
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
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${time.month}-${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    if (images.length == 1) {
      return GestureDetector(
        onTap: () => _showImageViewer(images, 0),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 200,
            maxHeight: 200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: ImageUtils.buildImageUrl(images[0]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: images.length == 2 ? 2 : 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageViewer(images, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: ImageUtils.buildImageUrl(images[index]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动态详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _moment == null
              ? const Center(child: Text('动态不存在'))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 作者信息
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: _moment!.author.avatar?.isNotEmpty == true
                      ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(_moment!.author.avatar!))
                      : null,
                                  child: _moment!.author.avatar?.isEmpty != false
                                      ? Text(_moment!.author.nickname[0])
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _moment!.author.nickname,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        _formatTime(_moment!.createdAt),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // 动态内容
                            if (_moment!.content.isNotEmpty)
                              Text(
                                _moment!.content,
                                style: const TextStyle(fontSize: 16),
                              ),
                            
                            if (_moment!.content.isNotEmpty && _moment!.images.isNotEmpty)
                              const SizedBox(height: 12),
                            
                            // 图片
                            _buildImageGrid(_moment!.images),
                            
                            const SizedBox(height: 16),
                            
                            // 点赞和评论统计
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _toggleLike,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _moment!.isLiked ? Icons.favorite : Icons.favorite_border,
                                        color: _moment!.isLiked ? Colors.red : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_moment!.likeCount}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.comment_outlined,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_moment!.commentCount}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // 评论列表
                            if (_moment!.comments.isNotEmpty) ...
                              [
                                const Text(
                                  '评论',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _moment!.comments.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final comment = _moment!.comments[index];
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundImage: comment.author.avatar?.isNotEmpty == true
                                                    ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(comment.author.avatar!))
                                                    : null,
                                                child: comment.author.avatar?.isEmpty != false
                                                    ? Text(
                                                        comment.author.nickname[0],
                                                        style: const TextStyle(fontSize: 10),
                                                      )
                                                    : null,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                comment.author.nickname,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                _formatTime(comment.createdAt),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            comment.content,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                          ],
                        ),
                      ),
                    ),
                    
                    // 评论输入框
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
                            Expanded(
                              child: CustomTextField(
                                controller: _commentController,
                                hintText: '写评论...',
                                maxLines: 3,
                                minLines: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            CustomButton(
                              text: '发送',
                              onPressed: _addComment,
                              width: 60,
                              height: 36,
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