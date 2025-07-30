#!/bin/bash
set -e

echo "开始创建 Chat App 项目目录结构..."

mkdir -p chat_app/backend/config
mkdir -p chat_app/backend/controller
mkdir -p chat_app/backend/service
mkdir -p chat_app/backend/model
mkdir -p chat_app/backend/middleware
mkdir -p chat_app/backend/ws

mkdir -p chat_app/frontend/lib/pages
mkdir -p chat_app/frontend/lib/controllers
mkdir -p chat_app/frontend/lib/models
mkdir -p chat_app/frontend/lib/services
mkdir -p chat_app/frontend/lib/widgets

echo "写入 backend/main.go ..."
cat > chat_app/backend/main.go <<EOF
package main

import (
	"chat_app/backend/config"
	"chat_app/backend/router"
	"log"
)

func main() {
	config.InitConfig()
	r := router.SetupRouter()
	log.Fatal(r.Run(":8080"))
}
EOF

echo "写入 backend/config/config.go ..."
cat > chat_app/backend/config/config.go <<EOF
package config

import (
	"log"
	"os"
	"github.com/joho/godotenv"
)

func InitConfig() {
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found, relying on env vars")
	}
}
EOF

echo "写入 backend/config/db.go ..."
cat > chat_app/backend/config/db.go <<EOF
package config

import (
	"fmt"
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	dsn := os.Getenv("POSTGRES_DSN") // 例如 "host=localhost user=postgres password=xxx dbname=chat_app port=5432 sslmode=disable"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect database:", err)
	}
	DB = db
	fmt.Println("Database connected")
}
EOF

echo "写入 backend/router.go ..."
cat > chat_app/backend/router.go <<EOF
package router

import (
	"chat_app/backend/controller"
	"chat_app/backend/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// 公开接口
	r.POST("/api/sendCode", controller.SendCodeHandler)
	r.POST("/api/login", controller.LoginHandler)
	r.POST("/api/socialLogin", controller.SocialLoginHandler)

	// 认证中间件
	auth := r.Group("/api")
	auth.Use(middleware.JWTAuthMiddleware())
	{
		auth.GET("/user/profile", controller.UserProfile)
		auth.POST("/post", controller.CreatePost)
		auth.GET("/post/list", controller.PostList)
		auth.POST("/comment", controller.CreateComment)
		auth.GET("/chat/history", controller.ChatHistory)
		auth.GET("/chat/ws", controller.WSHandler)
		auth.POST("/like", controller.LikeHandler)
		auth.POST("/report", controller.ReportHandler)
	}

	return r
}
EOF

echo "后端核心文件写入完毕。"

echo "写入 backend/controller/user.go ..."
cat > chat_app/backend/controller/user.go <<EOF
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UserProfile(c *gin.Context) {
	userID := c.Query("id")
	user, err := service.GetUserProfile(userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	c.JSON(http.StatusOK, user)
}
EOF

echo "写入 backend/controller/post.go ..."
cat > chat_app/backend/controller/post.go <<EOF
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func CreatePost(c *gin.Context) {
	var post model.Post
	if err := c.ShouldBindJSON(&post); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid params"})
		return
	}
	err := service.CreatePost(&post)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Create post failed"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Post created"})
}
EOF

echo "写入 backend/controller/comment.go ..."
cat > chat_app/backend/controller/comment.go <<EOF
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func CreateComment(c *gin.Context) {
	var comment model.Comment
	if err := c.ShouldBindJSON(&comment); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid params"})
		return
	}
	err := service.CreateComment(&comment)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Create comment failed"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Comment created"})
}
EOF

echo "写入 backend/controller/chat.go ..."
cat > chat_app/backend/controller/chat.go <<EOF
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func ChatHistory(c *gin.Context) {
	userID := c.Query("userId")
	friendID := c.Query("friendId")

	messages, err := service.GetChatHistory(userID, friendID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get chat history"})
		return
	}
	c.JSON(http.StatusOK, messages)
}
EOF

echo "后端 controller 文件写入完成。"

echo "写入 backend/service/user_service.go ..."
cat > chat_app/backend/service/user_service.go <<EOF
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
)

func GetUserProfile(userID string) (model.User, error) {
	var user model.User
	result := config.DB.First(&user, "id = ?", userID)
	return user, result.Error
}
EOF

echo "写入 backend/service/post_service.go ..."
cat > chat_app/backend/service/post_service.go <<EOF
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
)

func CreatePost(post *model.Post) error {
	return config.DB.Create(post).Error
}
EOF

echo "写入 backend/service/comment_service.go ..."
cat > chat_app/backend/service/comment_service.go <<EOF
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
)

func CreateComment(comment *model.Comment) error {
	return config.DB.Create(comment).Error
}
EOF

echo "写入 backend/service/chat_service.go ..."
cat > chat_app/backend/service/chat_service.go <<EOF
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
)

func GetChatHistory(userID, friendID string) ([]model.Message, error) {
	var messages []model.Message
	err := config.DB.Where(
		"(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
		userID, friendID, friendID, userID,
	).Order("created_at asc").Find(&messages).Error
	return messages, err
}
EOF

echo "后端 service 文件写入完成。"

echo "写入 frontend/lib/main.dart ..."
cat > chat_app/frontend/lib/main.dart <<EOF
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';

void main() {
  runApp(MyApp());
}
EOF

echo "写入 frontend/lib/app.dart ..."
cat > chat_app/frontend/lib/app.dart <<EOF
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/chat_page.dart';
import 'pages/user_profile_page.dart';
import 'pages/post_detail_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/chat', page: () => ChatPage()),
        GetPage(name: '/user/:id', page: () => UserProfilePage()),
        GetPage(name: '/post/:id', page: () => PostDetailPage()),
      ],
    );
  }
}
EOF

echo "写入 frontend/lib/pages/home_page.dart ..."
cat > chat_app/frontend/lib/pages/home_page.dart <<EOF
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('首页')),
      body: Center(child: Text('欢迎进入聊天首页')),
    );
  }
}
EOF

echo "写入 frontend/lib/controllers/auth_controller.dart ..."
cat > chat_app/frontend/lib/controllers/auth_controller.dart <<EOF
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  void login() {
    isLoggedIn.value = true;
    Get.offAllNamed('/home');
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
EOF

echo "写入 frontend/lib/pages/post_detail_page.dart ..."
cat > chat_app/frontend/lib/pages/post_detail_page.dart <<EOF
import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('动态详情')),
      body: Center(child: Text('这里是动态详情页')),
    );
  }
}
EOF

echo "写入 frontend/lib/pages/user_profile_page.dart ..."
cat > chat_app/frontend/lib/pages/user_profile_page.dart <<EOF
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户资料')),
      body: Center(child: Text('这里是用户资料页')),
    );
  }
}
EOF

echo "写入 frontend/lib/pages/chat_page.dart ..."
cat > chat_app/frontend/lib/pages/chat_page.dart <<EOF
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('聊天')),
      body: Center(child: Text('这里是聊天页面')),
    );
  }
}
EOF

echo "写入 frontend/lib/services/api_service.dart ..."
cat > chat_app/frontend/lib/services/api_service.dart <<EOF
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://localhost:8080/api';

  static Future<http.Response> sendCode(String phone) {
    return http.post(Uri.parse('\$baseUrl/sendCode'), body: {'phone': phone});
  }

  // 其他接口调用示例
}
EOF

echo "写入 frontend/lib/services/ws_service.dart ..."
cat > chat_app/frontend/lib/services/ws_service.dart <<EOF
import 'package:web_socket_channel/web_socket_channel.dart';

class WsService {
  WebSocketChannel? channel;

