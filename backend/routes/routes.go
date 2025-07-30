package routes

import (
	"chat_app_backend/config"
	"chat_app_backend/handlers"
	"chat_app_backend/middleware"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

// SetupRoutes 设置路由
func SetupRoutes() *gin.Engine {
	r := gin.Default()

	// 配置CORS
	corsConfig := cors.DefaultConfig()
	corsConfig.AllowOrigins = []string{"http://localhost:3000", "http://localhost:8080", "http://localhost:8081", "http://localhost:52000", "http://localhost:8082"}
	corsConfig.AllowMethods = []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}
	corsConfig.AllowHeaders = []string{"Origin", "Content-Type", "Accept", "Authorization", "X-User-ID"}
	corsConfig.AllowCredentials = true
	r.Use(cors.New(corsConfig))

	// 获取JWT密钥
	cfg := config.LoadConfig()

	// 创建处理器实例
	userHandler := handlers.NewUserHandler(cfg.JWTSecret)
	bottleHandler := handlers.NewBottleHandler()
	momentHandler := handlers.NewMomentHandler()
	messageHandler := handlers.NewMessageHandler()
	uploadHandler := handlers.NewUploadHandler()

	// 静态文件服务
	r.Static("/uploads", "./uploads")

	// API路由组
	api := r.Group("/api")
	{
		// 用户相关路由
		user := api.Group("/user")
		{
			user.POST("/send-code", userHandler.SendCode)     // 发送验证码
			user.POST("/login", userHandler.Login)           // 手机号登录
			
			// 需要认证的路由
			auth := user.Group("/")
			auth.Use(middleware.AuthMiddleware(cfg.JWTSecret))
			{
				auth.GET("/profile", userHandler.GetProfile)     // 获取用户信息
				auth.PUT("/profile", userHandler.UpdateProfile)  // 更新用户信息
			}
		}

		// 漂流瓶相关路由（需要认证）
		bottles := api.Group("/bottles")
		bottles.Use(middleware.AuthMiddleware(cfg.JWTSecret))
		{
			bottles.GET("", bottleHandler.GetBottles)                    // 获取漂流瓶列表
			bottles.POST("/pick", bottleHandler.PickRandomBottle)        // 捞取随机漂流瓶
			bottles.POST("", bottleHandler.CreateBottle)                 // 创建漂流瓶
			bottles.GET("/:id", bottleHandler.GetBottleDetail)           // 获取漂流瓶详情
			bottles.GET("/my", bottleHandler.GetMyBottles)               // 获取我的漂流瓶
			bottles.DELETE("/:id", bottleHandler.DeleteBottle)           // 删除漂流瓶
		}

		// 动态相关路由
		moments := api.Group("/moments")
		{
			moments.GET("", momentHandler.GetMoments)                                    // 获取动态列表
			moments.POST("", middleware.AuthMiddleware(cfg.JWTSecret), momentHandler.CreateMoment)     // 创建动态
			moments.GET("/:id", momentHandler.GetMomentDetail)                           // 获取动态详情
			moments.POST("/:id/like", middleware.AuthMiddleware(cfg.JWTSecret), momentHandler.LikeMoment)   // 点赞动态
			moments.DELETE("/:id/like", middleware.AuthMiddleware(cfg.JWTSecret), momentHandler.UnlikeMoment) // 取消点赞
			moments.POST("/:id/comment", middleware.AuthMiddleware(cfg.JWTSecret), momentHandler.AddComment) // 添加评论
			moments.DELETE("/:id", middleware.AuthMiddleware(cfg.JWTSecret), momentHandler.DeleteMoment)     // 删除动态
		}

		// 消息相关路由
		messages := api.Group("/messages")
		messages.Use(middleware.AuthMiddleware(cfg.JWTSecret))
		{
			messages.GET("/conversations", messageHandler.GetConversations)  // 获取会话列表
			messages.GET("", messageHandler.GetMessages)                     // 获取消息列表
			messages.POST("/send", messageHandler.SendMessage)               // 发送消息
			messages.POST("/conversation", messageHandler.StartConversation) // 开始会话
			messages.DELETE("/:id", messageHandler.DeleteMessage)            // 删除消息
		}

		// 文件上传相关路由
		upload := api.Group("/upload")
		upload.Use(middleware.AuthMiddleware(cfg.JWTSecret))
		{
			upload.POST("/image", uploadHandler.UploadImage)   // 上传图片
			upload.POST("/avatar", uploadHandler.UploadAvatar) // 上传头像
		}
	}

	// 健康检查
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":  "ok",
			"message": "服务运行正常",
		})
	})

	return r
}