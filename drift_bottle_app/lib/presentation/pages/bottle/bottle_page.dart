import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/image_utils.dart';
import '../../providers/bottle_provider.dart';
import '../../providers/auth_provider.dart';
import '../../themes/app_colors.dart';
import '../../widgets/widgets/custom_button.dart';
import '../../../data/models/bottle_model.dart';
import 'bottle_detail_page.dart';
import 'create_bottle_page.dart';
import 'my_bottles_page.dart';

class BottlePage extends StatefulWidget {
  const BottlePage({super.key});

  @override
  State<BottlePage> createState() => _BottlePageState();
}

class _BottlePageState extends State<BottlePage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController();
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBottles();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadBottles() async {
    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    await bottleProvider.fetchBottles();
  }

  Future<void> _onRefresh() async {
    await _loadBottles();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    await bottleProvider.fetchBottles();
    _refreshController.loadComplete();
  }

  Future<void> _pickRandomBottle() async {
    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    final bottle = await bottleProvider.pickRandomBottle();
    
    if (bottle != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottleDetailPage(bottle: bottle),
        ),
      );
    }
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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.starryPrimary.withValues(alpha: 0.8),
              AppColors.starrySecondary.withValues(alpha: 0.6),
              AppColors.starryBackground.withValues(alpha: 0.9),
                  ],
                ),
              ),
              child: SvgPicture.asset(
                'assets/images/starry_background.svg',
                fit: BoxFit.cover,
                placeholderBuilder: (context) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.starryPrimary.withValues(alpha: 0.8),
              AppColors.starrySecondary.withValues(alpha: 0.6),
              AppColors.starryBackground.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ),
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
            AppColors.starryCardBackground.withValues(alpha: 0.8),
            AppColors.starryCardBackground.withValues(alpha: 0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.starryAccent.withValues(alpha: 0.3),
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
                    Icons.auto_awesome,
                    color: AppColors.starryAccent,
                    size: 24.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '星空漂流瓶',
                    style: TextStyle(
                      fontSize: 18.sp,
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
              color: AppColors.starryAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.history,
                color: AppColors.starryAccent,
                size: 22.w,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyBottlesPage(),
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
    return Column(
      children: [
        // 捞瓶子按钮区域
        _buildPickBottleSection(),
        
        // 瓶子列表
        Expanded(
          child: _buildBottleList(),
        ),
      ],
    );
  }

  Widget _buildPickBottleSection() {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.starryPrimary.withValues(alpha: 0.8),
            AppColors.starrySecondary.withValues(alpha: 0.9),
            AppColors.starryBackground,
          ],
        ),
      ),
      child: Stack(
        children: [
          // 星星装饰
          Positioned(
            top: 30.h,
            right: 40.w,
            child: Icon(
              Icons.star,
              size: 20.w,
              color: AppColors.starryAccent.withValues(alpha: 0.6),
            ),
          ),
          Positioned(
            top: 80.h,
            left: 50.w,
            child: Icon(
              Icons.star_outline,
              size: 16.w,
              color: AppColors.starryAccent.withValues(alpha: 0.4),
            ),
          ),
          Positioned(
            top: 50.h,
            right: 80.w,
            child: Icon(
              Icons.auto_awesome,
              size: 14.w,
              color: AppColors.starryAccent.withValues(alpha: 0.5),
            ),
          ),
          // 主要内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 星空瓶子图标
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.starryAccent.withValues(alpha: 0.3),
            AppColors.starryAccent.withValues(alpha: 0.1),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.starryAccent.withValues(alpha: 0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.starryAccent.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_drink,
                    size: 50.w,
                    color: AppColors.starryAccent,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                Text(
                  '星空漂流瓶',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                Text(
                  '在浩瀚星空中捞一个瓶子',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.starryTextPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                
                SizedBox(height: 6.h),
                
                Text(
                  '也许会遇到来自星辰的美好',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.starryTextSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                Consumer<BottleProvider>(
                  builder: (context, bottleProvider, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.starryAccent,
                            AppColors.starryAccent.withValues(alpha: 0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.starryAccent.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CustomButton(
                        text: '✨ 捞星瓶 ✨',
                        onPressed: bottleProvider.isLoading ? null : _pickRandomBottle,
                        isLoading: bottleProvider.isLoading,
                        backgroundColor: Colors.transparent,
                        textColor: Color(0xFF357ABD),
                        height: 50.h,
                        borderRadius: 25.r,
                        width: 140.w,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottleList() {
    return Consumer<BottleProvider>(
      builder: (context, bottleProvider, child) {
        if (bottleProvider.isLoading && bottleProvider.bottles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (bottleProvider.bottles.isEmpty) {
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

  Widget _buildBottleItem(BottleModel bottle, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.starryCardBackground.withValues(alpha: 0.9),
            AppColors.starryCardBackground.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.starryAccent.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.starryAccent.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottleDetailPage(bottle: bottle),
              ),
            );
          },
          child: Padding(
              padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户信息
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
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.starryTextPrimary,
                            ),
                          ),
                          Text(
                            _formatTime(bottle.createdAt),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.starryTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.starryAccent.withValues(alpha: 0.2),
            AppColors.starryAccent.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: AppColors.starryAccent.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 12.w,
                            color: AppColors.starryAccent,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '瓶子',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Color(0xFF357ABD),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16.h),
                
                // 内容
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    bottle.content,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                if (bottle.imageUrl != null && bottle.imageUrl!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  _buildImageGrid([bottle.imageUrl!]),
                ],
                
                SizedBox(height: 16.h),
                
                // 互动按钮
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildActionButton(
                        icon: bottle.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        text: bottle.likeCount.toString(),
                        color: bottle.isLiked ? Color(0xFFFF6B6B) : AppColors.textSecondary,
                        onTap: () => _toggleLike(bottle),
                      ),
                      
                      SizedBox(width: 32.w),
                      
                      _buildActionButton(
                        icon: Icons.chat_bubble_outline,
                        text: bottle.replyCount.toString(),
                        color: Color(0xFF4A90E2),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottleDetailPage(bottle: bottle),
                            ),
                          );
                        },
                      ),
                      
                      Spacer(),
                      
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF4A90E2).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '查看详情',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF4A90E2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
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
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length > 3 ? 3 : images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80.w,
            height: 80.h,
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: CachedNetworkImageProvider(ImageUtils.buildImageUrl(images[index])),
                fit: BoxFit.cover,
              ),
            ),
            child: images.length > 3 && index == 2
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: Center(
                      child: Text(
                        '+${images.length - 2}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
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

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.w,
              color: color,
            ),
            SizedBox(width: 6.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.starryAccent.withValues(alpha: 0.2),
            AppColors.starryAccent.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 60.w,
              color: AppColors.starryAccent.withValues(alpha: 0.7),
            ),
          ),
          
          SizedBox(height: 24.h),
          
          Text(
            '星空中还没有漂流瓶',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.starryTextPrimary,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            '快去星海中捞一个瓶子吧 ✨',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.starryTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.starryAccent,
            AppColors.starryAccent.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.starryAccent.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: "bottle_fab",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateBottlePage(),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.create,
          color: Colors.white,
          size: 28.w,
        ),
      ),
    );
  }

  Future<void> _toggleLike(BottleModel bottle) async {
    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    await bottleProvider.toggleLike(bottle.id);
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