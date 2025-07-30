import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/moment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/moment_model.dart';
import '../../utils/image_utils.dart';
import 'create_moment_page.dart';
import 'moment_detail_page.dart';

class MomentPage extends StatefulWidget {
  const MomentPage({super.key});

  @override
  State<MomentPage> createState() => _MomentPageState();
}

class _MomentPageState extends State<MomentPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController();
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMoments();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadMoments() async {
    final momentProvider = Provider.of<MomentProvider>(context, listen: false);
    await momentProvider.fetchMoments();
  }

  Future<void> _onRefresh() async {
    await _loadMoments();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    final momentProvider = Provider.of<MomentProvider>(context, listen: false);
    await momentProvider.fetchMoments();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // 星空背景
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.starryPrimary,
                  AppColors.starrySecondary,
                  AppColors.starryBackground,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
          // 动态星空效果
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/starry_background.svg',
              fit: BoxFit.cover,
            ),
          ),
          // 页面内容
          Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildBody()),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.starryCardBackground.withOpacity(0.8),
            AppColors.starryCardBackground.withOpacity(0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.starryAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timeline,
                    color: AppColors.starryAccent,
                    size: 24.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '星空动态',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.starryTextPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.starryAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                // TODO: 实现搜索功能
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('搜索功能开发中'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<MomentProvider>(
      builder: (context, momentProvider, child) {
        if (momentProvider.isLoading && momentProvider.moments.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (momentProvider.moments.isEmpty) {
          return _buildEmptyState();
        }

        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: momentProvider.moments.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildMomentItem(
                        momentProvider.moments[index],
                        index,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMomentItem(MomentModel moment, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MomentDetailPage(momentId: moment.id),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户信息
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: moment.author.avatar != null
                          ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(moment.author.avatar!))
                          : null,
                      child: moment.author.avatar == null
                          ? Icon(
                              Icons.person,
                              size: 20.w,
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                    
                    SizedBox(width: 12.w),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            moment.author.nickname,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _formatTime(moment.createdAt),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 20.w,
                        color: AppColors.textSecondary,
                      ),
                      onSelected: (value) {
                        _handleMenuAction(value, moment);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'report',
                          child: Row(
                            children: [
                              Icon(
                                Icons.report_outlined,
                                size: 16.w,
                                color: AppColors.error,
                              ),
                              SizedBox(width: 8.w),
                              const Text('举报'),
                            ],
                          ),
                        ),
                        if (_isMyMoment(moment))
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 16.w,
                                  color: AppColors.error,
                                ),
                                SizedBox(width: 8.w),
                                const Text('删除'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 12.h),
                
                // 内容
                Text(
                  moment.content,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                
                if (moment.images.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildImageGrid(moment.images),
                ],
                
                SizedBox(height: 16.h),
                
                // 互动按钮
                Row(
                  children: [
                    _buildActionButton(
                      icon: moment.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      text: moment.likeCount.toString(),
                      color: moment.isLiked ? AppColors.error : AppColors.textSecondary,
                      onTap: () => _toggleLike(moment),
                    ),
                    
                    SizedBox(width: 32.w),
                    
                    _buildActionButton(
                      icon: Icons.chat_bubble_outline,
                      text: moment.commentCount.toString(),
                      color: AppColors.textSecondary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MomentDetailPage(momentId: moment.id),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(width: 32.w),
                    
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      text: '分享',
                      color: AppColors.textSecondary,
                      onTap: () => _shareMoment(moment),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();
    
    // 根据图片数量决定布局
    if (images.length == 1) {
      return _buildSingleImage(images[0]);
    } else if (images.length == 2) {
      return _buildTwoImages(images);
    } else {
      return _buildMultipleImages(images);
    }
  }

  Widget _buildSingleImage(String imageUrl) {
    return GestureDetector(
      onTap: () => _showImageViewer([imageUrl], 0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 200.h,
          maxWidth: double.infinity,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: CachedNetworkImage(
            imageUrl: ImageUtils.buildImageUrl(imageUrl),
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 200.h,
              color: AppColors.background,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200.h,
              color: AppColors.background,
              child: Icon(
                Icons.error,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoImages(List<String> images) {
    return Row(
      children: images.asMap().entries.map((entry) {
        final index = entry.key;
        final imageUrl = entry.value;
        
        return Expanded(
          child: GestureDetector(
            onTap: () => _showImageViewer(images, index),
            child: Container(
              height: 120.h,
              margin: EdgeInsets.only(right: index == 0 ? 4.w : 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: ImageUtils.buildImageUrl(imageUrl),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.background,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleImages(List<String> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
        childAspectRatio: 1,
      ),
      itemCount: images.length > 9 ? 9 : images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageViewer(images, index),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: CachedNetworkImage(
                  imageUrl: ImageUtils.buildImageUrl(images[index]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Container(
                    color: AppColors.background,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.background,
                    child: Icon(
                      Icons.error,
                      color: AppColors.textSecondary,
                      size: 16.w,
                    ),
                  ),
                ),
              ),
              
              if (images.length > 9 && index == 8)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Center(
                    child: Text(
                      '+${images.length - 8}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.w,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dynamic_feed_outlined,
            size: 80.w,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          
          SizedBox(height: 16.h),
          
          Text(
            '暂无动态',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            '快来发布第一条动态吧',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: "moment_fab",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateMomentPage(),
          ),
        );
      },
      backgroundColor: AppColors.primary,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Future<void> _toggleLike(MomentModel moment) async {
    final momentProvider = Provider.of<MomentProvider>(context, listen: false);
    await momentProvider.toggleLike(moment.id);
  }

  void _handleMenuAction(String action, MomentModel moment) {
    switch (action) {
      case 'report':
        _showSnackBar('举报功能开发中');
        break;
      case 'delete':
        _showDeleteDialog(moment);
        break;
    }
  }

  bool _isMyMoment(MomentModel moment) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.user?.id == moment.author.id;
  }

  void _showDeleteDialog(MomentModel moment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除动态'),
          content: const Text('确定要删除这条动态吗？删除后无法恢复。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '取消',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteMoment(moment);
              },
              child: Text(
                '删除',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMoment(MomentModel moment) async {
    final momentProvider = Provider.of<MomentProvider>(context, listen: false);
    final success = await momentProvider.deleteMoment(moment.id);
    
    if (success) {
      _showSnackBar('删除成功');
    } else {
      _showSnackBar('删除失败');
    }
  }

  void _shareMoment(MomentModel moment) {
    _showSnackBar('分享功能开发中');
  }

  void _showImageViewer(List<String> images, int initialIndex) {
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
            title: Text(
              '${initialIndex + 1}/${images.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Center(
                child: CachedNetworkImage(
                  imageUrl: ImageUtils.buildImageUrl(images[index]),
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
      ),
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