package services

import (
	"errors"
	"fmt"
	"math/rand"
	"time"

	"chat_app_backend/database"
	"chat_app_backend/middleware"
	"github.com/golang-jwt/jwt/v4"
	"gorm.io/gorm"
)

type UserService struct {
	db        *gorm.DB
	jwtSecret string
}

// NewUserService 创建用户服务实例
func NewUserService(jwtSecret string) *UserService {
	return &UserService{
		db:        database.GetDB(),
		jwtSecret: jwtSecret,
	}
}

// SendVerificationCode 发送验证码
func (s *UserService) SendVerificationCode(phone string) error {
	// 这里应该集成真实的短信服务
	// 目前只是模拟发送验证码
	fmt.Printf("发送验证码到手机号: %s, 验证码: 123456\n", phone)
	return nil
}

// VerifyCodeAndLogin 验证码登录
func (s *UserService) VerifyCodeAndLogin(phone, code string) (*database.User, string, error) {
	// 验证验证码（这里简化处理，实际应该验证真实的验证码）
	if code != "123456" {
		return nil, "", errors.New("验证码错误")
	}

	// 查找或创建用户
	user, err := database.GetUserByPhone(phone)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			// 用户不存在，创建新用户
			user = &database.User{
				Phone:    phone,
				Nickname: s.generateNickname(),
				Avatar:   s.generateAvatar(),
				Gender:   "unknown",
			}
			if err := database.CreateUser(user); err != nil {
				return nil, "", fmt.Errorf("创建用户失败: %v", err)
			}
		} else {
			return nil, "", fmt.Errorf("查询用户失败: %v", err)
		}
	}

	// 生成JWT token（这里简化处理）
	token := s.generateToken(user.ID)

	return user, token, nil
}

// GetUserByID 根据ID获取用户
func (s *UserService) GetUserByID(userID uint) (*database.User, error) {
	return database.GetUserByID(userID)
}

// UpdateUser 更新用户信息
func (s *UserService) UpdateUser(userID uint, updates map[string]interface{}) error {
	return database.UpdateUser(userID, updates)
}

// LoginWithThirdParty 第三方登录
func (s *UserService) LoginWithThirdParty(provider, code string) (*database.User, string, error) {
	// 模拟第三方登录验证
	if code == "" {
		return nil, "", errors.New("授权码不能为空")
	}

	// 模拟从第三方平台获取用户信息
	var thirdPartyUserID string
	var nickname string
	var avatar string

	switch provider {
	case "qq":
		// 模拟QQ登录
		thirdPartyUserID = fmt.Sprintf("qq_%s", code)
		nickname = "QQ用户" + code[:4]
		avatar = "/uploads/avatars/qq_default.svg"
	case "wechat":
		// 模拟微信登录
		thirdPartyUserID = fmt.Sprintf("wechat_%s", code)
		nickname = "微信用户" + code[:4]
		avatar = "/uploads/avatars/wechat_default.svg"
	default:
		return nil, "", errors.New("不支持的登录方式")
	}

	// 查找或创建用户
	user, err := database.GetUserByThirdPartyID(thirdPartyUserID)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			// 用户不存在，创建新用户
			user = &database.User{
				ThirdPartyID: thirdPartyUserID,
				Nickname:     nickname,
				Avatar:       avatar,
				Gender:       "unknown",
			}
			if err := database.CreateUser(user); err != nil {
				return nil, "", fmt.Errorf("创建用户失败: %v", err)
			}
		} else {
			return nil, "", fmt.Errorf("查询用户失败: %v", err)
		}
	}

	// 生成JWT token
	token := s.generateToken(user.ID)

	return user, token, nil
}

// generateNickname 生成随机昵称
func (s *UserService) generateNickname() string {
	adjectives := []string{"快乐的", "勇敢的", "聪明的", "温柔的", "活泼的", "可爱的", "神秘的", "优雅的"}
	nouns := []string{"小猫", "小狗", "小鸟", "小鱼", "小熊", "小兔", "小鹿", "小狐狸"}
	
	rand.Seed(time.Now().UnixNano())
	adj := adjectives[rand.Intn(len(adjectives))]
	noun := nouns[rand.Intn(len(nouns))]
	
	return fmt.Sprintf("%s%s", adj, noun)
}

// generateAvatar 生成默认头像
func (s *UserService) generateAvatar() string {
	avatars := []string{
		"/uploads/avatars/default1.svg",
		"/uploads/avatars/default2.svg",
		"/uploads/avatars/default3.svg",
		"/uploads/avatars/default4.svg",
		"/uploads/avatars/default5.svg",
	}
	
	rand.Seed(time.Now().UnixNano())
	return avatars[rand.Intn(len(avatars))]
}

// generateToken 生成JWT token
func (s *UserService) generateToken(userID uint) string {
	// 创建JWT声明
	claims := &middleware.JWTClaims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour * 7)), // 7天过期
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			Issuer:    "chat_app_backend",
		},
	}

	// 创建token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// 签名token
	tokenString, err := token.SignedString([]byte(s.jwtSecret))
	if err != nil {
		return ""
	}

	return tokenString
}