  void connect(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void disconnect() {
    channel?.sink.close();
  }

  // 监听消息
  Stream get stream => channel!.stream;

  // 发送消息
  void send(String message) {
    channel?.sink.add(message);
  }
}
EOF

echo "写入 frontend/pubspec.yaml ..."
cat > chat_app/frontend/pubspec.yaml <<EOF
name: chat_app
description: A personal therapy and drifting bottle chat app
publish_to: 'none'

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  http: ^0.13.4
  web_socket_channel: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
EOF

echo "写入 backend/model/user.go ..."
cat > chat_app/backend/model/user.go <<EOF
package model

import (
	"time"
)

type User struct {
	ID        string    \`gorm:"primaryKey;type:varchar(36)"\`
	Username  string    \`gorm:"size:100;not null"\`
	Phone     string    \`gorm:"size:20;unique"\`
	CreatedAt time.Time
	UpdatedAt time.Time
}
EOF

echo "写入 backend/middleware/jwt.go ..."
cat > chat_app/backend/middleware/jwt.go <<EOF
package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func JWTAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("Authorization")
		if token == "" || !strings.HasPrefix(token, "Bearer ") {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		// 这里应实现 token 验证逻辑
		// 验证成功继续；失败返回 401

		c.Next()
	}
}
EOF

echo "写入 backend/controller/auth.go ..."
cat > chat_app/backend/controller/auth.go <<EOF
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type LoginRequest struct {
	Phone string \`json:"phone"\`
	Code  string \`json:"code"\`
}

func SendCodeHandler(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil || req.Phone == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid phone"})
		return
	}

	err := service.SendSmsCode(req.Phone)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send code"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Code sent"})
}

func LoginHandler(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil || req.Phone == "" || req.Code == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid params"})
		return
	}

	token, err := service.VerifyLogin(req.Phone, req.Code)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Login failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}
EOF

echo "写入 backend/service/auth_service.go ..."
cat > chat_app/backend/service/auth_service.go <<EOF
package service

import (
	"errors"
	"time"

	"chat_app/backend/config"
	"chat_app/backend/model"
	"github.com/google/uuid"
)

var codeCache = make(map[string]string) // 简单缓存，生产请用 Redis

func SendSmsCode(phone string) error {
	code := "123456" // 模拟，生产接入短信 SDK
	codeCache[phone] = code
	go func() {
		time.Sleep(5 * time.Minute)
		delete(codeCache, phone)
	}()
	return nil
}

func VerifyLogin(phone, code string) (string, error) {
	if c, ok := codeCache[phone]; !ok || c != code {
		return "", errors.New("invalid code")
	}
	// 查询用户或创建新用户
	var user model.User
	res := config.DB.First(&user, "phone = ?", phone)
	if res.Error != nil {
		user = model.User{ID: uuid.NewString(), Phone: phone, Username: "用户" + phone[len(phone)-4:]}
		config.DB.Create(&user)
	}

	// 返回一个模拟 token，生产应使用 JWT
	return "mock-token-for-" + user.ID, nil
}
EOF

echo "写入 deploy.md ..."
cat > chat_app/deploy.md <<EOF
# Chat App 部署文档

## 后端部署

1. 安装 Go 1.18+
2. 配置 PostgreSQL，创建数据库 chat_app
3. 设置环境变量：
   - POSTGRES_DSN="host=localhost user=postgres password=你的密码 dbname=chat_app port=5432 sslmode=disable"
4. 运行后端服务：
   \`\`\`
   cd backend
   go mod tidy
   go run main.go
   \`\`\`

## 前端部署

1. 安装 Flutter SDK 3+
2. 进入前端目录，安装依赖：
   \`\`\`
   cd frontend
   flutter pub get
   \`\`\`
3. 运行项目：
   \`\`\`
   flutter run
   \`\`\`
4. 生成发布包：
   - Android APK：
     \`\`\`
     flutter build apk --release
     \`\`\`
   - iOS：
     使用 Xcode 打开 ios 文件夹，进行打包上传

## 备注

- 请确保后端服务地址正确，Flutter 中的 API 地址需修改为部署服务器地址
- 生产环境建议使用 HTTPS 和安全存储 JWT token
- 短信服务请集成阿里云或腾讯云 SDK 替换模拟代码
EOF

echo "写入 backend/controller/social_auth.go ..."
cat > chat_app/backend/controller/social_auth.go <<EOF
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type SocialLoginRequest struct {
	Provider string \`json:"provider"\` // "wechat" 或 "qq"
	Code     string \`json:"code"\`     // 第三方授权码
}

func SocialLoginHandler(c *gin.Context) {
	var req SocialLoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid params"})
		return
	}

	token, err := service.HandleSocialLogin(req.Provider, req.Code)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Social login failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}
EOF

echo "写入 backend/service/social_auth_service.go ..."
cat > chat_app/backend/service/social_auth_service.go <<EOF
package service

import (
	"errors"
	"fmt"
	"chat_app/backend/config"
	"chat_app/backend/model"
	"github.com/google/uuid"
)

func HandleSocialLogin(provider, code string) (string, error) {
	// 这里模拟调用微信/QQ官方接口获取用户openid等信息
	openid := provider + "-openid-" + code

	// 查找用户
	var user model.User
	res := config.DB.First(&user, "username = ?", openid)
	if res.Error != nil {
		user = model.User{
			ID:       uuid.NewString(),
			Username: openid,
		}
		err := config.DB.Create(&user).Error
		if err != nil {
			return "", errors.New("user create failed")
		}
	}

	// 返回模拟token，生产应生成 JWT
	token := fmt.Sprintf("token-%s-%s", provider, user.ID)
	return token, nil
}
EOF

echo "写入 backend/controller/bottle.go ..."
cat > chat_app/backend/controller/bottle.go <<EOF
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func ThrowBottle(c *gin.Context) {
	var bottle model.Bottle
	if err := c.ShouldBindJSON(&bottle); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid params"})
		return
	}
	err := service.ThrowBottle(&bottle)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Throw bottle failed"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Bottle thrown"})
}

func PickBottle(c *gin.Context) {
	bottle, err := service.PickRandomBottle()
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "No bottle found"})
		return
	}
	c.JSON(http.StatusOK, bottle)
}
EOF

echo "写入 backend/service/bottle_service.go ..."
cat > chat_app/backend/service/bottle_service.go <<EOF
package service

import (
	"errors"
	"chat_app/backend/config"
	"chat_app/backend/model"
	"math/rand"
	"time"
)

func ThrowBottle(bottle *model.Bottle) error {
	return config.DB.Create(bottle).Error
}

func PickRandomBottle() (*model.Bottle, error) {
	var count int64
	config.DB.Model(&model.Bottle{}).Count(&count)
	if count == 0 {
		return nil, errors.New("no bottles")
	}
	offset := rand.Intn(int(count))
	var bottle model.Bottle
	err := config.DB.Offset(offset).Limit(1).Find(&bottle).Error
	return &bottle, err
}
EOF

echo "写入 backend/controller/private_chat.go ..."
cat > chat_app/backend/controller/private_chat.go <<EOF
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func SendPrivateMessage(c *gin.Context) {
	var msg model.Message
	if err := c.ShouldBindJSON(&msg); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid params"})
		return
	}
	err := service.SendMessage(&msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Send message failed"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Message sent"})
}

func GetPrivateMessages(c *gin.Context) {
	userID := c.Query("userId")
	friendID := c.Query("friendId")
	messages, err := service.GetChatHistory(userID, friendID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Get messages failed"})
		return
	}
	c.JSON(http.StatusOK, messages)
}
EOF
# --- social_auth.go 控制器 ---
cat > chat_app/backend/controller/social_auth.go <<'EOF'
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type SocialLoginRequest struct {
	Provider string `json:"provider"` // "wechat"或"qq"
	Code     string `json:"code"`
}

func SocialLoginHandler(c *gin.Context) {
	var req SocialLoginRequest
	if err := c.ShouldBindJSON(&req); err != nil || (req.Provider != "wechat" && req.Provider != "qq") {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid params"})
		return
	}

	token, err := service.HandleSocialLogin(req.Provider, req.Code)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Social login failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}
EOF

# --- social_auth_service.go 服务层 ---
cat > chat_app/backend/service/social_auth_service.go <<'EOF'
package service

import (
	"errors"
	"fmt"
	"chat_app/backend/config"
	"chat_app/backend/model"
	"github.com/google/uuid"
)

func HandleSocialLogin(provider, code string) (string, error) {
	// TODO: 调用微信/QQ官方接口换取openid，这里模拟
	openid := provider + "-openid-" + code

	var user model.User
	res := config.DB.First(&user, "provider = ? AND provider_id = ?", provider, openid)
	if res.Error != nil {
		user = model.User{
			ID:         uuid.NewString(),
			Username:   fmt.Sprintf("%s_user_%s", provider, openid[len(openid)-6:]),
			Provider:   provider,
			ProviderID: openid,
		}
		err := config.DB.Create(&user).Error
		if err != nil {
			return "", errors.New("failed to create user")
		}
	}

	token := fmt.Sprintf("jwt-token-for-%s", user.ID) // 生产应生成JWT
	return token, nil
}
EOF

# --- 修改 model/user.go 增加第三方登录字段 ---
cat > chat_app/backend/model/user.go <<'EOF'
package model

import (
	"time"
)

type User struct {
	ID         string    `gorm:"primaryKey;type:varchar(36)"`
	Username   string    `gorm:"size:100;not null"`
	Phone      string    `gorm:"size:20;unique"`
	Provider   string    `gorm:"size:20"`
	ProviderID string    `gorm:"size:100;unique"`
	CreatedAt  time.Time
	UpdatedAt  time.Time
}
EOF

# --- Flutter 社交登录控制器 social_auth_controller.dart ---
cat > chat_app/frontend/lib/controllers/social_auth_controller.dart <<'EOF'
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SocialAuthController extends GetxController {
  Future<void> loginWithProvider(String provider, String code) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/socialLogin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'provider': provider, 'code': code}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      // TODO: 保存token，本地存储或状态管理
      print('Login success, token: $token');
    } else {
      print('Login failed');
    }
  }
}
EOF

# --- Flutter 登录页面 social_login_page.dart 示例 ---
cat > chat_app/frontend/lib/pages/social_login_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/social_auth_controller.dart';

class SocialLoginPage extends StatelessWidget {
  final SocialAuthController controller = Get.put(SocialAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('社交登录')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // TODO: 微信sdk获取code流程
                String code = 'mock_wechat_code';
                await controller.loginWithProvider('wechat', code);
              },
              child: Text('微信登录'),
            ),
            ElevatedButton(
              onPressed: () async {
                // TODO: QQ sdk获取code流程
                String code = 'mock_qq_code';
                await controller.loginWithProvider('qq', code);
              },
              child: Text('QQ登录'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# --- 后端 model/bottle.go ---
mkdir -p chat_app/backend/model
cat > chat_app/backend/model/bottle.go <<'EOF'
package model

import (
	"time"
)

type Bottle struct {
	ID        string    `gorm:"primaryKey;type:varchar(36)"`
	Content   string    `gorm:"type:text;not null"`
	UserID    string    `gorm:"size:36;index"`
	CreatedAt time.Time
}
EOF

# --- 后端 controller/bottle.go ---
mkdir -p chat_app/backend/controller
cat > chat_app/backend/controller/bottle.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func ThrowBottle(c *gin.Context) {
	var bottle model.Bottle
	if err := c.ShouldBindJSON(&bottle); err != nil || bottle.Content == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid bottle content"})
		return
	}

	err := service.ThrowBottle(&bottle)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to throw bottle"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Bottle thrown successfully"})
}

func PickBottle(c *gin.Context) {
	bottle, err := service.PickRandomBottle()
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "No bottles found"})
		return
	}

	c.JSON(http.StatusOK, bottle)
}
EOF

# --- 后端 service/bottle_service.go ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/bottle_service.go <<'EOF'
package service

import (
	"errors"
	"chat_app/backend/config"
	"chat_app/backend/model"
	"math/rand"
	"time"
)

func ThrowBottle(bottle *model.Bottle) error {
	bottle.ID = generateUUID()
	bottle.CreatedAt = time.Now()
	return config.DB.Create(bottle).Error
}

func PickRandomBottle() (*model.Bottle, error) {
	var count int64
	config.DB.Model(&model.Bottle{}).Count(&count)
	if count == 0 {
		return nil, errors.New("no bottles available")
	}
	offset := rand.Intn(int(count))
	var bottle model.Bottle
	err := config.DB.Offset(offset).Limit(1).Find(&bottle).Error
	return &bottle, err
}

// 简易 UUID 生成，建议用 github.com/google/uuid
func generateUUID() string {
	return fmt.Sprintf("%d", time.Now().UnixNano())
}
EOF

# --- Flutter 前端 pages/bottle_page.dart ---
mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/bottle_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BottlePage extends StatefulWidget {
  @override
  _BottlePageState createState() => _BottlePageState();
}

class _BottlePageState extends State<BottlePage> {
  String? pickedContent;

  Future<void> throwBottle(String content) async {
    final res = await http.post(
      Uri.parse('http://localhost:8080/api/bottle/throw'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': content}),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("瓶子投掷成功")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("投掷失败")));
    }
  }

  Future<void> pickBottle() async {
    final res = await http.get(Uri.parse('http://localhost:8080/api/bottle/pick'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        pickedContent = data['content'];
      });
    } else {
      setState(() {
        pickedContent = "没有找到瓶子";
      });
    }
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("漂流瓶")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (pickedContent != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text("捞到的瓶子内容：$pickedContent"),
              ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "输入漂流瓶内容",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => throwBottle(_controller.text),
              child: Text("投瓶子"),
            ),
            ElevatedButton(
              onPressed: pickBottle,
              child: Text("捞瓶子"),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# --- 后端 model/message.go ---
mkdir -p chat_app/backend/model
cat > chat_app/backend/model/message.go <<'EOF'
package model

import (
	"time"
)

type Message struct {
	ID         string    `gorm:"primaryKey;type:varchar(36)"`
	FromUserID string    `gorm:"size:36;index;not null"`
	ToUserID   string    `gorm:"size:36;index;not null"`
	Content    string    `gorm:"type:text;not null"`
	CreatedAt  time.Time
}
EOF

# --- 后端 controller/private_chat.go ---
mkdir -p chat_app/backend/controller
cat > chat_app/backend/controller/private_chat.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func SendPrivateMessage(c *gin.Context) {
	var msg model.Message
	if err := c.ShouldBindJSON(&msg); err != nil || msg.Content == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid message"})
		return
	}

	err := service.SendMessage(&msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send message"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Message sent"})
}

func GetPrivateMessages(c *gin.Context) {
	fromUserID := c.Query("fromUserId")
	toUserID := c.Query("toUserId")
	if fromUserID == "" || toUserID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Missing user IDs"})
		return
	}

	msgs, err := service.GetChatHistory(fromUserID, toUserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get messages"})
		return
	}

	c.JSON(http.StatusOK, msgs)
}
EOF

# --- 后端 service/chat_service.go ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/chat_service.go <<'EOF'
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
	"fmt"
	"time"
)

func SendMessage(msg *model.Message) error {
	msg.ID = generateUUID()
	msg.CreatedAt = time.Now()
	return config.DB.Create(msg).Error
}

func GetChatHistory(user1, user2 string) ([]model.Message, error) {
	var msgs []model.Message
	err := config.DB.Where(
		"(from_user_id = ? AND to_user_id = ?) OR (from_user_id = ? AND to_user_id = ?)",
		user1, user2, user2, user1,
	).Order("created_at ASC").Find(&msgs).Error
	return msgs, err
}

func generateUUID() string {
	return fmt.Sprintf("%d", time.Now().UnixNano())
}
EOF

# --- Flutter 前端 lib/pages/chat_page.dart ---
mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/chat_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String fromUserId;
  final String toUserId;
  ChatPage({required this.fromUserId, required this.toUserId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> fetchMessages() async {
    final res = await http.get(Uri.parse(
        'http://localhost:8080/api/chat/history?fromUserId=${widget.fromUserId}&toUserId=${widget.toUserId}'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      setState(() {
        messages = data.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  Future<void> sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final res = await http.post(
      Uri.parse('http://localhost:8080/api/chat/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fromUserID': widget.fromUserId,
        'toUserID': widget.toUserId,
        'content': content,
      }),
    );

    if (res.statusCode == 200) {
      _controller.clear();
      await fetchMessages();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('私信聊天'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                bool isMe = msg['from_user_id'] == widget.fromUserId;
                return ListTile(
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg['content']),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "输入消息"),
                )),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
EOF


# --- 后端 utils/sensitive.go ---
mkdir -p chat_app/backend/utils
cat > chat_app/backend/utils/sensitive.go <<'EOF'
package utils

import (
	"strings"
)

var sensitiveWords = []string{
	"badword1",
	"badword2",
	"涉政词1",
	"涉政词2",
}

// CheckSensitive 检查文本是否包含敏感词
func CheckSensitive(text string) bool {
	lowerText := strings.ToLower(text)
	for _, word := range sensitiveWords {
		if strings.Contains(lowerText, strings.ToLower(word)) {
			return true
		}
	}
	return false
}
EOF

# --- 后端 service/filter_service.go ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/filter_service.go <<'EOF'
package service

import (
	"chat_app/backend/utils"
	"errors"
)

func FilterContent(content string) error {
	if utils.CheckSensitive(content) {
		return errors.New("content contains sensitive words")
	}
	return nil
}
EOF

# --- 修改漂流瓶投掷接口，加入敏感词过滤 ---
cat > chat_app/backend/controller/bottle.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func ThrowBottle(c *gin.Context) {
	var bottle model.Bottle
	if err := c.ShouldBindJSON(&bottle); err != nil || bottle.Content == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid bottle content"})
		return
	}

	if err := service.FilterContent(bottle.Content); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Content contains sensitive words"})
		return
	}

	err := service.ThrowBottle(&bottle)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to throw bottle"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Bottle thrown successfully"})
}
EOF

# --- 修改私信发送接口，加入敏感词过滤 ---
cat > chat_app/backend/controller/private_chat.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func SendPrivateMessage(c *gin.Context) {
	var msg model.Message
	if err := c.ShouldBindJSON(&msg); err != nil || msg.Content == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid message"})
		return
	}

	if err := service.FilterContent(msg.Content); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Message contains sensitive words"})
		return
	}

	err := service.SendMessage(&msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send message"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Message sent"})
}
EOF

# --- Flutter 演示前端：发送内容时简单敏感词检测提示（可选）---
mkdir -p chat_app/frontend/lib/utils
cat > chat_app/frontend/lib/utils/sensitive_checker.dart <<'EOF'
class SensitiveChecker {
  static List<String> sensitiveWords = [
    "badword1",
    "badword2",
    "涉政词1",
    "涉政词2",
  ];

  static bool hasSensitiveWord(String text) {
    final lowerText = text.toLowerCase();
    return sensitiveWords.any((word) => lowerText.contains(word.toLowerCase()));
  }
}
EOF

# --- Flutter 私信发送按钮示例（集成敏感词检测） ---
cat > chat_app/frontend/lib/pages/chat_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/sensitive_checker.dart';

class ChatPage extends StatefulWidget {
  final String fromUserId;
  final String toUserId;
  ChatPage({required this.fromUserId, required this.toUserId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> fetchMessages() async {
    final res = await http.get(Uri.parse(
        'http://localhost:8080/api/chat/history?fromUserId=${widget.fromUserId}&toUserId=${widget.toUserId}'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      setState(() {
        messages = data.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  Future<void> sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    if (SensitiveChecker.hasSensitiveWord(content)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("消息包含敏感词，请修改后发送")));
      return;
    }

    final res = await http.post(
      Uri.parse('http://localhost:8080/api/chat/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fromUserID': widget.fromUserId,
        'toUserID': widget.toUserId,
        'content': content,
      }),
    );

    if (res.statusCode == 200) {
      _controller.clear();
      await fetchMessages();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("发送失败，请重试")));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('私信聊天'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                bool isMe = msg['from_user_id'] == widget.fromUserId;
                return ListTile(
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg['content']),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "输入消息"),
                )),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
EOF

# --- 后端 service/image_audit_service.go ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/image_audit_service.go <<'EOF'
package service

import (
	"errors"
	"fmt"
	"net/http"
	"bytes"
	"io/ioutil"
)

// 模拟调用第三方图片内容安全审核接口，示例使用伪代码
func AuditImageContent(imageURL string) error {
	// 这里可集成腾讯云、阿里云等图片内容审核API
	// 简单模拟：URL包含"banned"则判定不通过
	if len(imageURL) == 0 {
		return errors.New("empty image url")
	}
	if containsBannedWord(imageURL) {
		return errors.New("image content violation detected")
	}

	// TODO: 真正调用云服务API并解析结果

	return nil
}

func containsBannedWord(url string) bool {
	return bytes.Contains([]byte(url), []byte("banned"))
}
EOF

# --- 后端 controller/image_upload.go ---
mkdir -p chat_app/backend/controller
cat > chat_app/backend/controller/image_upload.go <<'EOF'
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type ImageUploadRequest struct {
	ImageURL string `json:"image_url" binding:"required"`
}

func ImageUploadHandler(c *gin.Context) {
	var req ImageUploadRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Missing image URL"})
		return
	}

	err := service.AuditImageContent(req.ImageURL)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// 这里模拟返回OSS或CDN的最终访问URL
	c.JSON(http.StatusOK, gin.H{"url": req.ImageURL})
}
EOF

# --- Flutter 图片上传 + 审核示例 upload_image_page.dart ---
mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/upload_image_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final TextEditingController _imageUrlController = TextEditingController();
  String? auditResult;

  Future<void> uploadAndAuditImage() async {
    final imageUrl = _imageUrlController.text.trim();
    if (imageUrl.isEmpty) {
      setState(() {
        auditResult = "请输入图片URL";
      });
      return;
    }

    final res = await http.post(
      Uri.parse('http://localhost:8080/api/image/upload'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image_url': imageUrl}),
    );

    if (res.statusCode == 200) {
      setState(() {
        auditResult = "图片审核通过，上传成功！";
      });
    } else {
      final data = jsonDecode(res.body);
      setState(() {
        auditResult = "审核失败：" + (data['error'] ?? "未知错误");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("图片上传与内容审核")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: "图片URL"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: uploadAndAuditImage,
              child: Text("上传并审核"),
            ),
            SizedBox(height: 20),
            if (auditResult != null)
              Text(
                auditResult!,
                style: TextStyle(
                    color: auditResult!.startsWith("审核失败") ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
EOF

# --- Flutter 漂流瓶列表页 bottle_list_page.dart ---
mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/bottle_list_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BottleListPage extends StatefulWidget {
  @override
  _BottleListPageState createState() => _BottleListPageState();
}

class _BottleListPageState extends State<BottleListPage> {
  List<dynamic> bottles = [];

  Future<void> fetchBottles() async {
    final res = await http.get(Uri.parse('http://localhost:8080/api/bottle/list'));
    if (res.statusCode == 200) {
      setState(() {
        bottles = jsonDecode(res.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBottles();
  }

  void _goToDetail(Map<String, dynamic> bottle) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => BottleDetailPage(bottle: bottle),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('漂流瓶列表')),
      body: ListView.builder(
        itemCount: bottles.length,
        itemBuilder: (context, index) {
          final bottle = bottles[index];
          return ListTile(
            title: Text(bottle['content'] ?? ''),
            subtitle: Text('投掷时间: ${bottle['created_at'] ?? ''}'),
            onTap: () => _goToDetail(bottle),
          );
        },
      ),
    );
  }
}

class BottleDetailPage extends StatelessWidget {
  final Map<String, dynamic> bottle;
  BottleDetailPage({required this.bottle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('瓶子详情')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(bottle['content'] ?? ''),
      ),
    );
  }
}
EOF

# --- 后端 controller/bottle.go 增加列出接口 ---
cat > chat_app/backend/controller/bottle.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func ThrowBottle(c *gin.Context) {
	var bottle model.Bottle
	if err := c.ShouldBindJSON(&bottle); err != nil || bottle.Content == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid bottle content"})
		return
	}

	if err := service.FilterContent(bottle.Content); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Content contains sensitive words"})
		return
	}

	err := service.ThrowBottle(&bottle)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to throw bottle"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Bottle thrown successfully"})
}

func PickBottle(c *gin.Context) {
	bottle, err := service.PickRandomBottle()
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "No bottles found"})
		return
	}

	c.JSON(http.StatusOK, bottle)
}

// 新增列出所有漂流瓶接口（分页或全部）
func ListBottles(c *gin.Context) {
	bottles, err := service.ListAllBottles()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get bottles"})
		return
	}
	c.JSON(http.StatusOK, bottles)
}
EOF

# --- 后端 service/bottle_service.go 增加列出逻辑 ---
cat > chat_app/backend/service/bottle_service.go <<'EOF'
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
	"errors"
	"math/rand"
	"time"
)

func ThrowBottle(bottle *model.Bottle) error {
	bottle.ID = generateUUID()
	bottle.CreatedAt = time.Now()
	return config.DB.Create(bottle).Error
}

func PickRandomBottle() (*model.Bottle, error) {
	var count int64
	config.DB.Model(&model.Bottle{}).Count(&count)
	if count == 0 {
		return nil, errors.New("no bottles available")
	}
	offset := rand.Intn(int(count))
	var bottle model.Bottle
	err := config.DB.Offset(offset).Limit(1).Find(&bottle).Error
	return &bottle, err
}

func ListAllBottles() ([]model.Bottle, error) {
	var bottles []model.Bottle
	err := config.DB.Order("created_at desc").Find(&bottles).Error
	return bottles, err
}

func generateUUID() string {
	return fmt.Sprintf("%d", time.Now().UnixNano())
}
EOF

# --- Flutter 评论弹窗 comment_dialog.dart ---
mkdir -p chat_app/frontend/lib/widgets
cat > chat_app/frontend/lib/widgets/comment_dialog.dart <<'EOF'
import 'package:flutter/material.dart';

typedef OnCommentSubmitted = void Function(String comment);

class CommentDialog extends StatefulWidget {
  final OnCommentSubmitted onSubmitted;

  CommentDialog({required this.onSubmitted});

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted(text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('发表评论'),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: '请输入评论内容',
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('取消')),
        ElevatedButton(onPressed: _submit, child: Text('发送')),
      ],
    );
  }
}
EOF

# --- Flutter 动态列表页面增加点赞、评论按钮示例 (post_list_page.dart 片段) ---
cat >> chat_app/frontend/lib/pages/post_list_page.dart <<'EOF'

// 引入评论弹窗
import '../widgets/comment_dialog.dart';

// 示例点赞接口调用
Future<void> likePost(String postId) async {
  final res = await http.post(
    Uri.parse('http://localhost:8080/api/post/like'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'post_id': postId}),
  );
  if (res.statusCode == 200) {
    // 刷新状态或提示
  }
}

// 显示评论弹窗
void _showCommentDialog(BuildContext context, String postId) {
  showDialog(
    context: context,
    builder: (context) => CommentDialog(
      onSubmitted: (comment) async {
        final res = await http.post(
          Uri.parse('http://localhost:8080/api/post/comment'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'post_id': postId, 'content': comment}),
        );
        if (res.statusCode == 200) {
          // 发表评论成功，刷新评论列表等
        }
      },
    ),
  );
}

// 在动态列表 item 里使用点赞、评论按钮示例
// Widget buildPostItem(Map<String, dynamic> post) {
//   return ListTile(
//     title: Text(post['content']),
//     trailing: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: Icon(Icons.thumb_up),
//           onPressed: () => likePost(post['id']),
//         ),
//         IconButton(
//           icon: Icon(Icons.comment),
//           onPressed: () => _showCommentDialog(context, post['id']),
//         ),
//       ],
//     ),
//   );
// }
EOF

# --- 后端 controller/post.go 新增点赞与评论接口 ---
cat > chat_app/backend/controller/post.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type LikeRequest struct {
	PostID string `json:"post_id" binding:"required"`
}

type CommentRequest struct {
	PostID  string `json:"post_id" binding:"required"`
	Content string `json:"content" binding:"required"`
}

func LikePost(c *gin.Context) {
	var req LikeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}
	err := service.LikePost(req.PostID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to like post"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Post liked"})
}

func CommentPost(c *gin.Context) {
	var req CommentRequest
	if err := c.ShouldBindJSON(&req); err != nil || req.Content == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid comment"})
		return
	}
	err := service.CommentPost(req.PostID, req.Content)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to comment"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Comment added"})
}
EOF

# --- 后端 service/post_service.go 新增点赞、评论逻辑 ---
cat > chat_app/backend/service/post_service.go <<'EOF'
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
	"errors"
	"time"
)

func LikePost(postID string) error {
	// 简单模拟，增加点赞数
	var post model.Post
	if err := config.DB.First(&post, "id = ?", postID).Error; err != nil {
		return errors.New("post not found")
	}
	post.LikeCount++
	return config.DB.Save(&post).Error
}

func CommentPost(postID, content string) error {
	comment := model.Comment{
		ID:        generateUUID(),
		PostID:    postID,
		Content:   content,
		CreatedAt: time.Now(),
	}
	return config.DB.Create(&comment).Error
}
EOF


# --- Flutter 表情选择器组件 emoji_picker.dart ---
mkdir -p chat_app/frontend/lib/widgets
cat > chat_app/frontend/lib/widgets/emoji_picker.dart <<'EOF'
import 'package:flutter/material.dart';

typedef OnEmojiSelected = void Function(String emoji);

class EmojiPicker extends StatelessWidget {
  final OnEmojiSelected onEmojiSelected;
  final List<String> emojis = [
    "😀", "😂", "😍", "😭", "😡", "👍", "🙏", "🎉", "💔", "🔥",
    "😎", "😴", "🤔", "🙌", "🎂", "🌟", "🐶", "🍀", "⚡", "💯"
  ];

  EmojiPicker({required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount: emojis.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, crossAxisSpacing: 4, mainAxisSpacing: 4),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onEmojiSelected(emojis[index]),
          child: Center(child: Text(emojis[index], style: TextStyle(fontSize: 24))),
        );
      },
    );
  }
}
EOF

# --- Flutter 聊天页面 chat_page.dart 片段，集成表情选择与图片发送 ---
cat >> chat_app/frontend/lib/pages/chat_page.dart <<'EOF'
import '../widgets/emoji_picker.dart';
import 'package:image_picker/image_picker.dart'; // 需添加image_picker依赖
import 'dart:io';

// 在聊天页 State 增加变量和方法

bool _showEmojiPicker = false;
final TextEditingController _msgController = TextEditingController();

void _onEmojiSelected(String emoji) {
  _msgController.text += emoji;
}

Future<void> _pickAndSendImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    File file = File(pickedFile.path);
    // 上传图片并获取URL
    final imageUrl = await uploadImageToServer(file);
    if (imageUrl != null) {
      sendMessage(content: "[图片]", imageUrl: imageUrl);
    }
  }
}

Future<String?> uploadImageToServer(File file) async {
  // 这里调用后端图片上传接口，示例简化，需自己实现文件上传
  // 返回图片URL字符串
  return "https://your.cdn.com/path/to/uploaded/image.jpg";
}

void sendMessage({required String content, String? imageUrl}) async {
  // 发送消息接口调用
  final msg = {
    "fromUserID": widget.fromUserId,
    "toUserID": widget.toUserId,
    "content": content,
    "image_url": imageUrl ?? "",
  };
  // POST调用省略，参考之前sendMessage示例
}
EOF

# --- 后端 model/message.go 新增图片URL字段 ---
cat > chat_app/backend/model/message.go <<'EOF'
package model

import "time"

type Message struct {
	ID         string    `gorm:"primaryKey" json:"id"`
	FromUserID string    `json:"from_user_id"`
	ToUserID   string    `json:"to_user_id"`
	Content    string    `json:"content"`
	ImageURL   string    `json:"image_url,omitempty"` // 新增图片字段
	CreatedAt  time.Time `json:"created_at"`
}
EOF

# --- 后端 controller/chat.go 修改发送消息接口支持图片URL ---
cat > chat_app/backend/controller/chat.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type SendMessageRequest struct {
	FromUserID string `json:"fromUserID" binding:"required"`
	ToUserID   string `json:"toUserID" binding:"required"`
	Content    string `json:"content"`
	ImageURL   string `json:"image_url"`
}

func SendMessage(c *gin.Context) {
	var req SendMessageRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid message request"})
		return
	}
	// 敏感词过滤
	if err := service.FilterContent(req.Content); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Message contains sensitive words"})
		return
	}
	msg := model.Message{
		ID:         generateUUID(),
		FromUserID: req.FromUserID,
		ToUserID:   req.ToUserID,
		Content:    req.Content,
		ImageURL:   req.ImageURL,
		CreatedAt:  time.Now(),
	}
	err := service.SendMessage(&msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send message"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Message sent"})
}
EOF

# --- 后端 service/chat_service.go 增加处理图片消息 ---
cat > chat_app/backend/service/chat_service.go <<'EOF'
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
)

func SendMessage(msg *model.Message) error {
	return config.DB.Create(msg).Error
}
EOF

# --- Flutter 用户资料页 user_profile_page.dart ---
mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/user_profile_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  final String userId;
  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  bool isFollowing = false;

  Future<void> fetchUserData() async {
    final res = await http.get(Uri.parse('http://localhost:8080/api/user/profile/${widget.userId}'));
    if (res.statusCode == 200) {
      setState(() {
        userData = jsonDecode(res.body);
        isFollowing = userData?['is_following'] ?? false;
      });
    }
  }

  Future<void> toggleFollow() async {
    final url = isFollowing
        ? 'http://localhost:8080/api/user/unfollow'
        : 'http://localhost:8080/api/user/follow';
    final res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'target_user_id': widget.userId}));
    if (res.statusCode == 200) {
      setState(() {
        isFollowing = !isFollowing;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('用户资料')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(userData?['nickname'] ?? '用户资料')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userData?['avatar_url'] ?? ''),
            ),
            SizedBox(height: 10),
            Text(userData?['nickname'] ?? '', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: toggleFollow,
              child: Text(isFollowing ? '取消关注' : '关注'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: (userData?['posts'] ?? []).length,
                itemBuilder: (context, index) {
                  final post = userData?['posts'][index];
                  return ListTile(
                    title: Text(post['content']),
                    subtitle: Text(post['created_at']),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
EOF

# --- 后端 controller/user.go 增加关注相关接口 ---
cat > chat_app/backend/controller/user.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UserProfile(c *gin.Context) {
	userId := c.Param("userID")
	user, posts, isFollowing, err := service.GetUserProfile(userId)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"id":           user.ID,
		"nickname":     user.Nickname,
		"avatar_url":   user.AvatarURL,
		"posts":        posts,
		"is_following": isFollowing,
	})
}

type FollowRequest struct {
	TargetUserID string `json:"target_user_id" binding:"required"`
}

func FollowUser(c *gin.Context) {
	var req FollowRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}
	err := service.FollowUser(req.TargetUserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to follow user"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Followed successfully"})
}

func UnfollowUser(c *gin.Context) {
	var req FollowRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}
	err := service.UnfollowUser(req.TargetUserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to unfollow user"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Unfollowed successfully"})
}
EOF

# --- 后端 service/user_service.go 增加关注逻辑 ---
cat > chat_app/backend/service/user_service.go <<'EOF'
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
	"errors"
)

func GetUserProfile(userID string) (model.User, []model.Post, bool, error) {
	var user model.User
	err := config.DB.First(&user, "id = ?", userID).Error
	if err != nil {
		return user, nil, false, err
	}
	var posts []model.Post
	config.DB.Where("user_id = ?", userID).Order("created_at desc").Find(&posts)

	// 模拟判断当前用户是否关注（可根据实际登录用户ID改造）
	isFollowing := false // TODO: 真实判断

	return user, posts, isFollowing, nil
}

func FollowUser(targetUserID string) error {
	// 模拟关注逻辑
	return nil
}

func UnfollowUser(targetUserID string) error {
	// 模拟取消关注逻辑
	return nil
}
EOF

# --- 数据库模型：新增关注关系表 model/follow.go ---
mkdir -p chat_app/backend/model
cat > chat_app/backend/model/follow.go <<'EOF'
package model

type Follow struct {
	ID         string `gorm:"primaryKey"`
	UserID     string `gorm:"index"` // 关注者
	TargetID   string `gorm:"index"` // 被关注者
}
EOF

# --- 后端 service/user_service.go 更新关注逻辑，结合登录用户ID ---
cat > chat_app/backend/service/user_service.go <<'EOF'
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
	"errors"
	"context"
)

func GetUserProfileWithContext(ctx context.Context, userID string) (model.User, []model.Post, bool, error) {
	var user model.User
	err := config.DB.First(&user, "id = ?", userID).Error
	if err != nil {
		return user, nil, false, err
	}
	var posts []model.Post
	config.DB.Where("user_id = ?", userID).Order("created_at desc").Find(&posts)

	// 获取当前登录用户ID（假设从ctx获取）
	loginUserID, ok := ctx.Value("userID").(string)
	if !ok || loginUserID == "" {
		return user, posts, false, nil
	}

	var count int64
	config.DB.Model(&model.Follow{}).Where("user_id = ? AND target_id = ?", loginUserID, userID).Count(&count)
	isFollowing := count > 0

	return user, posts, isFollowing, nil
}

func FollowUserWithContext(ctx context.Context, targetUserID string) error {
	loginUserID, ok := ctx.Value("userID").(string)
	if !ok || loginUserID == "" {
		return errors.New("unauthorized")
	}
	if loginUserID == targetUserID {
		return errors.New("cannot follow yourself")
	}
	// 判断是否已关注
	var count int64
	config.DB.Model(&model.Follow{}).Where("user_id = ? AND target_id = ?", loginUserID, targetUserID).Count(&count)
	if count > 0 {
		return nil // 已关注无需重复添加
	}
	follow := model.Follow{
		ID:       generateUUID(),
		UserID:   loginUserID,
		TargetID: targetUserID,
	}
	return config.DB.Create(&follow).Error
}

func UnfollowUserWithContext(ctx context.Context, targetUserID string) error {
	loginUserID, ok := ctx.Value("userID").(string)
	if !ok || loginUserID == "" {
		return errors.New("unauthorized")
	}
	return config.DB.Where("user_id = ? AND target_id = ?", loginUserID, targetUserID).Delete(&model.Follow{}).Error
}
EOF

# --- 后端 controller/user.go 修改调用带 Context 版本，传入 Gin Context ---
cat > chat_app/backend/controller/user.go <<'EOF'
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UserProfile(c *gin.Context) {
	userId := c.Param("userID")
	user, posts, isFollowing, err := service.GetUserProfileWithContext(c.Request.Context(), userId)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"id":           user.ID,
		"nickname":     user.Nickname,
		"avatar_url":   user.AvatarURL,
		"posts":        posts,
		"is_following": isFollowing,
	})
}

func FollowUser(c *gin.Context) {
	var req struct {
		TargetUserID string `json:"target_user_id" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}
	err := service.FollowUserWithContext(c.Request.Context(), req.TargetUserID)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Followed successfully"})
}

