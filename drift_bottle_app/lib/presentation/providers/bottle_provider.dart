import 'package:flutter/material.dart';
import '../../data/models/bottle_model.dart';

import '../../domain/repositories/bottle_repository.dart';
import '../../domain/entities/bottle.dart';

class BottleProvider extends ChangeNotifier {
  final BottleRepository _bottleRepository;
  
  BottleProvider(this._bottleRepository);
  
  List<BottleModel> _bottles = [];
  bool _isLoading = false;
  bool _hasMore = true;

  
  List<BottleModel> get bottles => _bottles;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  
  // 获取漂流瓶列表
  Future<void> fetchBottles({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _hasMore = true;
      _bottles.clear();
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _bottleRepository.getBottles(
        limit: 20,
        beforeBottleId: _bottles.isNotEmpty && !refresh ? _bottles.last.id : null,
      );
      
      result.fold(
        (failure) {
          debugPrint('获取漂流瓶失败: ${failure.message}');
        },
        (bottles) {
          final List<BottleModel> newBottles = bottles
              .map((bottle) => BottleModel.fromEntity(bottle))
              .toList();
          
          if (refresh) {
            _bottles = newBottles;
          } else {
            _bottles.addAll(newBottles);
          }
          
          _hasMore = newBottles.length >= 20;
        },
      );
    } catch (e) {
      debugPrint('获取漂流瓶失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 捞取随机漂流瓶
  Future<BottleModel?> pickRandomBottle() async {
    try {
      // 这里需要传入具体的bottleId和位置信息
      // 暂时使用默认值，实际使用时需要从UI获取
      final result = await _bottleRepository.pickBottle(
        bottleId: 'random', // 需要实际的bottleId
        latitude: 0.0, // 需要实际的纬度
        longitude: 0.0, // 需要实际的经度
      );
      return result.fold(
        (failure) {
          debugPrint('捞取漂流瓶失败: ${failure.message}');
          return null;
        },
        (bottle) {
          final bottleModel = BottleModel.fromEntity(bottle);
          // 将新捞到的瓶子添加到列表顶部
          _bottles.insert(0, bottleModel);
          notifyListeners();
          return bottleModel;
        },
      );
    } catch (e) {
      debugPrint('捞取漂流瓶失败: $e');
      return null;
    }
  }
  
  // 发布漂流瓶
  Future<bool> publishBottle(String content, {String? imagePath}) async {
    try {
      final result = await _bottleRepository.sendBottle(
        content: content,
        contentType: imagePath != null ? BottleContentType.image : BottleContentType.text,
        mediaFiles: imagePath != null ? [imagePath] : null,
      );
      
      return result.fold(
        (failure) {
          debugPrint('发布漂流瓶失败: ${failure.message}');
          return false;
        },
        (bottle) {
          final bottleModel = BottleModel.fromEntity(bottle);
          _bottles.insert(0, bottleModel);
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('发布漂流瓶失败: $e');
    }
    return false;
  }
  
  // 回复漂流瓶
  Future<bool> replyToBottle(String bottleId, String content) async {
    try {
      final result = await _bottleRepository.replyToBottle(
        bottleId: bottleId,
        content: content,
      );
      
      return result.fold(
        (failure) {
          debugPrint('回复漂流瓶失败: ${failure.message}');
          return false;
        },
        (_) {
          // 更新本地瓶子的回复状态
          final index = _bottles.indexWhere((bottle) => bottle.id == bottleId);
          if (index != -1) {
            _bottles[index] = _bottles[index].copyWith(
              commentsCount: _bottles[index].commentsCount + 1,
            );
            notifyListeners();
          }
          return true;
        },
      );
    } catch (e) {
      debugPrint('回复漂流瓶失败: $e');
      return false;
    }
  }
  
  // 切换点赞状态
  Future<bool> toggleLike(String bottleId) async {
    try {
      final result = await _bottleRepository.likeBottle(bottleId);
      
      return result.fold(
        (failure) {
          debugPrint('点赞失败: ${failure.message}');
          return false;
        },
        (_) {
          // 更新本地瓶子的点赞状态
          final index = _bottles.indexWhere((bottle) => bottle.id == bottleId);
          if (index != -1) {
            _bottles[index] = _bottles[index].copyWith(
              isLiked: !_bottles[index].isLiked,
              likesCount: _bottles[index].isLiked 
                  ? _bottles[index].likesCount - 1 
                  : _bottles[index].likesCount + 1,
            );
            notifyListeners();
          }
          return true;
        },
      );
    } catch (e) {
      debugPrint('切换点赞状态失败: $e');
      return false;
    }
  }
  
  // 删除漂流瓶
  Future<bool> deleteBottle(String bottleId) async {
    try {
      final result = await _bottleRepository.deleteBottle(bottleId);
      
      return result.fold(
        (failure) {
          debugPrint('删除漂流瓶失败: ${failure.message}');
          return false;
        },
        (_) {
          // 从本地列表中移除
          _bottles.removeWhere((bottle) => bottle.id == bottleId);
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('删除漂流瓶失败: $e');
      return false;
    }
  }

  // 获取瓶子详情
  Future<BottleModel?> getBottleDetail(String bottleId) async {
    try {
      final result = await _bottleRepository.getBottleDetail(bottleId);
      return result.fold(
        (failure) {
          debugPrint('获取瓶子详情失败: ${failure.message}');
          return null;
        },
        (bottle) => BottleModel.fromEntity(bottle),
      );
    } catch (e) {
      debugPrint('获取瓶子详情失败: $e');
      return null;
    }
  }
  
  // 获取我的漂流瓶
  Future<void> fetchMyBottles({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _hasMore = true;
      _bottles.clear();
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _bottleRepository.getMySentBottles(
        limit: 20,
        offset: _bottles.isNotEmpty && !refresh ? _bottles.length : 0,
      );
      
      result.fold(
        (failure) {
          debugPrint('获取我的漂流瓶失败: ${failure.message}');
        },
        (bottles) {
          final List<BottleModel> newBottles = bottles
              .map((bottle) => BottleModel.fromEntity(bottle))
              .toList();
          
          if (refresh) {
            _bottles = newBottles;
          } else {
            _bottles.addAll(newBottles);
          }
          
          _hasMore = newBottles.length >= 20;
        },
      );
    } catch (e) {
      debugPrint('获取我的漂流瓶失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 清空瓶子列表
  void clearBottles() {
    _bottles.clear();
    _hasMore = true;
    notifyListeners();
  }
}