import 'package:flutter/material.dart';
import '../models/bottle_model.dart';
import '../services/bottle_service.dart';

class BottleProvider extends ChangeNotifier {
  final BottleService _bottleService = BottleService();
  
  List<BottleModel> _bottles = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  
  List<BottleModel> get bottles => _bottles;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  
  // 获取漂流瓶列表
  Future<void> fetchBottles({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _bottles.clear();
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _bottleService.getBottles(
        page: _currentPage,
        pageSize: 20,
      );
      
      if (result['success'] ?? (result['code'] == 200)) {
        final data = result['data'];
        final List<BottleModel> newBottles = (data['bottles'] as List? ?? [])
            .map((json) => BottleModel.fromJson(json))
            .toList();
        
        if (refresh) {
          _bottles = newBottles;
        } else {
          _bottles.addAll(newBottles);
        }
        
        _currentPage++;
        _hasMore = newBottles.length >= 20;
      }
    } catch (e) {
      debugPrint('获取漂流瓶失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 捞取随机漂流瓶
  Future<BottleModel?> pickRandomBottle() async {
    try {
      final result = await _bottleService.pickRandomBottle();
      if (result['success']) {
        final bottle = BottleModel.fromJson(result['data']);
        // 将新捞到的瓶子添加到列表顶部
        _bottles.insert(0, bottle);
        notifyListeners();
        return bottle;
      }
    } catch (e) {
      debugPrint('捞取漂流瓶失败: $e');
    }
    return null;
  }
  
  // 发布漂流瓶
  Future<bool> publishBottle(String content, {String? imagePath}) async {
    try {
      final result = await _bottleService.publishBottle(
        content: content,
        imagePath: imagePath,
      );
      
      if (result['success']) {
        final bottle = BottleModel.fromJson(result['data']);
        _bottles.insert(0, bottle);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('发布漂流瓶失败: $e');
    }
    return false;
  }
  
  // 回复漂流瓶
  Future<bool> replyToBottle(String bottleId, String content) async {
    try {
      final result = await _bottleService.replyToBottle(
        bottleId: bottleId,
        content: content,
      );
      
      if (result['success']) {
        // 更新本地瓶子的回复状态
        final index = _bottles.indexWhere((bottle) => bottle.id == bottleId);
        if (index != -1) {
          _bottles[index] = _bottles[index].copyWith(
            isReplied: true,
            replyCount: _bottles[index].replyCount + 1,
          );
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      debugPrint('回复漂流瓶失败: $e');
    }
    return false;
  }
  
  // 切换点赞状态
  Future<bool> toggleLike(String bottleId) async {
    try {
      final result = await _bottleService.likeBottle(bottleId);
      
      if (result['success']) {
        // 更新本地瓶子的点赞状态
        final index = _bottles.indexWhere((bottle) => bottle.id == bottleId);
        if (index != -1) {
          _bottles[index] = _bottles[index].copyWith(
            isLiked: !_bottles[index].isLiked,
            likeCount: _bottles[index].isLiked 
                ? _bottles[index].likeCount - 1 
                : _bottles[index].likeCount + 1,
          );
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      debugPrint('切换点赞状态失败: $e');
    }
    return false;
  }
  
  // 删除漂流瓶
  Future<bool> deleteBottle(String bottleId) async {
    try {
      final result = await _bottleService.deleteBottle(bottleId);
      
      if (result['success']) {
        // 从本地列表中移除
        _bottles.removeWhere((bottle) => bottle.id == bottleId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('删除漂流瓶失败: $e');
    }
    return false;
  }

  // 创建漂流瓶
  Future<bool> createBottle({
    required String content,
    String? imagePath,
  }) async {
    try {
      final result = await _bottleService.createBottle(
        content: content,
        imagePath: imagePath,
      );
      
      if (result['success']) {
        final bottle = BottleModel.fromJson(result['data']);
        _bottles.insert(0, bottle);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('创建漂流瓶失败: $e');
    }
    return false;
   }

   // 回复漂流瓶
   Future<bool> replyBottle({
     required String bottleId,
     required String content,
   }) async {
     try {
       final result = await _bottleService.replyToBottle(
         bottleId: bottleId,
         content: content,
       );
       
       if (result['success']) {
         return true;
       }
     } catch (e) {
       debugPrint('回复漂流瓶失败: $e');
     }
     return false;
   }
   
   // 点赞漂流瓶
  Future<bool> likeBottle(String bottleId) async {
    try {
      final result = await _bottleService.likeBottle(bottleId);
      
      if (result['success']) {
        // 更新本地瓶子的点赞状态
        final index = _bottles.indexWhere((bottle) => bottle.id == bottleId);
        if (index != -1) {
          final bottle = _bottles[index];
          _bottles[index] = bottle.copyWith(
            isLiked: !bottle.isLiked,
            likeCount: bottle.isLiked 
                ? bottle.likeCount - 1 
                : bottle.likeCount + 1,
          );
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      debugPrint('点赞漂流瓶失败: $e');
    }
    return false;
  }
  
  // 获取瓶子详情和回复
  Future<BottleModel?> getBottleDetail(String bottleId) async {
    try {
      final result = await _bottleService.getBottleDetail(bottleId);
      if (result['success']) {
        return BottleModel.fromJson(result['data']);
      }
    } catch (e) {
      debugPrint('获取瓶子详情失败: $e');
    }
    return null;
  }
  
  // 获取我的漂流瓶
  Future<void> fetchMyBottles({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _bottles.clear();
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _bottleService.getMyBottles(
        page: _currentPage,
        pageSize: 20,
      );
      
      if (result['success']) {
        final List<BottleModel> newBottles = (result['data'] as List)
            .map((json) => BottleModel.fromJson(json))
            .toList();
        
        if (refresh) {
          _bottles = newBottles;
        } else {
          _bottles.addAll(newBottles);
        }
        
        _currentPage++;
        _hasMore = newBottles.length >= 20;
      }
    } catch (e) {
      debugPrint('获取我的漂流瓶失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 清空瓶子列表
  void clearBottles() {
    _bottles.clear();
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }
}