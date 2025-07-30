package models

import (
	"time"
	"gorm.io/gorm"
)

// Moment 动态模型
type Moment struct {
	ID        uint           `json:"id" gorm:"primarykey"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
	
	// 基本信息
	UserID    uint   `json:"user_id" gorm:"not null;index"`
	Content   string `json:"content" gorm:"type:text;not null"`
	Images    string `json:"images" gorm:"type:text"` // JSON格式存储图片URL数组
	
	// 统计信息
	LikeCount    int `json:"like_count" gorm:"default:0"`
	CommentCount int `json:"comment_count" gorm:"default:0"`
	
	// 关联
	User     User            `json:"user" gorm:"foreignKey:UserID"`
	Likes    []MomentLike    `json:"likes" gorm:"foreignKey:MomentID"`
	Comments []MomentComment `json:"comments" gorm:"foreignKey:MomentID"`
}

// MomentLike 动态点赞模型
type MomentLike struct {
	ID        uint           `json:"id" gorm:"primarykey"`
	CreatedAt time.Time      `json:"created_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
	
	MomentID uint `json:"moment_id" gorm:"not null;index"`
	UserID   uint `json:"user_id" gorm:"not null;index"`
	
	// 关联
	Moment Moment `json:"moment" gorm:"foreignKey:MomentID"`
	User   User   `json:"user" gorm:"foreignKey:UserID"`
}

// MomentComment 动态评论模型
type MomentComment struct {
	ID        uint           `json:"id" gorm:"primarykey"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
	
	MomentID uint   `json:"moment_id" gorm:"not null;index"`
	UserID   uint   `json:"user_id" gorm:"not null;index"`
	Content  string `json:"content" gorm:"type:text;not null"`
	
	// 关联
	Moment Moment `json:"moment" gorm:"foreignKey:MomentID"`
	User   User   `json:"user" gorm:"foreignKey:UserID"`
}

// TableName 指定表名
func (Moment) TableName() string {
	return "moments"
}

func (MomentLike) TableName() string {
	return "moment_likes"
}

func (MomentComment) TableName() string {
	return "moment_comments"
}