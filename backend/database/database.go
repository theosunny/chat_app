package database

import (
	"fmt"
	"log"
	"time"

	"chat_app_backend/config"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// User 用户模型
type User struct {
	ID           uint      `json:"id" gorm:"primaryKey"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
	Phone        string    `json:"phone" gorm:"uniqueIndex;size:20"`
	ThirdPartyID string    `json:"third_party_id" gorm:"uniqueIndex;size:100"`
	Nickname     string    `json:"nickname" gorm:"size:50"`
	Avatar       string    `json:"avatar" gorm:"size:255"`
	Gender       string    `json:"gender" gorm:"size:10;default:unknown"`
	Age          int       `json:"age"`
	Location     string    `json:"location" gorm:"size:100"`
	Signature    string    `json:"signature" gorm:"size:200"`
}

// TableName 指定表名
func (User) TableName() string {
	return "users"
}

// Bottle 漂流瓶模型
type Bottle struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	UserID    uint      `json:"user_id" gorm:"index"`
	User      User      `json:"user" gorm:"foreignKey:UserID"`
	Content   string    `json:"content" gorm:"type:text"`
	Type      string    `json:"type" gorm:"size:20;default:text"`
	Location  string    `json:"location" gorm:"size:100"`
	IsPublic  bool      `json:"is_public" gorm:"default:true"`
	PickCount int       `json:"pick_count" gorm:"default:0"`
	LikeCount int       `json:"like_count" gorm:"default:0"`
	Status    string    `json:"status" gorm:"size:20;default:active"`
}

// TableName 指定表名
func (Bottle) TableName() string {
	return "bottles"
}

var db *gorm.DB

// InitDatabase 初始化数据库连接
func InitDatabase(cfg *config.Config) error {
	var err error
	
	// 配置GORM日志
	newLogger := logger.New(
		log.New(log.Writer(), "\r\n", log.LstdFlags),
		logger.Config{
			SlowThreshold:             time.Second,
			LogLevel:                  logger.Info,
			IgnoreRecordNotFoundError: true,
			ParameterizedQueries:      true,
			Colorful:                  false,
		},
	)

	// 连接MySQL数据库
	db, err = gorm.Open(mysql.Open(cfg.DatabaseDSN), &gorm.Config{
		Logger: newLogger,
	})
	if err != nil {
		return fmt.Errorf("连接数据库失败: %v", err)
	}

	// 获取底层sql.DB对象进行连接池配置
	sqlDB, err := db.DB()
	if err != nil {
		return fmt.Errorf("获取数据库连接失败: %v", err)
	}

	// 设置连接池参数
	sqlDB.SetMaxIdleConns(10)           // 最大空闲连接数
	sqlDB.SetMaxOpenConns(100)          // 最大打开连接数
	sqlDB.SetConnMaxLifetime(time.Hour) // 连接最大生存时间

	fmt.Println("数据库连接成功")
	return nil
}

// GetDB 获取数据库实例
func GetDB() *gorm.DB {
	return db
}

// 用户相关操作

// CreateUser 创建用户
func CreateUser(user *User) error {
	return db.Create(user).Error
}

// GetUserByID 根据ID获取用户
func GetUserByID(userID uint) (*User, error) {
	var user User
	err := db.First(&user, userID).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// GetUserByPhone 根据手机号获取用户
func GetUserByPhone(phone string) (*User, error) {
	var user User
	err := db.Where("phone = ?", phone).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// GetUserByThirdPartyID 根据第三方ID获取用户
func GetUserByThirdPartyID(thirdPartyID string) (*User, error) {
	var user User
	err := db.Where("third_party_id = ?", thirdPartyID).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// UpdateUser 更新用户信息
func UpdateUser(userID uint, updates map[string]interface{}) error {
	return db.Model(&User{}).Where("id = ?", userID).Updates(updates).Error
}

// 漂流瓶相关操作

// CreateBottle 创建漂流瓶
func CreateBottle(bottle *Bottle) error {
	return db.Create(bottle).Error
}

// GetBottleByID 根据ID获取漂流瓶
func GetBottleByID(bottleID uint) (*Bottle, error) {
	var bottle Bottle
	err := db.Preload("User").First(&bottle, bottleID).Error
	if err != nil {
		return nil, err
	}
	return &bottle, nil
}

// GetBottles 获取漂流瓶列表（分页）
func GetBottles(page, pageSize int) ([]*Bottle, int64, error) {
	var bottles []*Bottle
	var total int64

	// 计算偏移量
	offset := (page - 1) * pageSize

	// 查询总数
	err := db.Model(&Bottle{}).Where("is_public = ? AND status = ?", true, "active").Count(&total).Error
	if err != nil {
		return nil, 0, err
	}

	// 查询数据
	err = db.Preload("User").Where("is_public = ? AND status = ?", true, "active").
		Order("created_at DESC").Offset(offset).Limit(pageSize).Find(&bottles).Error
	if err != nil {
		return nil, 0, err
	}

	return bottles, total, nil
}

// GetBottlesByUserID 根据用户ID获取漂流瓶列表
func GetBottlesByUserID(userID uint, page, pageSize int) ([]*Bottle, int64, error) {
	var bottles []*Bottle
	var total int64

	// 计算偏移量
	offset := (page - 1) * pageSize

	// 查询总数
	err := db.Model(&Bottle{}).Where("user_id = ?", userID).Count(&total).Error
	if err != nil {
		return nil, 0, err
	}

	// 查询数据
	err = db.Preload("User").Where("user_id = ?", userID).
		Order("created_at DESC").Offset(offset).Limit(pageSize).Find(&bottles).Error
	if err != nil {
		return nil, 0, err
	}

	return bottles, total, nil
}

// GetRandomBottle 获取随机漂流瓶（排除指定用户的）
func GetRandomBottle(excludeUserID uint) (*Bottle, error) {
	var bottle Bottle
	err := db.Preload("User").Where("user_id != ? AND is_public = ? AND status = ?", excludeUserID, true, "active").
		Order("RAND()").First(&bottle).Error
	if err != nil {
		return nil, err
	}
	return &bottle, nil
}

// UpdateBottle 更新漂流瓶
func UpdateBottle(bottleID uint, updates map[string]interface{}) error {
	return db.Model(&Bottle{}).Where("id = ?", bottleID).Updates(updates).Error
}

// DeleteBottle 删除漂流瓶
func DeleteBottle(bottleID uint) error {
	return db.Delete(&Bottle{}, bottleID).Error
}