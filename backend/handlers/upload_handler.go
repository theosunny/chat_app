package handlers

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type UploadHandler struct{}

// NewUploadHandler 创建上传处理器实例
func NewUploadHandler() *UploadHandler {
	return &UploadHandler{}
}

// UploadImage 上传图片
func (h *UploadHandler) UploadImage(c *gin.Context) {
	// 获取用户ID
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "用户未认证",
		})
		return
	}

	// 获取上传的文件
	file, header, err := c.Request.FormFile("image")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "获取上传文件失败",
			"error":   err.Error(),
		})
		return
	}
	defer file.Close()

	// 检查文件类型
	allowedTypes := []string{".jpg", ".jpeg", ".png", ".gif", ".webp"}
	ext := strings.ToLower(filepath.Ext(header.Filename))
	isAllowed := false
	for _, allowedType := range allowedTypes {
		if ext == allowedType {
			isAllowed = true
			break
		}
	}

	if !isAllowed {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "不支持的文件类型，仅支持 jpg, jpeg, png, gif, webp",
		})
		return
	}

	// 检查文件大小 (限制为5MB)
	if header.Size > 5*1024*1024 {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "文件大小不能超过5MB",
		})
		return
	}

	// 创建上传目录
	uploadDir := "uploads/images"
	if err := os.MkdirAll(uploadDir, 0755); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "创建上传目录失败",
			"error":   err.Error(),
		})
		return
	}

	// 生成唯一文件名
	uuidStr := uuid.New().String()
	timestamp := time.Now().Format("20060102150405")
	filename := fmt.Sprintf("%d_%s_%s%s", userID.(uint), timestamp, uuidStr, ext)
	filePath := filepath.Join(uploadDir, filename)

	// 创建目标文件
	dst, err := os.Create(filePath)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "创建文件失败",
			"error":   err.Error(),
		})
		return
	}
	defer dst.Close()

	// 复制文件内容
	if _, err := io.Copy(dst, file); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "保存文件失败",
			"error":   err.Error(),
		})
		return
	}

	// 返回相对路径URL，避免跨域问题
	fileURL := fmt.Sprintf("/uploads/images/%s", filename)

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "上传成功",
		"data": gin.H{
			"url":      fileURL,
			"filename": filename,
			"size":     header.Size,
		},
	})
}

// UploadAvatar 上传头像
func (h *UploadHandler) UploadAvatar(c *gin.Context) {
	// 获取用户ID
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "用户未认证",
		})
		return
	}

	// 获取上传的文件
	file, header, err := c.Request.FormFile("avatar")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "获取上传文件失败",
			"error":   err.Error(),
		})
		return
	}
	defer file.Close()

	// 检查文件类型
	allowedTypes := []string{".jpg", ".jpeg", ".png"}
	ext := strings.ToLower(filepath.Ext(header.Filename))
	isAllowed := false
	for _, allowedType := range allowedTypes {
		if ext == allowedType {
			isAllowed = true
			break
		}
	}

	if !isAllowed {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "不支持的文件类型，仅支持 jpg, jpeg, png",
		})
		return
	}

	// 检查文件大小 (限制为2MB)
	if header.Size > 2*1024*1024 {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "头像文件大小不能超过2MB",
		})
		return
	}

	// 创建上传目录
	uploadDir := "uploads/avatars"
	if err := os.MkdirAll(uploadDir, 0755); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "创建上传目录失败",
			"error":   err.Error(),
		})
		return
	}

	// 生成唯一文件名
	uuidStr := uuid.New().String()
	timestamp := time.Now().Format("20060102150405")
	filename := fmt.Sprintf("avatar_%d_%s_%s%s", userID.(uint), timestamp, uuidStr, ext)
	filePath := filepath.Join(uploadDir, filename)

	// 创建目标文件
	dst, err := os.Create(filePath)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "创建文件失败",
			"error":   err.Error(),
		})
		return
	}
	defer dst.Close()

	// 复制文件内容
	if _, err := io.Copy(dst, file); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "保存文件失败",
			"error":   err.Error(),
		})
		return
	}

	// 返回相对路径URL，避免跨域问题
	fileURL := fmt.Sprintf("/uploads/avatars/%s", filename)

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "头像上传成功",
		"data": gin.H{
			"url":      fileURL,
			"filename": filename,
			"size":     header.Size,
		},
	})
}