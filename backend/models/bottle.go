package models

import (
	"time"

	"gorm.io/gorm"
)

// Bottle 漂流瓶模型
type Bottle struct {
	ID        uint           `json:"id" gorm:"primarykey"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
	UserID    uint           `json:"user_id" gorm:"not null;index"`
	User      User           `json:"user" gorm:"foreignKey:UserID"`
	Content   string         `json:"content" gorm:"type:text;not null"`
	Type      string         `json:"type" gorm:"default:'text'"`
	Location  string         `json:"location"`
	IsPublic  bool           `json:"is_public" gorm:"default:true"`
	PickCount int            `json:"pick_count" gorm:"default:0"`
	LikeCount int            `json:"like_count" gorm:"default:0"`
	Status    string         `json:"status" gorm:"default:'active'"`
}

// TableName 指定表名
func (Bottle) TableName() string {
	return "bottles"
}

// BottleResponse 漂流瓶响应结构
type BottleResponse struct {
	ID        uint      `json:"id"`
	Content   string    `json:"content"`
	Type      string    `json:"type"`
	Location  string    `json:"location"`
	CreatedAt time.Time `json:"created_at"`
	PickCount int       `json:"pick_count"`
	LikeCount int       `json:"like_count"`
	User      struct {
		ID       uint   `json:"id"`
		Nickname string `json:"nickname"`
		Avatar   string `json:"avatar"`
	} `json:"user"`
}