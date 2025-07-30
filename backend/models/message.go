package models

import (
	"time"
	"gorm.io/gorm"
)

// Conversation 会话模型
type Conversation struct {
	ID        uint           `json:"id" gorm:"primarykey"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
	
	// 参与者
	User1ID uint `json:"user1_id" gorm:"not null;index"`
	User2ID uint `json:"user2_id" gorm:"not null;index"`
	
	// 最后一条消息信息
	LastMessageID      *uint     `json:"last_message_id"`
	LastMessageContent string    `json:"last_message_content"`
	LastMessageTime    time.Time `json:"last_message_time"`
	
	// 未读消息数
	User1UnreadCount int `json:"user1_unread_count" gorm:"default:0"`
	User2UnreadCount int `json:"user2_unread_count" gorm:"default:0"`
	
	// 关联
	User1    User      `json:"user1" gorm:"foreignKey:User1ID"`
	User2    User      `json:"user2" gorm:"foreignKey:User2ID"`
	Messages []Message `json:"messages" gorm:"foreignKey:ConversationID"`
}

// Message 消息模型
type Message struct {
	ID        uint           `json:"id" gorm:"primarykey"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
	
	// 基本信息
	ConversationID uint   `json:"conversation_id" gorm:"not null;index"`
	SenderID       uint   `json:"sender_id" gorm:"not null;index"`
	ReceiverID     uint   `json:"receiver_id" gorm:"not null;index"`
	Content        string `json:"content" gorm:"type:text;not null"`
	MessageType    string `json:"message_type" gorm:"default:'text'"` // text, image, file
	
	// 状态
	IsRead bool `json:"is_read" gorm:"default:false"`
	
	// 关联
	Conversation Conversation `json:"conversation" gorm:"foreignKey:ConversationID"`
	Sender       User         `json:"sender" gorm:"foreignKey:SenderID"`
	Receiver     User         `json:"receiver" gorm:"foreignKey:ReceiverID"`
}

// TableName 指定表名
func (Conversation) TableName() string {
	return "conversations"
}

func (Message) TableName() string {
	return "messages"
}