package models

import (
	"time"

	"gorm.io/gorm"
)

// User 用户模型
type User struct {
	ID           uint           `json:"id" gorm:"primarykey"`
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `json:"-" gorm:"index"`
	Phone        string         `json:"phone" gorm:"type:varchar(20);uniqueIndex"`
	ThirdPartyID string         `json:"third_party_id" gorm:"type:varchar(100);uniqueIndex"`
	Nickname     string         `json:"nickname" gorm:"not null"`
	Avatar       string         `json:"avatar"`
	Gender       string         `json:"gender" gorm:"default:'unknown'"`
	Age          int            `json:"age"`
	Location     string         `json:"location"`
	Signature    string         `json:"signature"`
	Bottles      []Bottle       `json:"bottles" gorm:"foreignKey:UserID"`
}

// TableName 指定表名
func (User) TableName() string {
	return "users"
}