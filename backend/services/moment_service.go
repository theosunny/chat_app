package services

import (
	"encoding/json"
	"errors"
	"fmt"

	"chat_app_backend/database"
	"chat_app_backend/models"
	"gorm.io/gorm"
)

type MomentService struct{}

func NewMomentService() *MomentService {
	return &MomentService{}
}

// GetMoments 获取动态列表
func (s *MomentService) GetMoments(page, pageSize int) ([]models.Moment, int64, error) {
	var moments []models.Moment
	var total int64

	// 计算总数
	if err := database.GetDB().Model(&models.Moment{}).Count(&total).Error; err != nil {
		return nil, 0, err
	}

	// 分页查询，预加载用户信息
	offset := (page - 1) * pageSize
	if err := database.GetDB().Preload("User").Order("created_at DESC").Offset(offset).Limit(pageSize).Find(&moments).Error; err != nil {
		return nil, 0, err
	}

	return moments, total, nil
}

// CreateMoment 创建动态
func (s *MomentService) CreateMoment(userID uint, content string, images []string) (*models.Moment, error) {
	// 将图片数组转换为JSON字符串
	imagesJSON := ""
	if len(images) > 0 {
		imagesBytes, err := json.Marshal(images)
		if err != nil {
			return nil, fmt.Errorf("图片数据序列化失败: %v", err)
		}
		imagesJSON = string(imagesBytes)
	}

	moment := &models.Moment{
		UserID:  userID,
		Content: content,
		Images:  imagesJSON,
	}

	if err := database.GetDB().Create(moment).Error; err != nil {
		return nil, err
	}

	// 预加载用户信息
	if err := database.GetDB().Preload("User").First(moment, moment.ID).Error; err != nil {
		return nil, err
	}

	return moment, nil
}

// GetMomentByID 根据ID获取动态详情
func (s *MomentService) GetMomentByID(id uint) (*models.Moment, error) {
	var moment models.Moment
	if err := database.GetDB().Preload("User").Preload("Comments.User").First(&moment, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, fmt.Errorf("动态不存在")
		}
		return nil, err
	}
	return &moment, nil
}

// LikeMoment 点赞动态
func (s *MomentService) LikeMoment(momentID, userID uint) error {
	// 检查是否已经点赞
	var existingLike models.MomentLike
	if err := database.GetDB().Where("moment_id = ? AND user_id = ?", momentID, userID).First(&existingLike).Error; err == nil {
		return fmt.Errorf("已经点赞过了")
	}

	// 开始事务
	tx := database.GetDB().Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// 创建点赞记录
	like := &models.MomentLike{
		MomentID: momentID,
		UserID:   userID,
	}
	if err := tx.Create(like).Error; err != nil {
		tx.Rollback()
		return err
	}

	// 更新动态点赞数
	if err := tx.Model(&models.Moment{}).Where("id = ?", momentID).UpdateColumn("like_count", gorm.Expr("like_count + ?", 1)).Error; err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit().Error
}

// UnlikeMoment 取消点赞
func (s *MomentService) UnlikeMoment(momentID, userID uint) error {
	// 开始事务
	tx := database.GetDB().Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// 删除点赞记录
	result := tx.Where("moment_id = ? AND user_id = ?", momentID, userID).Delete(&models.MomentLike{})
	if result.Error != nil {
		tx.Rollback()
		return result.Error
	}
	if result.RowsAffected == 0 {
		tx.Rollback()
		return fmt.Errorf("未找到点赞记录")
	}

	// 更新动态点赞数
	if err := tx.Model(&models.Moment{}).Where("id = ?", momentID).UpdateColumn("like_count", gorm.Expr("like_count - ?", 1)).Error; err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit().Error
}

// AddComment 添加评论
func (s *MomentService) AddComment(momentID, userID uint, content string) (*models.MomentComment, error) {
	// 开始事务
	tx := database.GetDB().Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// 创建评论
	comment := &models.MomentComment{
		MomentID: momentID,
		UserID:   userID,
		Content:  content,
	}
	if err := tx.Create(comment).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// 更新动态评论数
	if err := tx.Model(&models.Moment{}).Where("id = ?", momentID).UpdateColumn("comment_count", gorm.Expr("comment_count + ?", 1)).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// 预加载用户信息
	if err := tx.Preload("User").First(comment, comment.ID).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	return comment, nil
}

// DeleteMoment 删除动态
func (s *MomentService) DeleteMoment(momentID, userID uint) error {
	// 检查动态是否存在且属于当前用户
	var moment models.Moment
	if err := database.GetDB().Where("id = ? AND user_id = ?", momentID, userID).First(&moment).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return fmt.Errorf("动态不存在或无权限删除")
		}
		return err
	}

	// 软删除动态
	return database.GetDB().Delete(&moment).Error
}