import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/bottle_model.dart';
import '../../../domain/entities/bottle.dart';

import '../../providers/bottle_provider.dart';
import '../../widgets/widgets/custom_text_field.dart';
import '../../themes/app_colors.dart';
import '../../../utils/image_utils.dart';

class BottleDetailPage extends StatefulWidget {
  final BottleModel bottle;

  const BottleDetailPage({
    super.key,
    required this.bottle,
  });

  @override
  State<BottleDetailPage> createState() => _BottleDetailPageState();
}

class _BottleDetailPageState extends State<BottleDetailPage> {
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late BottleModel _bottle;

  @override
  void initState() {
    super.initState();
    _bottle = widget.bottle;
    _loadBottleDetail();
  }

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBottleDetail() async {
    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    final detail = await bottleProvider.getBottleDetail(_bottle.id);
    if (detail != null && mounted) {
      setState(() {
        _bottle = detail;
      });
    }
  }

  Future<void> _toggleLike() async {
    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    await bottleProvider.toggleLike(_bottle.id);
    
    setState(() {
      _bottle = _bottle.copyWith(
        isLiked: !_bottle.isLiked,
        likesCount: _bottle.isLiked 
            ? _bottle.likesCount - 1 
            : _bottle.likesCount + 1,
      );
    });
  }

  Future<void> _sendReply() async {
    if (_replyController.text.trim().isEmpty) {
      _showSnackBar('请输入回复内容');
      return;
    }

    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    final success = await bottleProvider.replyToBottle(
      _bottle.id,
      _replyController.text.trim(),
    );

    if (success) {
      _replyController.clear();
      _showSnackBar('回复成功');
      _loadBottleDetail(); // 重新加载详情
      
      // 滚动到底部
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      _showSnackBar('回复失败');
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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBottleContent(),
                  SizedBox(height: 24.h),
                  _buildRepliesSection(),
                ],
              ),
            ),
          ),
          _buildReplyInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF4A90E2),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '漂流瓶详情',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildBottleContent() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4A90E2).withValues(alpha: 0.1),
              Color(0xFF357ABD).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Color(0xFF4A90E2).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 22.r,
                    backgroundImage: _bottle.author.avatar != null
                        ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(_bottle.author.avatar!))
                        : null,
                    child: _bottle.author.avatar == null
                        ? Icon(
                            Icons.person,
                            size: 22.w,
                            color: Color(0xFF4A90E2),
                          )
                        : null,
                  ),
                ),
                
                SizedBox(width: 16.w),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _bottle.author.nickname,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.w,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatTime(_bottle.createdAt),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4A90E2),
                        Color(0xFF357ABD),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_drink,
                        size: 14.w,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '漂流瓶',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // 内容
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              _bottle.content,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textPrimary,
                height: 1.7,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          if (_bottle.imageUrl != null && _bottle.imageUrl!.isNotEmpty) ...[
            SizedBox(height: 20.h),
            _buildImageGrid(),
          ],
          
          SizedBox(height: 20.h),
          
          // 互动按钮
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _toggleLike,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: _bottle.isLiked 
                            ? LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF5252),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.withOpacity(0.1),
                                  Colors.grey.withOpacity(0.05),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: _bottle.isLiked ? [
                          BoxShadow(
                            color: Color(0xFFFF6B6B).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ] : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _bottle.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18.w,
                            color: _bottle.isLiked 
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${_bottle.likesCount} 点赞',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: _bottle.isLiked 
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 16.w),
                
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4A90E2).withOpacity(0.1),
                          Color(0xFF357ABD).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        color: Color(0xFF4A90E2).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 18.w,
                          color: Color(0xFF4A90E2),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${_bottle.replyCount} 回复',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1,
      ),
      itemCount: _bottle.imageUrl != null ? 1 : 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageViewer(index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: ImageUtils.buildImageUrl(_bottle.imageUrl!),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.background,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.background,
                child: Icon(
                  Icons.error,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRepliesSection() {
    if (_bottle.replies.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4A90E2).withOpacity(0.1),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 30.w,
                  color: Color(0xFF4A90E2),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                '暂无回复',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '成为第一个回复的人吧',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4A90E2).withOpacity(0.1),
                  Color(0xFF357ABD).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.forum,
                  size: 20.w,
                  color: Color(0xFF4A90E2),
                ),
                SizedBox(width: 8.w),
                Text(
                  '回复 (${_bottle.replies.length})',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.h),
          
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _bottle.replies.length,
            separatorBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              height: 1,
              color: Colors.grey.withOpacity(0.1),
            ),
            itemBuilder: (context, index) {
              final reply = _bottle.replies[index];
              return _buildReplyItem(reply);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReplyItem(BottleReply reply) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF4A90E2).withOpacity(0.2),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 18.r,
              backgroundImage: reply.author.avatar != null
                  ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(reply.author.avatar!))
                  : null,
              child: reply.author.avatar == null
                  ? Icon(
                      Icons.person,
                      size: 18.w,
                      color: Color(0xFF4A90E2),
                    )
                  : null,
            ),
          ),
          
          SizedBox(width: 16.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      reply.author.nickname,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    
                    SizedBox(width: 8.w),
                    
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF4A90E2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        _formatTime(reply.createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Color(0xFF4A90E2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 8.h),
                
                Text(
                  reply.content,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textPrimary,
                    height: 1.5,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: Color(0xFF4A90E2).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: CustomTextField(
                  controller: _replyController,
                  hintText: '写下你的回复...',
                  maxLines: 3,
                  minLines: 1,
                  borderRadius: 25.r,
                ),
              ),
            ),
            
            SizedBox(width: 16.w),
            
            Consumer<BottleProvider>(
              builder: (context, bottleProvider, child) {
                return GestureDetector(
                  onTap: bottleProvider.isLoading ? null : _sendReply,
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4A90E2),
                          Color(0xFF357ABD),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4A90E2).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: bottleProvider.isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 24.w,
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageViewer(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: _bottle.imageUrl != null ? 1 : 0,
            itemBuilder: (context, index) {
              return Center(
                child: CachedNetworkImage(
                  imageUrl: ImageUtils.buildImageUrl(_bottle.imageUrl!),
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.report, color: AppColors.error),
                title: const Text('举报'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('举报功能开发中');
                },
              ),
              ListTile(
                leading: Icon(Icons.block, color: AppColors.textSecondary),
                title: const Text('屏蔽用户'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('屏蔽功能开发中');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${dateTime.month}月${dateTime.day}日';
    }
  }
}