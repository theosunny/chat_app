import '../core/constants/api_constants.dart';

class ImageUtils {
  /// 构建完整的图片URL
  /// 如果imageUrl已经是完整URL（包含http或https），直接返回
  /// 如果是相对路径，则拼接API基础URL
  static String buildImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return '';
    }
    
    // 如果已经是完整URL，直接返回
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    
    // 如果是相对路径，拼接API基础URL
    if (imageUrl.startsWith('/')) {
      // 移除API路径中的/api部分，只保留基础域名和端口
      final baseUrl = ApiConstants.baseUrl;
      return '$baseUrl$imageUrl';
    }
    
    // 如果不是以/开头的相对路径，添加/
    final baseUrl = ApiConstants.baseUrl;
    return '$baseUrl/$imageUrl';
  }
  
  /// 检查图片URL是否有效
  static bool isValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return false;
    }
    
    // 检查是否是支持的图片格式
    final supportedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final lowerUrl = imageUrl.toLowerCase();
    
    return supportedExtensions.any((ext) => lowerUrl.contains(ext));
  }
}