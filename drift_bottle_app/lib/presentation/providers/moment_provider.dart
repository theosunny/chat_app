import 'package:flutter/material.dart';
import '../../data/models/moment_model.dart';
import '../../core/di/injection.dart';
import '../../domain/repositories/moment_repository.dart';

class MomentProvider extends ChangeNotifier {
  final MomentRepository _momentRepository;
  
  MomentProvider(this._momentRepository);
  
  List<MomentModel> _moments = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  
  List<MomentModel> get moments => _moments;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  
  // 获取动态列表
  Future<void> fetchMoments({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _moments.clear();
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _momentRepository.getMoments(
        page: _currentPage,
        limit: 20,
      );
      
      result.fold(
        (failure) {
          debugPrint('获取动态失败: ${failure.message}');
        },
        (moments) {
          final List<MomentModel> newMoments = moments
              .map((moment) => MomentModel.fromEntity(moment))
              .toList();
          
          if (refresh) {
            _moments = newMoments;
          } else {
            _moments.addAll(newMoments);
          }
          
          _currentPage++;
          _hasMore = newMoments.length >= 20;
        },
      );
    } catch (e) {
      debugPrint('获取动态失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 发布动态
  Future<bool> publishMoment(String content, {List<String>? imagePaths}) async {
    try {
      final result = await _momentRepository.publishMoment(
        content: content,
        imagePaths: imagePaths,
      );
      
      return result.fold(
        (failure) {
          debugPrint('发布动态失败: ${failure.message}');
          return false;
        },
        (moment) {
          final momentModel = MomentModel.fromEntity(moment);
          _moments.insert(0, momentModel);
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('发布动态失败: $e');
      return false;
    }
  }
  
  // 点赞动态
  Future<bool> likeMoment(String momentId) async {
    try {
      final result = await _momentRepository.likeMoment(momentId);
      
      return result.fold(
        (failure) {
          debugPrint('点赞动态失败: ${failure.message}');
          return false;
        },
        (_) {
          // 更新本地动态的点赞状态
          final index = _moments.indexWhere((moment) => moment.id == momentId);
          if (index != -1) {
            final moment = _moments[index];
            _moments[index] = moment.copyWith(
              isLiked: !moment.isLiked,
              likeCount: moment.isLiked 
                ? moment.likeCount - 1 
                : moment.likeCount + 1,
          );
            notifyListeners();
          }
          return true;
        },
      );
    } catch (e) {
      debugPrint('点赞动态失败: $e');
      return false;
    }
  }
  
  // 评论动态
  Future<bool> commentMoment(
    String momentId, 
    String content, {
    String? replyToId,
  }) async {
    try {
      final result = await _momentRepository.commentMoment(
        momentId: momentId,
        content: content,
        replyToId: replyToId,
      );
      
      return result.fold(
        (failure) {
          debugPrint('评论动态失败: ${failure.message}');
          return false;
        },
        (_) {
          // 更新本地动态的评论数
          final index = _moments.indexWhere((moment) => moment.id == momentId);
          if (index != -1) {
            _moments[index] = _moments[index].copyWith(
              commentCount: _moments[index].commentCount + 1,
            );
            notifyListeners();
          }
          return true;
        },
      );
    } catch (e) {
      debugPrint('评论动态失败: $e');
      return false;
    }
  }
  
  // 获取动态详情和评论
  Future<MomentModel?> getMomentDetail(String momentId) async {
    try {
      final result = await _momentRepository.getMomentDetail(momentId);
      return result.fold(
        (failure) {
          debugPrint('获取动态详情失败: ${failure.message}');
          return null;
        },
        (moment) => MomentModel.fromEntity(moment),
      );
    } catch (e) {
      debugPrint('获取动态详情失败: $e');
      return null;
    }
  }
  
  // 删除动态
  Future<bool> deleteMoment(String momentId) async {
    try {
      final result = await _momentRepository.deleteMoment(momentId);
      
      return result.fold(
        (failure) {
          debugPrint('删除动态失败: ${failure.message}');
          return false;
        },
        (_) {
          _moments.removeWhere((moment) => moment.id == momentId);
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('删除动态失败: $e');
      return false;
    }
  }
  
  // 切换点赞状态
  Future<void> toggleLike(String momentId) async {
    try {
      // 找到对应的动态
      final momentIndex = _moments.indexWhere((moment) => moment.id == momentId);
      if (momentIndex != -1) {
        final moment = _moments[momentIndex];
        
        // 切换点赞状态
        final newIsLiked = !moment.isLiked;
        final newLikeCount = newIsLiked ? moment.likeCount + 1 : moment.likeCount - 1;
        
        // 更新本地数据
        _moments[momentIndex] = moment.copyWith(
          isLiked: newIsLiked,
          likeCount: newLikeCount,
        );
        notifyListeners();
        
        // 调用API更新服务器数据
        final result = await _momentRepository.likeMoment(momentId);
        result.fold(
          (failure) {
            // 如果出错，恢复原状态
            _moments[momentIndex] = moment.copyWith(
              isLiked: moment.isLiked,
              likeCount: moment.likeCount,
            );
            notifyListeners();
            debugPrint('点赞操作失败: ${failure.message}');
          },
          (_) {
            // 成功，保持当前状态
          },
        );
      }
    } catch (e) {
      // 如果出错，恢复原状态
      final momentIndex = _moments.indexWhere((moment) => moment.id == momentId);
      if (momentIndex != -1) {
        final moment = _moments[momentIndex];
        _moments[momentIndex] = moment.copyWith(
          isLiked: !moment.isLiked,
          likeCount: moment.isLiked ? moment.likeCount - 1 : moment.likeCount + 1,
        );
        notifyListeners();
      }
      throw Exception('点赞操作失败: $e');
    }
  }
  
  // 获取用户动态
  Future<List<MomentModel>> getUserMoments(String userId) async {
    try {
      final result = await _momentRepository.getMoments(userId: userId);
      return result.fold(
        (failure) {
          debugPrint('获取用户动态失败: ${failure.message}');
          return <MomentModel>[];
        },
        (moments) => moments
            .map((moment) => MomentModel.fromEntity(moment))
            .toList(),
      );
    } catch (e) {
      debugPrint('获取用户动态失败: $e');
      return <MomentModel>[];
    }
  }
  
  // 清空动态列表
  void clearMoments() {
    _moments.clear();
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }
}