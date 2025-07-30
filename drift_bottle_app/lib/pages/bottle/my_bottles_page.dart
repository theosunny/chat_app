import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/bottle_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/bottle_model.dart';
import '../../utils/image_utils.dart';
import 'bottle_detail_page.dart';

class MyBottlesPage extends StatefulWidget {
  const MyBottlesPage({super.key});

  @override
  State<MyBottlesPage> createState() => _MyBottlesPageState();
}

class _MyBottlesPageState extends State<MyBottlesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefreshController _refreshController = RefreshController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMyBottles();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadMyBottles() async {
    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    await bottleProvider.fetchMyBottles();
  }

  Future<void> _onRefresh() async {
    await _loadMyBottles();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.textPrimary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '我的漂流瓶',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(text: '我发布的'),
          Tab(text: '我捞到的'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMyPublishedBottles(),
        _buildMyPickedBottles(),
      ],
    );
  }

  Widget _buildMyPublishedBottles() {
    return Consumer<BottleProvider>(
      builder: (context, bottleProvider, child) {
        if (bottleProvider.isLoading && bottleProvider.bottles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (bottleProvider.bottles.isEmpty) {
          return _buildEmptyState(
            icon: Icons.message_outlined,
            title: '还没有发布过漂流瓶',
            subtitle: '快去写下你的第一个漂流瓶吧',
          );
        }

        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: bottleProvider.bottles.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildBottleItem(
                        bottleProvider.bottles[index],
                        index,
                        isMyPublished: true,
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

  Widget _buildMyPickedBottles() {
    return Consumer<BottleProvider>(
      builder: (context, bottleProvider, child) {
        // 这里应该是捞到的瓶子列表，暂时使用相同的数据
        final pickedBottles = bottleProvider.bottles.where((bottle) => 
            bottle.pickedAt != null).toList();

        if (bottleProvider.isLoading && pickedBottles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (pickedBottles.isEmpty) {
          return _buildEmptyState(
            icon: Icons.waves,
            title: '还没有捞到过漂流瓶',
            subtitle: '快去大海里捞一个瓶子吧',
          );
        }

        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: pickedBottles.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildBottleItem(
                        pickedBottles[index],
                        index,
                        isMyPublished: false,
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

  Widget _buildBottleItem(BottleModel bottle, int index, {required bool isMyPublished}) {
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
                builder: (context) => BottleDetailPage(bottle: bottle),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头部信息
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundImage: bottle.author.avatar != null
                          ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(bottle.author.avatar!))
                          : null,
                      child: bottle.author.avatar == null
                          ? Icon(
                              Icons.person,
                              size: 16.w,
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                    
                    SizedBox(width: 8.w),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bottle.author.nickname,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _formatTime(isMyPublished ? bottle.createdAt : bottle.pickedAt!),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 状态标签
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isMyPublished
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        isMyPublished ? '已发布' : '已捞到',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isMyPublished ? AppColors.primary : AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    if (isMyPublished) ...[
                      SizedBox(width: 8.w),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          size: 16.w,
                          color: AppColors.textSecondary,
                        ),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _showDeleteDialog(bottle);
                          }
                        },
                        itemBuilder: (context) => [
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
                                Text(
                                  '删除',
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                
                SizedBox(height: 12.h),
                
                // 内容
                Text(
                  bottle.content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (bottle.imageUrl != null && bottle.imageUrl!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildImageGrid([bottle.imageUrl!]),
                ],
                
                SizedBox(height: 12.h),
                
                // 统计信息
                Row(
                  children: [
                    _buildStatItem(
                      icon: Icons.favorite_border,
                      count: bottle.likeCount,
                      label: '点赞',
                    ),
                    
                    SizedBox(width: 24.w),
                    
                    _buildStatItem(
                      icon: Icons.chat_bubble_outline,
                      count: bottle.replyCount,
                      label: '回复',
                    ),
                    
                    if (isMyPublished) ...[
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '浏览 0',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
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
    
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length > 3 ? 3 : images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 60.w,
            height: 60.h,
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              image: DecorationImage(
                image: CachedNetworkImageProvider(ImageUtils.buildImageUrl(images[index])),
                fit: BoxFit.cover,
              ),
            ),
            child: images.length > 3 && index == 2
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        '+${images.length - 2}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14.w,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 4.w),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80.w,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          
          SizedBox(height: 16.h),
          
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BottleModel bottle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除漂流瓶'),
          content: const Text('确定要删除这个漂流瓶吗？删除后无法恢复。'),
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
                _deleteBottle(bottle);
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

  Future<void> _deleteBottle(BottleModel bottle) async {
    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    final success = await bottleProvider.deleteBottle(bottle.id);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('删除成功'),
          backgroundColor: AppColors.success,
        ),
      );
      _loadMyBottles(); // 重新加载列表
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('删除失败'),
          backgroundColor: AppColors.error,
        ),
      );
    }
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