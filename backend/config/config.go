package config

import (
	"os"
)

type Config struct {
	DatabaseDSN string
	ServerPort  string
	JWTSecret   string

	// 推送服务配置
	FCMServerKey string
	APNSKeyID    string
	APNSTeamID   string
	APNSBundleID string
	APNSKeyPath  string
}

// LoadConfig 加载配置
func LoadConfig() *Config {
	return &Config{
		DatabaseDSN: getEnv("DATABASE_DSN", "chat:123456@tcp(localhost:3306)/chatapp?charset=utf8mb4&parseTime=True&loc=Local"),
		ServerPort:  getEnv("SERVER_PORT", "0.0.0.0:8080"),
		JWTSecret:   getEnv("JWT_SECRET", "your-secret-key"),

		// 推送服务配置
		FCMServerKey: getEnv("FCM_SERVER_KEY", ""),
		APNSKeyID:    getEnv("APNS_KEY_ID", ""),
		APNSTeamID:   getEnv("APNS_TEAM_ID", ""),
		APNSBundleID: getEnv("APNS_BUNDLE_ID", ""),
		APNSKeyPath:  getEnv("APNS_KEY_PATH", ""),
	}
}

// getEnv 获取环境变量，如果不存在则返回默认值
func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
