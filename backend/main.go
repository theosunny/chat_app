package main

import (
	"fmt"
	"log"

	"chat_app_backend/config"
	"chat_app_backend/database"
	"chat_app_backend/models"
	"chat_app_backend/routes"
)

func main() {
	// 加载配置
	cfg := config.LoadConfig()

	// 初始化数据库
	if err := database.InitDatabase(cfg); err != nil {
		log.Fatal("数据库初始化失败:", err)
	}

	// 自动迁移数据库表
	if err := migrateDatabase(); err != nil {
		log.Fatal("数据库迁移失败:", err)
	}

	// 创建初始数据
	if err := createInitialData(); err != nil {
		log.Printf("创建初始数据失败: %v", err)
	}

	// 设置路由
	r := routes.SetupRoutes()

	// 启动服务器
	log.Printf("服务器启动在 http://localhost%s", cfg.ServerPort)
	log.Printf("API文档: http://localhost%s/health", cfg.ServerPort)

	if err := r.Run(cfg.ServerPort); err != nil {
		log.Fatal("启动服务器失败:", err)
	}
}

// migrateDatabase 数据库迁移
func migrateDatabase() error {
	db := database.GetDB()
	return db.AutoMigrate(
		&models.User{},
		&models.Bottle{},
		&models.Moment{},
		&models.MomentLike{},
		&models.MomentComment{},
		&models.Conversation{},
		&models.Message{},
	)
}

// createInitialData 创建初始数据
func createInitialData() error {
	db := database.GetDB()

	// 更新所有使用外部头像URL的用户为本地头像
	db.Model(&models.User{}).Where("avatar LIKE ?", "%dicebear.com%").Update("avatar", "/uploads/avatars/default1.svg")

	// 检查是否已有用户数据
	var userCount int64
	db.Model(&models.User{}).Count(&userCount)
	if userCount > 0 {
		log.Println("数据库已有数据，跳过初始化")
		return nil
	}

	// 创建示例用户
	users := []models.User{
		{
			Phone:     "13800138001",
			Nickname:  "漂流瓶小助手",
			Avatar:    "/uploads/avatars/default1.svg",
			Gender:    "unknown",
			Signature: "欢迎来到漂流瓶世界！",
		},
		{
			Phone:     "13800138002",
			Nickname:  "神秘的旅行者",
			Avatar:    "/uploads/avatars/default2.svg",
			Gender:    "male",
			Location:  "远方",
			Signature: "世界那么大，我想去看看",
		},
	}

	for _, user := range users {
		if err := db.Create(&user).Error; err != nil {
			return fmt.Errorf("创建用户失败: %v", err)
		}
	}

	// 创建示例漂流瓶
	bottles := []models.Bottle{
		{
			UserID:   1,
			Content:  "欢迎来到漂流瓶世界！这里是你分享心情、结识朋友的地方。",
			Type:     "text",
			Location: "漂流瓶海洋",
			IsPublic: true,
			Status:   "active",
		},
		{
			UserID:   2,
			Content:  "今天看到了最美的日落，想和你分享这份美好。",
			Type:     "text",
			Location: "海边",
			IsPublic: true,
			Status:   "active",
		},
		{
			UserID:   2,
			Content:  "有时候，一个人的旅行也很精彩。",
			Type:     "text",
			Location: "山顶",
			IsPublic: true,
			Status:   "active",
		},
		{
			UserID:   1,
			Content:  "希望每个人都能找到属于自己的那片海。",
			Type:     "text",
			Location: "心灵港湾",
			IsPublic: true,
			Status:   "active",
		},
	}

	for _, bottle := range bottles {
		if err := db.Create(&bottle).Error; err != nil {
			return fmt.Errorf("创建漂流瓶失败: %v", err)
		}
	}

	log.Println("初始数据创建成功")
	return nil
}