func UnfollowUser(c *gin.Context) {
	var req struct {
		TargetUserID string `json:"target_user_id" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}
	err := service.UnfollowUserWithContext(c.Request.Context(), req.TargetUserID)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Unfollowed successfully"})
}
# --- 说明：JWT 中间件需将 userID 注入 Context，保证以上能正常获取 ---
// 你之前已有 JWT 中间件 jwt.go，确保如下：
// func JWTMiddleware() gin.HandlerFunc {
//   return func(c *gin.Context) {
//     // 验证 token ...
//     userID := 从 token 中提取
//     c.Request = c.Request.WithContext(context.WithValue(c.Request.Context(), "userID", userID))
//     c.Next()
//   }
// }
EOF



# --- 后端 service/filter_service.go 实现敏感词过滤 ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/filter_service.go <<'EOF'
package service

import (
	"errors"
	"strings"
)

// 示例敏感词库
var sensitiveWords = []string{"坏词1", "坏词2", "敏感词"}

// FilterContent 检查内容是否包含敏感词，返回错误表示包含
func FilterContent(content string) error {
	for _, w := range sensitiveWords {
		if strings.Contains(content, w) {
			return errors.New("content contains sensitive words")
		}
	}
	return nil
}



EOF
# --- 后端 controller/post.go 集成敏感词过滤（动态发布时调用） ---
# --  在发布动态或评论接口处调用 service.FilterContent(content) 进行内容校验，类似之前聊天消息示例。

# --- 后端 controller/upload.go 新增图片上传接口（调用腾讯云内容安全示例） ---
cat > chat_app/backend/controller/upload.go <<'EOF'
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UploadImage(c *gin.Context) {
	file, err := c.FormFile("image")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "No image file"})
		return
	}
	// 调用业务层上传与内容审核
	url, err := service.UploadAndCheckImage(c, file)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"url": url})
}
EOF

# --- 后端 service/upload_service.go 实现图片上传与内容审核 ---
cat > chat_app/backend/service/upload_service.go <<'EOF'
package service

import (
	"chat_app/backend/config"
	"context"
	"fmt"
	"mime/multipart"
	"time"

	"github.com/gin-gonic/gin"
)

// UploadAndCheckImage 上传图片并调用腾讯云内容安全接口审核，成功返回图片URL
func UploadAndCheckImage(c *gin.Context, file *multipart.FileHeader) (string, error) {
	// 1. 上传到 OSS（示例）
	url, err := UploadToOSS(file)
	if err != nil {
		return "", err
	}

	// 2. 调用腾讯云内容安全 API 审核图片
	pass, err := CheckImageContent(url)
	if err != nil {
		return "", err
	}
	if !pass {
		return "", fmt.Errorf("image content not allowed")
	}

	return url, nil
}

// UploadToOSS 模拟上传到 OSS，实际要用阿里云SDK
func UploadToOSS(file *multipart.FileHeader) (string, error) {
	// TODO: 这里实现阿里云 OSS 上传逻辑
	// 返回上传后的图片访问 URL
	// 暂时模拟：
	return "https://your-oss-cdn.com/" + file.Filename, nil
}

// CheckImageContent 调用腾讯云接口检测图片内容，示例调用
func CheckImageContent(imageURL string) (bool, error) {
	// TODO: 这里调用腾讯云图片内容安全SDK或HTTP接口
	// 模拟总是通过
	time.Sleep(500 * time.Millisecond)
	return true, nil
}
EOF

# --- Flutter 端示例调用图片上传接口 upload_image.dart ---
mkdir -p chat_app/frontend/lib/services
cat > chat_app/frontend/lib/services/upload_image.dart <<'EOF'
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

Future<String?> uploadImage(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://localhost:8080/api/upload/image'),
  );
  request.files.add(await http.MultipartFile.fromPath(
    'image',
    imageFile.path,
    contentType: MediaType('image', 'jpeg'),
  ));

  var response = await request.send();
  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    // 解析返回url
    // 假设 { "url": "http://..." }
    final url = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(respStr)?.group(1);
    return url;
  }
  return null;
}
EOF

# --- 后端 model/bottle.go 漂流瓶数据模型 ---
mkdir -p chat_app/backend/model
cat > chat_app/backend/model/bottle.go <<'EOF'
package model

import "time"

type Bottle struct {
	ID        string    `gorm:"primaryKey" json:"id"`
	UserID    string    `json:"user_id"`    // 扔瓶子人
	Content   string    `json:"content"`    // 瓶子内容
	CreatedAt time.Time `json:"created_at"`
	Likes     int       `json:"likes"`
	Reports   int       `json:"reports"`
}
EOF

# --- 后端 controller/bottle.go 漂流瓶接口 ---
mkdir -p chat_app/backend/controller
cat > chat_app/backend/controller/bottle.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type ThrowBottleRequest struct {
	Content string `json:"content" binding:"required"`
}

func ThrowBottle(c *gin.Context) {
	var req ThrowBottleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Content is required"})
		return
	}

	userID := c.GetString("userID") // 从JWT中获取用户ID

	// 敏感词过滤
	if err := service.FilterContent(req.Content); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Content contains sensitive words"})
		return
	}

	bottle := model.Bottle{
		ID:        generateUUID(),
		UserID:    userID,
		Content:   req.Content,
		CreatedAt: now(),
	}
	if err := service.ThrowBottle(&bottle); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to throw bottle"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Bottle thrown successfully"})
}

func PickBottle(c *gin.Context) {
	bottle, err := service.PickBottle()
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "No bottles available"})
		return
	}
	c.JSON(http.StatusOK, bottle)
}

type LikeBottleRequest struct {
	BottleID string `json:"bottle_id" binding:"required"`
}

func LikeBottle(c *gin.Context) {
	var req LikeBottleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "BottleID required"})
		return
	}
	if err := service.LikeBottle(req.BottleID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to like bottle"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Liked successfully"})
}

type ReportBottleRequest struct {
	BottleID string `json:"bottle_id" binding:"required"`
	Reason   string `json:"reason"`
}

func ReportBottle(c *gin.Context) {
	var req ReportBottleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "BottleID required"})
		return
	}
	if err := service.ReportBottle(req.BottleID, req.Reason); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to report bottle"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Reported successfully"})
}
EOF

# --- 后端 service/bottle_service.go 漂流瓶业务逻辑 ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/bottle_service.go <<'EOF'
package service

import (
	"chat_app/backend/config"
	"chat_app/backend/model"
	"errors"
	"math/rand"
	"time"
)

func ThrowBottle(bottle *model.Bottle) error {
	return config.DB.Create(bottle).Error
}

func PickBottle() (*model.Bottle, error) {
	var bottles []model.Bottle
	err := config.DB.Order("created_at desc").Find(&bottles).Error
	if err != nil || len(bottles) == 0 {
		return nil, errors.New("no bottles")
	}
	// 随机返回一个瓶子
	rand.Seed(time.Now().UnixNano())
	return &bottles[rand.Intn(len(bottles))], nil
}

func LikeBottle(bottleID string) error {
	return config.DB.Model(&model.Bottle{}).
		Where("id = ?", bottleID).
		UpdateColumn("likes", gorm.Expr("likes + ?", 1)).Error
}

func ReportBottle(bottleID string, reason string) error {
	// 这里可以扩展保存举报原因等
	return config.DB.Model(&model.Bottle{}).
		Where("id = ?", bottleID).
		UpdateColumn("reports", gorm.Expr("reports + ?", 1)).Error
}
EOF

# --- Flutter 漂流瓶调用示例 bottle_service.dart ---
mkdir -p chat_app/frontend/lib/services
cat > chat_app/frontend/lib/services/bottle_service.dart <<'EOF'
import 'package:http/http.dart' as http;
import 'dart:convert';

class Bottle {
  String id;
  String userId;
  String content;
  int likes;
  int reports;
  String createdAt;

  Bottle({
    required this.id,
    required this.userId,
    required this.content,
    required this.likes,
    required this.reports,
    required this.createdAt,
  });

  factory Bottle.fromJson(Map<String, dynamic> json) {
    return Bottle(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      likes: json['likes'],
      reports: json['reports'],
      createdAt: json['created_at'],
    );
  }
}

Future<bool> throwBottle(String content) async {
  final res = await http.post(
    Uri.parse('http://localhost:8080/api/bottle/throw'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'content': content}),
  );
  return res.statusCode == 200;
}

Future<Bottle?> pickBottle() async {
  final res = await http.get(Uri.parse('http://localhost:8080/api/bottle/pick'));
  if (res.statusCode == 200) {
    return Bottle.fromJson(jsonDecode(res.body));
  }
  return null;
}

Future<bool> likeBottle(String bottleId) async {
  final res = await http.post(
    Uri.parse('http://localhost:8080/api/bottle/like'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'bottle_id': bottleId}),
  );
  return res.statusCode == 200;
}

Future<bool> reportBottle(String bottleId, String reason) async {
  final res = await http.post(
    Uri.parse('http://localhost:8080/api/bottle/report'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'bottle_id': bottleId, 'reason': reason}),
  );
  return res.statusCode == 200;
}
EOF

# --- Flutter 漂流瓶页面：throw_bottle_page.dart ---
mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/throw_bottle_page.dart <<'EOF'
import 'package:flutter/material.dart';
import '../services/bottle_service.dart';

class ThrowBottlePage extends StatefulWidget {
  @override
  _ThrowBottlePageState createState() => _ThrowBottlePageState();
}

class _ThrowBottlePageState extends State<ThrowBottlePage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  void _submit() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _loading = true);
    bool success = await throwBottle(_controller.text.trim());
    setState(() => _loading = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("瓶子扔出成功！")));
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("扔瓶子失败")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("扔漂流瓶")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "写下你的漂流瓶内容...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading ? CircularProgressIndicator() : Text("扔出瓶子"),
            )
          ],
        ),
      ),
    );
  }
}
EOF

# --- Flutter 漂流瓶页面：pick_bottle_page.dart ---
cat > chat_app/frontend/lib/pages/pick_bottle_page.dart <<'EOF'
import 'package:flutter/material.dart';
import '../services/bottle_service.dart';

class PickBottlePage extends StatefulWidget {
  @override
  _PickBottlePageState createState() => _PickBottlePageState();
}

class _PickBottlePageState extends State<PickBottlePage> {
  Bottle? _bottle;
  bool _loading = false;

  Future<void> _pick() async {
    setState(() => _loading = true);
    Bottle? bottle = await pickBottle();
    setState(() {
      _bottle = bottle;
      _loading = false;
    });
    if (bottle == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("暂时没有瓶子")));
    }
  }

  void _like() async {
    if (_bottle == null) return;
    bool success = await likeBottle(_bottle!.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("点赞成功")));
      setState(() {
        _bottle!.likes += 1;
      });
    }
  }

  void _report() async {
    if (_bottle == null) return;
    bool success = await reportBottle(_bottle!.id, "不当内容");
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("举报成功")));
    }
  }

  @override
  void initState() {
    super.initState();
    _pick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("捡漂流瓶")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _bottle == null
              ? Center(child: Text("没有瓶子"))
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_bottle!.content, style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text("点赞: ${_bottle!.likes}"),
                          SizedBox(width: 20),
                          ElevatedButton(onPressed: _like, child: Text("点赞")),
                          SizedBox(width: 20),
                          ElevatedButton(onPressed: _report, child: Text("举报")),
                        ],
                      )
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pick,
        child: Icon(Icons.refresh),
        tooltip: "再捡一个",
      ),
    );
  }
}
EOF

# --- lib/app.dart 主应用入口，整合扔瓶和捡瓶页面，支持登录校验 ---
mkdir -p chat_app/frontend/lib
cat > chat_app/frontend/lib/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/login_page.dart';
import 'pages/throw_bottle_page.dart';
import 'pages/pick_bottle_page.dart';
import 'controllers/auth_controller.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '漂流瓶App',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => RootPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/throw_bottle', page: () => ThrowBottlePage()),
        GetPage(name: '/pick_bottle', page: () => PickBottlePage()),
      ],
    );
  }
}

class RootPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!authController.isLoggedIn.value) {
        Future.microtask(() => Get.offAllNamed('/login'));
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return MainTabs();
    });
  }
}

class MainTabs extends StatefulWidget {
  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ThrowBottlePage(),
    PickBottlePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('漂流瓶App'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.find<AuthController>().logout();
              Get.offAllNamed('/login');
            },
          )
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.send), label: '扔瓶子'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: '捡瓶子'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
EOF

# --- lib/controllers/auth_controller.dart 登录状态控制器 ---
mkdir -p chat_app/frontend/lib/controllers
cat > chat_app/frontend/lib/controllers/auth_controller.dart <<'EOF'
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  void login() {
    isLoggedIn.value = true;
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
EOF

# --- Flutter集成微信登录示范 flutter_wechat_login.dart ---
mkdir -p chat_app/frontend/lib/services
cat > chat_app/frontend/lib/services/flutter_wechat_login.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_wechat/flutter_wechat.dart'; // 示例假设有此插件

class WeChatLoginService {
  Future<String?> login() async {
    try {
      bool installed = await FlutterWechat.isWeChatInstalled();
      if (!installed) {
        throw Exception("微信未安装");
      }
      final result = await FlutterWechat.auth(scope: 'snsapi_userinfo', state: 'wechat_sdk_demo');
      if (result.code != null) {
        // 这里拿到code，需发送到后端换取token
        return result.code;
      }
      return null;
    } catch (e) {
      debugPrint("微信登录失败: $e");
      return null;
    }
  }
}
EOF

# --- Flutter集成QQ登录示范 flutter_qq_login.dart ---
cat > chat_app/frontend/lib/services/flutter_qq_login.dart <<'EOF'
import 'package:flutter_qq/flutter_qq.dart'; // 假设有此插件
import 'package:flutter/material.dart';

class QQLoginService {
  Future<String?> login() async {
    try {
      bool installed = await FlutterQq.isQQInstalled();
      if (!installed) {
        throw Exception("QQ未安装");
      }
      final result = await FlutterQq.login();
      if (result != null && result.openid != null) {
        // 返回openid或code，用于后端登录验证
        return result.openid;
      }
      return null;
    } catch (e) {
      debugPrint("QQ登录失败: $e");
      return null;
    }
  }
}
EOF

# --- Flutter手机号短信验证码登录示范 sms_login.dart ---
cat > chat_app/frontend/lib/services/sms_login.dart <<'EOF'
import 'package:http/http.dart' as http;
import 'dart:convert';

class SmsLoginService {
  Future<bool> sendCode(String phone) async {
    final res = await http.post(
      Uri.parse('http://localhost:8080/api/send_code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    return res.statusCode == 200;
  }

  Future<bool> loginWithCode(String phone, String code) async {
    final res = await http.post(
      Uri.parse('http://localhost:8080/api/login_sms'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'code': code}),
    );
    return res.statusCode == 200;
  }
}
EOF

# --- 后端 Gin 框架示例：用户认证接口 auth.go ---
mkdir -p chat_app/backend/controller
cat > chat_app/backend/controller/auth.go <<'EOF'
package controller

import (
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type SmsLoginRequest struct {
	Phone string `json:"phone" binding:"required"`
	Code  string `json:"code" binding:"required"`
}

func SendSmsCode(c *gin.Context) {
	phone := c.Query("phone")
	if phone == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "phone required"})
		return
	}
	err := service.SendSmsCode(phone)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to send code"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "code sent"})
}

func LoginSms(c *gin.Context) {
	var req SmsLoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "phone and code required"})
		return
	}
	userID, err := service.VerifySmsCodeAndLogin(req.Phone, req.Code)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid code"})
		return
	}
	token, err := service.GenerateJWT(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate token"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"token": token})
}

type SocialLoginRequest struct {
	Code string `json:"code" binding:"required"`
	Type string `json:"type" binding:"required"` // wechat or qq
}

func SocialLogin(c *gin.Context) {
	var req SocialLoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "code and type required"})
		return
	}
	userID, err := service.VerifySocialCode(req.Code, req.Type)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid social login"})
		return
	}
	token, err := service.GenerateJWT(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate token"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"token": token})
}
EOF

# --- Flutter 登录页面示例，集成微信、QQ、手机号短信登录 ---

mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/login_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/flutter_wechat_login.dart';
import '../services/flutter_qq_login.dart';
import '../services/sms_login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find<AuthController>();
  final WeChatLoginService wechatService = WeChatLoginService();
  final QQLoginService qqService = QQLoginService();
  final SmsLoginService smsService = SmsLoginService();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool sendingCode = false;
  bool loggingIn = false;

  void _wechatLogin() async {
    final code = await wechatService.login();
    if (code != null) {
      // 这里调用后端接口完成登录，略
      authController.login();
      Get.offAllNamed('/');
    } else {
      Get.snackbar('错误', '微信登录失败');
    }
  }

  void _qqLogin() async {
    final openid = await qqService.login();
    if (openid != null) {
      // 调用后端接口登录，略
      authController.login();
      Get.offAllNamed('/');
    } else {
      Get.snackbar('错误', 'QQ登录失败');
    }
  }

  void _sendSmsCode() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;
    setState(() => sendingCode = true);
    final success = await smsService.sendCode(phone);
    setState(() => sendingCode = false);
    Get.snackbar('提示', success ? '验证码已发送' : '发送失败');
  }

  void _smsLogin() async {
    final phone = phoneController.text.trim();
    final code = codeController.text.trim();
    if (phone.isEmpty || code.isEmpty) return;
    setState(() => loggingIn = true);
    final success = await smsService.loginWithCode(phone, code);
    setState(() => loggingIn = false);
    if (success) {
      authController.login();
      Get.offAllNamed('/');
    } else {
      Get.snackbar('错误', '验证码错误或登录失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.chat),
                label: Text('微信登录'),
                onPressed: _wechatLogin,
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                icon: Icon(Icons.chat_bubble),
                label: Text('QQ登录'),
                onPressed: _qqLogin,
              ),
              Divider(),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: '手机号'),
                keyboardType: TextInputType.phone,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeController,
                      decoration: InputDecoration(labelText: '验证码'),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: sendingCode ? null : _sendSmsCode,
                    child: sendingCode ? CircularProgressIndicator() : Text('发送验证码'),
                  )
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: loggingIn ? null : _smsLogin,
                child: loggingIn ? CircularProgressIndicator() : Text('手机号登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

# --- 后端Gin登录路由示例，接收微信/QQ code和手机号登录请求 ---
mkdir -p chat_app/backend/router
cat > chat_app/backend/router/auth.go <<'EOF'
package router

import (
	"chat_app/backend/controller"
	"github.com/gin-gonic/gin"
)

func RegisterAuthRoutes(r *gin.Engine) {
	r.POST("/api/send_code", controller.SendSmsCode)
	r.POST("/api/login_sms", controller.LoginSms)
	r.POST("/api/login_social", controller.SocialLogin)
}
EOF

# --- 后端Gin主路由注册示例 (main.go或router.go中调用) ---
# 这里示范在main.go里
cat >> chat_app/backend/main.go <<'EOF'

// 引入路由
import "chat_app/backend/router"

func main() {
    r := gin.Default()
    router.RegisterAuthRoutes(r)
    // 其它路由注册...

    r.Run(":8080")
}
EOF

# --- 后端服务示例: 验证微信/QQ code与手机号验证码，并生成JWT ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/auth_service.go <<'EOF'
package service

import (
	"errors"
	"time"
	"github.com/dgrijalva/jwt-go"
)

var jwtSecret = []byte("your-secret-key")

// 模拟存储验证码（实际用redis等）
var smsCodeStore = map[string]string{}

// 发送短信验证码示例（实际调用短信服务）
func SendSmsCode(phone string) error {
	// 这里生成随机码并发送
	code := "123456"
	smsCodeStore[phone] = code
	// 调用短信平台发送 code，略
	return nil
}

// 验证短信验证码并返回用户ID
func VerifySmsCodeAndLogin(phone, code string) (userID int64, err error) {
	if v, ok := smsCodeStore[phone]; !ok || v != code {
		return 0, errors.New("验证码错误")
	}
	// 假设用户存在，返回模拟 userID
	return 1001, nil
}

// 验证微信/QQ code并返回用户ID（需要调用微信/QQ开放平台接口换token）
func VerifySocialCode(code, loginType string) (userID int64, err error) {
	// 调用微信或QQ官方接口验证code，换openid和access_token，创建或查找用户，返回userID
	// 此处模拟
	if code == "" {
		return 0, errors.New("code不能为空")
	}
	return 1002, nil
}

// 生成JWT令牌
func GenerateJWT(userID int64) (string, error) {
	claims := jwt.StandardClaims{
		ExpiresAt: time.Now().Add(7 * 24 * time.Hour).Unix(),
		Issuer:    "chat_app",
		Subject:   string(rune(userID)),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}
EOF

# --- 后端 JWT 鉴权中间件 jwt.go ---
mkdir -p chat_app/backend/middleware
cat > chat_app/backend/middleware/jwt.go <<'EOF'
package middleware

import (
	"net/http"
	"strings"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

var jwtSecret = []byte("your-secret-key")

func JWTAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "请求未携带token或格式错误"})
			c.Abort()
			return
		}
		tokenString := authHeader[len("Bearer "):]

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, jwt.ErrSignatureInvalid
			}
			return jwtSecret, nil
		})
		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "无效的token"})
			c.Abort()
			return
		}
		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "无效的token声明"})
			c.Abort()
			return
		}
		// 可将用户信息写入上下文，供后续处理
		c.Set("userID", claims["sub"])
		c.Next()
	}
}
EOF

# --- Flutter 存储 Token 和 API 请求封装 api_service.dart ---
mkdir -p chat_app/frontend/lib/services
cat > chat_app/frontend/lib/services/api_service.dart <<'EOF'
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiService {
  static final _storage = GetStorage();

  static Future<http.Response> get(String url) async {
    final token = _storage.read('token') ?? '';
    return http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
  }

  static Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final token = _storage.read('token') ?? '';
    return http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body != null ? jsonEncode(body) : null);
  }

  static void saveToken(String token) {
    _storage.write('token', token);
  }

  static void clearToken() {
    _storage.remove('token');
  }
}
EOF

# --- Flutter 修改登录逻辑，保存 Token 示例 (摘录) ---
cat >> chat_app/frontend/lib/pages/login_page.dart <<'EOF'

// 在登录成功后示例：
// ApiService.saveToken(token); // token由后端返回后调用

// 例如 _smsLogin 方法中
/*
void _smsLogin() async {
  ...
  if (success) {
    ApiService.saveToken(returnedTokenFromServer);
    authController.login();
    Get.offAllNamed('/');
  }
  ...
}
*/
EOF

# --- 微信和QQ第三方SDK配置简要说明（文本文件） ---
cat > chat_app/frontend/README_SDK_SETUP.md <<'EOF'
# 微信和QQ登录SDK配置说明

## 微信登录
1. 注册微信开放平台账号，创建移动应用，获取AppID和AppSecret。
2. 下载微信官方Flutter插件或集成原生SDK：
   - Android: 修改AndroidManifest.xml，添加微信AppID和scheme。
   - iOS: 配置Info.plist，设置URL Types。
3. 使用微信登录插件调用授权，获取code。

## QQ登录
1. 注册腾讯开放平台，创建应用，获取AppID和AppKey。
2. 下载QQ官方Flutter插件或集成原生SDK：
   - Android: 修改AndroidManifest.xml，添加QQAppID等配置。
   - iOS: 配置Info.plist，设置URL Types。
3. 使用QQ登录插件发起授权。

具体请参考官方文档：
- 微信开放平台：https://open.weixin.qq.com
- 腾讯开放平台：https://open.qq.com

配置完毕后，前端获取code，发送给后端换取用户信息和token。
EOF

# --- 后端 controller/post.go 漂流瓶接口示例 ---

mkdir -p chat_app/backend/controller
cat > chat_app/backend/controller/post.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

// 扔瓶子接口
func ThrowBottle(c *gin.Context) {
	var req struct {
		Content string `json:"content" binding:"required"`
	}
	userID := c.GetString("userID")
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "内容不能为空"})
		return
	}
	err := service.ThrowBottle(userID, req.Content)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "扔瓶子失败"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "扔瓶成功"})
}

// 捞瓶子接口，分页随机获取漂流瓶
func PickBottle(c *gin.Context) {
	pageStr := c.Query("page")
	page, _ := strconv.Atoi(pageStr)
	if page < 1 {
		page = 1
	}
	bottles, err := service.PickBottles(page)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "获取瓶子失败"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": bottles})
}
EOF

# --- 后端 service/post_service.go 漂流瓶业务逻辑示例 ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/post_service.go <<'EOF'
package service

import (
	"chat_app/backend/model"
	"errors"
	"math/rand"
	"time"
)

func ThrowBottle(userID string, content string) error {
	// TODO: 敏感词过滤、内容审核
	post := model.Post{
		UserID:  userID,
		Content: content,
		CreatedAt: time.Now(),
	}
	return model.DB.Create(&post).Error
}

func PickBottles(page int) ([]model.Post, error) {
	var posts []model.Post
	// 简单分页，随机顺序展示
	err := model.DB.Order("random()").Limit(20).Offset((page - 1) * 20).Find(&posts).Error
	if err != nil {
		return nil, errors.New("查询失败")
	}
	return posts, nil
}
EOF

# --- 后端 model/post.go 漂流瓶数据模型示例 ---
mkdir -p chat_app/backend/model
cat > chat_app/backend/model/post.go <<'EOF'
package model

import (
	"time"
)

type Post struct {
	ID        uint      `gorm:"primarykey"`
	UserID    string    `gorm:"index"`
	Content   string    `gorm:"type:text"`
	CreatedAt time.Time
}
EOF

# --- Flutter 漂流瓶扔瓶子页面示例 throw_bottle_page.dart ---
mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/throw_bottle_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class ThrowBottlePage extends StatefulWidget {
  @override
  _ThrowBottlePageState createState() => _ThrowBottlePageState();
}

class _ThrowBottlePageState extends State<ThrowBottlePage> {
  final TextEditingController _contentController = TextEditingController();
  bool _sending = false;

  void _sendBottle() async {
    if (_contentController.text.trim().isEmpty) return;
    setState(() => _sending = true);
    final res = await ApiService.post('http://localhost:8080/api/throw_bottle', {
      'content': _contentController.text.trim(),
    });
    setState(() => _sending = false);
    if (res.statusCode == 200) {
      Get.snackbar('成功', '漂流瓶已扔出');
      _contentController.clear();
    } else {
      Get.snackbar('失败', '扔瓶失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('扔漂流瓶')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(hintText: '写下你的心事，扔出去吧'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sending ? null : _sendBottle,
              child: _sending ? CircularProgressIndicator() : Text('扔出漂流瓶'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# --- Flutter 漂流瓶捞瓶子页面示例 pick_bottle_page.dart ---
cat > chat_app/frontend/lib/pages/pick_bottle_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:convert';

class PickBottlePage extends StatefulWidget {
  @override
  _PickBottlePageState createState() => _PickBottlePageState();
}

class _PickBottlePageState extends State<PickBottlePage> {
  int page = 1;
  List<dynamic> bottles = [];
  bool loading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadBottles();
  }

  void _loadBottles() async {
    if (loading || !hasMore) return;
    setState(() => loading = true);
    final res = await ApiService.get('http://localhost:8080/api/pick_bottle?page=$page');
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List newBottles = data['data'];
      if (newBottles.length < 20) hasMore = false;
      bottles.addAll(newBottles);
      page++;
    } else {
      Get.snackbar('错误', '加载漂流瓶失败');
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('捞漂流瓶')),
      body: ListView.builder(
        itemCount: bottles.length + 1,
        itemBuilder: (context, index) {
          if (index == bottles.length) {
            if (hasMore) {
              _loadBottles();
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('没有更多了'));
            }
          }
          final bottle = bottles[index];
          return ListTile(
            title: Text(bottle['content']),
            subtitle: Text('来自用户 ${bottle['userID']}'),
          );
        },
      ),
    );
  }
}
EOF

# --- 后端 controller/chat.go 私信聊天接口示例 ---
mkdir -p chat_app/backend/controller
cat > chat_app/backend/controller/chat.go <<'EOF'
package controller

import (
	"chat_app/backend/model"
	"chat_app/backend/service"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

// 发送私信
func SendMessage(c *gin.Context) {
	var req struct {
		ToUserID string `json:"toUserId" binding:"required"`
		Content  string `json:"content" binding:"required"`
	}
	userID := c.GetString("userID")
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "参数错误"})
		return
	}
	err := service.SendMessage(userID, req.ToUserID, req.Content)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "发送失败"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "发送成功"})
}

// 获取聊天历史，分页
func GetChatHistory(c *gin.Context) {
	userID := c.GetString("userID")
	peerID := c.Query("peerId")
	pageStr := c.Query("page")
	page, _ := strconv.Atoi(pageStr)
	if page < 1 {
		page = 1
	}
	messages, err := service.GetChatHistory(userID, peerID, page)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "获取失败"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": messages})
}
EOF

# --- 后端 service/chat_service.go 聊天业务逻辑示例 ---
mkdir -p chat_app/backend/service
cat > chat_app/backend/service/chat_service.go <<'EOF'
package service

import (
	"chat_app/backend/model"
	"errors"
	"time"
)

func SendMessage(fromUserID, toUserID, content string) error {
	// TODO: 敏感词过滤，图片审核
	msg := model.Message{
		FromUserID: fromUserID,
		ToUserID:   toUserID,
		Content:    content,
		CreatedAt:  time.Now(),
	}
	return model.DB.Create(&msg).Error
}

func GetChatHistory(userID, peerID string, page int) ([]model.Message, error) {
	var msgs []model.Message
	err := model.DB.
		Where("(from_user_id = ? AND to_user_id = ?) OR (from_user_id = ? AND to_user_id = ?)", userID, peerID, peerID, userID).
		Order("created_at desc").
		Limit(20).
		Offset((page - 1) * 20).
		Find(&msgs).Error
	if err != nil {
		return nil, errors.New("查询失败")
	}
	return msgs, nil
}
EOF

# --- 后端 model/message.go 消息模型示例 ---
mkdir -p chat_app/backend/model
cat > chat_app/backend/model/message.go <<'EOF'
package model

import "time"

type Message struct {
	ID         uint      `gorm:"primarykey"`
	FromUserID string    `gorm:"index"`
	ToUserID   string    `gorm:"index"`
	Content    string    `gorm:"type:text"`
	CreatedAt  time.Time
}
EOF

# --- Flutter 私信聊天页 chat_page.dart 简单示例 ---
mkdir -p chat_app/frontend/lib/pages
cat > chat_app/frontend/lib/pages/chat_page.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerName;

  ChatPage({required this.peerId, required this.peerName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _inputController = TextEditingController();
  List messages = [];
  int page = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    if (loading) return;
    setState(() => loading = true);
    final res = await ApiService.get(
        'http://localhost:8080/api/chat_history?peerId=${widget.peerId}&page=$page');
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List newMsgs = data['data'];
      messages.insertAll(0, newMsgs);
      page++;
    } else {
      Get.snackbar('错误', '获取聊天记录失败');
    }
    setState(() => loading = false);
  }

  void _sendMessage() async {
    final content = _inputController.text.trim();
    if (content.isEmpty) return;
    final res = await ApiService.post('http://localhost:8080/api/send_message', {
      'toUserId': widget.peerId,
      'content': content,
    });
    if (res.statusCode == 200) {
      _inputController.clear();
      setState(() {
        messages.add({
          'fromUserId': 'me',
          'toUserId': widget.peerId,
          'content': content,
          'createdAt': DateTime.now().toString(),
        });
      });
    } else {
      Get.snackbar('错误', '发送失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.peerName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                final isMe = msg['fromUserId'] == 'me';
                return Container(
                  padding: EdgeInsets.all(8),
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(msg['content'], style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: InputDecoration(hintText: '输入消息'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }
}
EOF

# --- 简单敏感词过滤示例 service/sensitive_filter.go ---
cat > chat_app/backend/service/sensitive_filter.go <<'EOF'
package service

import (
	"strings"
)

var sensitiveWords = []string{
	"敏感词1",
	"敏感词2",
	"涉政",
	"涉黄",
	// 可维护为文件或数据库
}

func ContainsSensitiveWords(text string) bool {
	for _, w := range sensitiveWords {
		if strings.Contains(text, w) {
			return true
		}
	}
	return false
}
EOF

# --- 图片内容安全调用示例 utils/tencent_censor.go ---
mkdir -p chat_app/backend/utils
cat > chat_app/backend/utils/tencent_censor.go <<'EOF'
package utils

import (
	"context"
	"fmt"
	"io/ioutil"
	"net/http"
	"bytes"
	"encoding/json"
)

const (
	TencentCensorAPI = "https://your.tencent.cloud.image.censor.api" // 替换为实际接口
	SecretId  = "你的SecretId"
	SecretKey = "你的SecretKey"
)

type ImageCensorRequest struct {
	ImageBase64 string `json:"image_base64"`
}

type ImageCensorResponse struct {
	Result string `json:"result"`
}

func CheckImageContent(imageData []byte) (bool, error) {
	// 将图片转换为Base64，调用腾讯云图片内容安全API
	// 此处示例简化，仅示意结构，真实需用腾讯云SDK并签名
	reqBody := ImageCensorRequest{
		ImageBase64: string(imageData), // 需要base64编码，示意
	}
	jsonData, _ := json.Marshal(reqBody)
	resp, err := http.Post(TencentCensorAPI, "application/json", bytes.NewBuffer(jsonData))
	if err != nil {
		return false, err
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	var res ImageCensorResponse
	json.Unmarshal(body, &res)
	if res.Result == "pass" {
		return true, nil
	}
	return false, fmt.Errorf("图片内容不合规")
}
EOF

# --- Flutter 本地敏感词过滤示例 sensitive_filter.dart ---
mkdir -p chat_app/frontend/lib/utils
cat > chat_app/frontend/lib/utils/sensitive_filter.dart <<'EOF'
class SensitiveFilter {
  static final List<String> sensitiveWords = [
    "敏感词1",
    "敏感词2",
    "涉政",
    "涉黄",
  ];

  static bool containsSensitiveWord(String text) {
    for (var word in sensitiveWords) {
      if (text.contains(word)) {
        return true;
      }
    }
    return false;
  }
}
EOF

# --- Flutter 图片上传组件示例 upload_image_widget.dart ---
mkdir -p chat_app/frontend/lib/widgets
cat > chat_app/frontend/lib/widgets/upload_image_widget.dart <<'EOF'
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class UploadImageWidget extends StatefulWidget {
  final Function(String url) onUploaded;

  UploadImageWidget({required this.onUploaded});

  @override
  _UploadImageWidgetState createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  File? _imageFile;
  bool _uploading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    setState(() => _uploading = true);
    // TODO: 调用后端图片上传接口，返回URL
    // 这里只是示意，实际上传请用 multipart/form-data
    final res = await ApiService.post('http://localhost:8080/api/upload_image', {
      // 模拟参数，实际请替换
      'file_path': _imageFile!.path,
    });
    setState(() => _uploading = false);
    if (res.statusCode == 200) {
      final url = res.body; // 假设后端直接返回图片URL
      widget.onUploaded(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('上传失败')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imageFile != null ? Image.file(_imageFile!) : SizedBox(height: 150, child: Placeholder()),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _uploading ? null : _pickImage,
          child: _uploading ? CircularProgressIndicator() : Text('选择并上传图片'),
        ),
      ],
    );
  }
}
EOF

# --- Flutter 调用图片内容审核后端接口示例（摘录，upload_image_widget.dart中调用） ---
cat >> chat_app/frontend/lib/services/api_service.dart <<'EOF'

// 调用后端图片内容审核接口
Future<bool> checkImageContent(String imageUrl) async {
  final res = await http.post(Uri.parse('http://localhost:8080/api/check_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': imageUrl}));
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    return data['pass'] == true;
  }
  return false;
}
EOF

# --- 后端 controller/image.go 图片上传和审核接口示例 ---
mkdir -p chat_app/backend/controller
cat > chat_app/backend/controller/image.go <<'EOF'
package controller

import (
	"chat_app/backend/utils"
	"github.com/gin-gonic/gin"
	"net/http"
	"io/ioutil"
	"path/filepath"
)

// 这里简化，实际建议用 multipart/form-data 方式上传
func UploadImage(c *gin.Context) {
	file, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "未收到文件"})
		return
	}
	// 保存文件到本地临时目录
	dst := filepath.Join("./uploads", filepath.Base(file.Filename))
	if err := c.SaveUploadedFile(file, dst); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "保存文件失败"})
		return
	}
	
	// 读取文件内容用于审核
	data, err := ioutil.ReadFile(dst)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "读取文件失败"})
		return
	}
	pass, err := utils.CheckImageContent(data)
	if err != nil || !pass {
		c.JSON(http.StatusForbidden, gin.H{"error": "图片内容不合规"})
		return
	}

	// TODO: 上传至阿里云OSS并获取URL，示例用本地路径代替
	imageURL := "/uploads/" + filepath.Base(file.Filename)

	c.JSON(http.StatusOK, gin.H{"url": imageURL})
}
EOF

# --- 后端路由添加示例 router.go ---
cat >> chat_app/backend/router.go <<'EOF'

// 图片上传及审核相关路由
r.POST("/api/upload_image", controller.UploadImage)
EOF

# ==== start.sh 一键启动脚本 ====

cat > start.sh << 'EOF'
#!/bin/bash

echo "开始构建并启动 Docker 容器..."

docker-compose down

docker-compose up -d --build

echo "所有服务启动完毕。"
echo "前端访问: http://localhost:5000"
echo "后端 API: http://localhost:8080"
EOF

chmod +x start.sh


# ==== docker-compose.yml 文件 ====

cat > docker-compose.yml << 'EOF'
version: "3.8"
services:
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: chatappdb
      POSTGRES_USER: chatappuser
      POSTGRES_PASSWORD: yourpassword
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  backend:
    build: ./backend
    depends_on:
      - db
    environment:
      - DB_HOST=db
      - DB_PORT=5432
      - DB_USER=chatappuser
      - DB_PASS=yourpassword
      - DB_NAME=chatappdb
    ports:
      - "8080:8080"

  frontend:
    build: ./frontend
    ports:
      - "5000:5000"
    depends_on:
      - backend

volumes:
  pgdata:
EOF


# ==== backend/Dockerfile ====

mkdir -p backend
cat > backend/Dockerfile << 'EOF'
FROM golang:1.20-alpine
WORKDIR /app
COPY . .
RUN go mod tidy && go build -o chatapp main.go
EXPOSE 8080
CMD ["./chatapp"]
EOF


# ==== frontend/Dockerfile ====

mkdir -p frontend
cat > frontend/Dockerfile << 'EOF'
FROM cirrusci/flutter:latest
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web
EXPOSE 5000
CMD ["flutter", "run", "-d", "web-server", "--web-port", "5000"]
EOF


# ==== 说明 ====

echo "文件生成完毕："
echo "  - start.sh (一键启动脚本)"
echo "  - docker-compose.yml (Docker服务编排)"
echo "  - backend/Dockerfile (Go后端镜像构建)"
echo "  - frontend/Dockerfile (Flutter前端镜像构建)"
echo ""
echo "运行步骤："
echo "  1. 配置 backend/config/config.go 数据库连接"
echo "  2. 运行 ./start.sh 即可启动全部服务"

# ==== 生成 backend/go.mod 文件 ====

mkdir -p backend
cat > backend/go.mod << 'EOF'
module chat_app/backend

go 1.20

require (
    github.com/gin-gonic/gin v1.9.0
    gorm.io/driver/postgres v1.5.0
    gorm.io/gorm v1.26.1
)
EOF


# ==== 生成 README 部署说明文件 ====

cat > README_DEPLOY.md << 'EOF'
# Chat App 部署与启动说明

## 后端启动调试

## 后端启动调试

1. 进入后端目录：
cd backend
 

2. 安装依赖并生成模块文件：
go mod tidy

 

3. 启动后端服务：
go run main.go

 

4. 访问 http://localhost:8080 进行接口测试。

---

## 前端启动调试

1. 进入前端目录：
cd frontend
 

2. 安装依赖：
flutter pub get

  

3. 运行调试（连接设备或模拟器）：
flutter run


4. 修改前端代码中的 API 地址为你的后端地址。

---

## 使用 Docker 启动（推荐）

1. 确保 Docker 和 docker-compose 已安装。

2. 运行一键启动脚本：
./start.sh
 
3. 前端地址：http://localhost:5000

4. 后端接口：http://localhost:8080

---

## 配置说明

- 修改 `backend/config/config.go` 中的数据库连接配置，保证连接正确。
- 确认 PostgreSQL 数据库已启动并创建了对应数据库及用户。
EOF


# ==== 提示完成 ====

echo "生成完成："
echo "  - backend/go.mod"
echo "  - README_DEPLOY.md (部署启动说明)"
echo "请查看 README_DEPLOY.md 了解详细启动步骤。"

