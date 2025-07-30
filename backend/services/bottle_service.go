package services

import (
	"errors"
	"fmt"

	"chat_app_backend/database"
	"gorm.io/gorm"
)

type BottleService struct {
	db *gorm.DB
}

// NewBottleService 创建漂流瓶服务实例
func NewBottleService() *BottleService {
	return &BottleService{
		db: database.GetDB(),
	}
}

// GetBottles 获取漂流瓶列表
func (s *BottleService) GetBottles(page, pageSize int) ([]*database.Bottle, int64, error) {
	bottles, total, err := database.GetBottles(page, pageSize)
	if err != nil {
		return nil, 0, fmt.Errorf("获取漂流瓶列表失败: %v", err)
	}
	return bottles, total, nil
}

// CatchBottle 捞取随机漂流瓶
func (s *BottleService) CatchBottle(userID uint) (*database.Bottle, error) {
	bottle, err := database.GetRandomBottle(userID)
	if err != nil {
		return nil, fmt.Errorf("捞取漂流瓶失败: %v", err)
	}

	// 增加拾取次数
	if err := database.UpdateBottle(bottle.ID, map[string]interface{}{
		"pick_count": bottle.PickCount + 1,
	}); err != nil {
		return nil, fmt.Errorf("更新拾取次数失败: %v", err)
	}

	bottle.PickCount++
	return bottle, nil
}

// CreateBottle 创建漂流瓶
func (s *BottleService) CreateBottle(userID uint, content, bottleType, location string, isPublic bool) (*database.Bottle, error) {
	bottle := &database.Bottle{
		UserID:     userID,
		Content:    content,
		Type:       bottleType,
		Location:   location,
		IsPublic:   isPublic,
		PickCount:  0,
		LikeCount:  0,
		Status:     "active",
	}

	if err := database.CreateBottle(bottle); err != nil {
		return nil, fmt.Errorf("创建漂流瓶失败: %v", err)
	}

	return bottle, nil
}

// GetBottleByID 根据ID获取漂流瓶详情
func (s *BottleService) GetBottleByID(bottleID uint) (*database.Bottle, error) {
	bottle, err := database.GetBottleByID(bottleID)
	if err != nil {
		return nil, fmt.Errorf("获取漂流瓶详情失败: %v", err)
	}
	return bottle, nil
}

// GetMyBottles 获取我的漂流瓶
func (s *BottleService) GetMyBottles(userID uint, page, pageSize int) ([]*database.Bottle, int64, error) {
	bottles, total, err := database.GetBottlesByUserID(userID, page, pageSize)
	if err != nil {
		return nil, 0, fmt.Errorf("获取我的漂流瓶失败: %v", err)
	}
	return bottles, total, nil
}

// DeleteBottle 删除漂流瓶
func (s *BottleService) DeleteBottle(bottleID, userID uint) error {
	// 检查漂流瓶是否存在且属于当前用户
	bottle, err := database.GetBottleByID(bottleID)
	if err != nil {
		return fmt.Errorf("漂流瓶不存在: %v", err)
	}

	if bottle.UserID != userID {
		return errors.New("无权限删除此漂流瓶")
	}

	if err := database.DeleteBottle(bottleID); err != nil {
		return fmt.Errorf("删除漂流瓶失败: %v", err)
	}

	return nil
}

// LikeBottle 点赞漂流瓶
func (s *BottleService) LikeBottle(bottleID uint) error {
	bottle, err := database.GetBottleByID(bottleID)
	if err != nil {
		return fmt.Errorf("漂流瓶不存在: %v", err)
	}

	if err := database.UpdateBottle(bottleID, map[string]interface{}{
		"like_count": bottle.LikeCount + 1,
	}); err != nil {
		return fmt.Errorf("点赞失败: %v", err)
	}

	return nil
}