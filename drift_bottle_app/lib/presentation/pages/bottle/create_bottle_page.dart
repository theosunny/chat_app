import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../providers/bottle_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/widgets/custom_text_field.dart';
import '../../widgets/widgets/custom_button.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/image_utils.dart';

class CreateBottlePage extends StatefulWidget {
  const CreateBottlePage({super.key});

  @override
  State<CreateBottlePage> createState() => _CreateBottlePageState();
}

class _CreateBottlePageState extends State<CreateBottlePage> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isAnonymous = false;
  
  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    // 检查权限
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      _showSnackBar('需要相册权限才能选择图片');
      return;
    }

    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.clear();
          for (var image in images.take(9)) { // 最多9张图片
            _selectedImages.add(File(image.path));
          }
        });
      }
    } catch (e) {
      _showSnackBar('选择图片失败');
    }
  }

  Future<void> _takePhoto() async {
    // 检查权限
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _showSnackBar('需要相机权限才能拍照');
      return;
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          if (_selectedImages.length < 9) {
            _selectedImages.add(File(image.path));
          }
        });
      }
    } catch (e) {
      _showSnackBar('拍照失败');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _publishBottle() async {
    if (_contentController.text.trim().isEmpty) {
      _showSnackBar('请输入漂流瓶内容');
      return;
    }

    final bottleProvider = Provider.of<BottleProvider>(context, listen: false);
    
    final success = await bottleProvider.publishBottle(
      content: _contentController.text.trim(),
      imagePath: _selectedImages.isNotEmpty ? _selectedImages.first.path : null,
    );

    if (success) {
      _showSnackBar('漂流瓶发布成功');
      Navigator.pop(context);
    } else {
      _showSnackBar('发布失败，请重试');
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

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('拍照'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('从相册选择'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages();
                },
              ),
            ],
          ),
        );
      },
    );
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
          Icons.close,
          color: AppColors.textPrimary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '写漂流瓶',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        Consumer<BottleProvider>(
          builder: (context, bottleProvider, child) {
            return TextButton(
              onPressed: bottleProvider.isLoading ? null : _publishBottle,
              child: Text(
                '发布',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: bottleProvider.isLoading 
                      ? AppColors.textSecondary 
                      : AppColors.primary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContentInput(),
          SizedBox(height: 16.h),
          _buildImageSection(),
          SizedBox(height: 16.h),
          _buildOptionsSection(),
          SizedBox(height: 24.h),
          _buildTips(),
        ],
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '写下你想说的话',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          MultilineTextField(
            controller: _contentController,
            hintText: '分享你的心情、想法或故事...\n\n让这个漂流瓶带着你的话语，\n漂向远方，遇见有缘人。',
            maxLength: 500,
            maxLines: 8,
            minLines: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '添加图片',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const Spacer(),
              
              Text(
                '${_selectedImages.length}/9',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          _buildImageGrid(),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1,
      ),
      itemCount: _selectedImages.length + (_selectedImages.length < 9 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _selectedImages.length) {
          // 添加图片按钮
          return GestureDetector(
            onTap: _showImageOptions,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 24.w,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '添加',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        // 图片项
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: FileImage(_selectedImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Positioned(
              top: 4.w,
              right: 4.w,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 12.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '发布选项',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          Row(
            children: [
              Icon(
                Icons.visibility_off_outlined,
                size: 20.w,
                color: AppColors.textSecondary,
              ),
              
              SizedBox(width: 12.w),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '匿名发布',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '其他人将看不到你的昵称和头像',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              Switch(
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16.w,
                color: AppColors.primary,
              ),
              
              SizedBox(width: 8.w),
              
              Text(
                '温馨提示',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            '• 请文明用语，传播正能量\n• 不要发布个人隐私信息\n• 图片内容需健康向上\n• 违规内容将被删除',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}