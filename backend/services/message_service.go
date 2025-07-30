package services

import (
	"errors"
	"fmt"

	"chat_app_backend/database"
	"chat_app_backend/models"
	"gorm.io/gorm"
)

type MessageService struct{}

func NewMessageService() *MessageService {
	return &MessageService{}
}

// GetConversations 获取用户的会话列表
func (s *MessageService) GetConversations(userID uint) ([]models.Conversation, error) {
	var conversations []models.Conversation

	err := database.GetDB().Where("user1_id = ? OR user2_id = ?", userID, userID).
		Preload("User1").Preload("User2").
		Order("last_message_time DESC").
		Find(&conversations).Error

	return conversations, err
}

// GetOrCreateConversation 获取或创建会话
func (s *MessageService) GetOrCreateConversation(user1ID, user2ID uint) (*models.Conversation, error) {
	// 确保user1ID < user2ID，保持一致性
	if user1ID > user2ID {
		user1ID, user2ID = user2ID, user1ID
	}

	var conversation models.Conversation
	err := database.GetDB().Where("user1_id = ? AND user2_id = ?", user1ID, user2ID).First(&conversation).Error

	if errors.Is(err, gorm.ErrRecordNotFound) {
		// 创建新会话
		conversation = models.Conversation{
			User1ID: user1ID,
			User2ID: user2ID,
		}
		if err := database.GetDB().Create(&conversation).Error; err != nil {
			return nil, err
		}
	} else if err != nil {
		return nil, err
	}

	// 预加载用户信息
	if err := database.GetDB().Preload("User1").Preload("User2").First(&conversation, conversation.ID).Error; err != nil {
		return nil, err
	}

	return &conversation, nil
}

// GetMessages 获取会话中的消息列表
func (s *MessageService) GetMessages(conversationID uint, page, pageSize int) ([]models.Message, int64, error) {
	var messages []models.Message
	var total int64

	// 计算总数
	if err := database.GetDB().Model(&models.Message{}).Where("conversation_id = ?", conversationID).Count(&total).Error; err != nil {
		return nil, 0, err
	}

	// 分页查询，按时间倒序
	offset := (page - 1) * pageSize
	if err := database.GetDB().Where("conversation_id = ?", conversationID).
		Preload("Sender").Preload("Receiver").
		Order("created_at DESC").
		Offset(offset).Limit(pageSize).
		Find(&messages).Error; err != nil {
		return nil, 0, err
	}

	return messages, total, nil
}

// SendMessage 发送消息
func (s *MessageService) SendMessage(conversationID, senderID, receiverID uint, content, messageType string) (*models.Message, error) {
	// 开始事务
	tx := database.GetDB().Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// 创建消息
	message := &models.Message{
		ConversationID: conversationID,
		SenderID:       senderID,
		ReceiverID:     receiverID,
		Content:        content,
		MessageType:    messageType,
	}

	if err := tx.Create(message).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// 更新会话的最后消息信息
	updates := map[string]interface{}{
		"last_message_id":      message.ID,
		"last_message_content": content,
		"last_message_time":    message.CreatedAt,
	}

	// 更新接收者的未读消息数
	var conversation models.Conversation
	if err := tx.First(&conversation, conversationID).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if conversation.User1ID == receiverID {
		updates["user1_unread_count"] = gorm.Expr("user1_unread_count + ?", 1)
	} else {
		updates["user2_unread_count"] = gorm.Expr("user2_unread_count + ?", 1)
	}

	if err := tx.Model(&conversation).Updates(updates).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// 预加载关联数据
	if err := tx.Preload("Sender").Preload("Receiver").First(message, message.ID).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	return message, nil
}

// MarkMessagesAsRead 标记消息为已读
func (s *MessageService) MarkMessagesAsRead(conversationID, userID uint) error {
	// 开始事务
	tx := database.GetDB().Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// 标记消息为已读
	if err := tx.Model(&models.Message{}).
		Where("conversation_id = ? AND receiver_id = ? AND is_read = ?", conversationID, userID, false).
		Update("is_read", true).Error; err != nil {
		tx.Rollback()
		return err
	}

	// 重置未读消息数
	var conversation models.Conversation
	if err := tx.First(&conversation, conversationID).Error; err != nil {
		tx.Rollback()
		return err
	}

	var updates map[string]interface{}
	if conversation.User1ID == userID {
		updates = map[string]interface{}{"user1_unread_count": 0}
	} else {
		updates = map[string]interface{}{"user2_unread_count": 0}
	}

	if err := tx.Model(&conversation).Updates(updates).Error; err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit().Error
}

// DeleteMessage 删除消息
func (s *MessageService) DeleteMessage(messageID, userID uint) error {
	// 检查消息是否存在且属于当前用户
	var message models.Message
	if err := database.GetDB().Where("id = ? AND sender_id = ?", messageID, userID).First(&message).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return fmt.Errorf("消息不存在或无权限删除")
		}
		return err
	}

	// 软删除消息
	return database.GetDB().Delete(&message).Error
}