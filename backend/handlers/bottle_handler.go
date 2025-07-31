package handlers

import (
	"net/http"
	"strconv"

	"chat_app_backend/services"

	"github.com/gin-gonic/gin"
)

type BottleHandler struct {
	bottleService *services.BottleService
}

// NewBottleHandler 创建漂流瓶处理器实例
func NewBottleHandler() *BottleHandler {
	return &BottleHandler{
		bottleService: services.NewBottleService(),
	}
}

// GetBottles 获取漂流瓶列表
func (h *BottleHandler) GetBottles(c *gin.Context) {
	// 获取分页参数
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "10"))

	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 50 {
		limit = 10
	}

	bottles, total, err := h.bottleService.GetBottles(page, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "获取漂流瓶列表失败",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "获取漂流瓶列表成功",
		"data": gin.H{
			"bottles": bottles,
			"total":   total,
			"page":    page,
			"limit":   limit,
		},
	})
}

// PickRandomBottle 捞取随机漂流瓶
func (h *BottleHandler) PickRandomBottle(c *gin.Context) {
	// 从JWT中间件获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"code":    401,
			"message": "未授权访问",
		})
		return
	}

	bottle, err := h.bottleService.CatchBottle(userID.(uint))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"success": false,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "捞取漂流瓶成功",
		"data":    bottle,
	})
}

// CreateBottle 创建漂流瓶
func (h *BottleHandler) CreateBottle(c *gin.Context) {
	// 从JWT中间件获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "未授权访问",
		})
		return
	}

	var req struct {
		Content  string `json:"content" binding:"required"`
		Type     string `json:"type"`
		Location string `json:"location"`
		IsPublic bool   `json:"is_public"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "请求参数错误",
			"error":   err.Error(),
		})
		return
	}

	// 设置默认类型
	if req.Type == "" {
		req.Type = "text"
	}

	bottle, err := h.bottleService.CreateBottle(userID.(uint), req.Content, req.Type, req.Location, req.IsPublic)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "创建漂流瓶失败",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"success": true,
		"message": "创建漂流瓶成功",
		"data":    bottle,
	})
}

// GetBottleDetail 获取漂流瓶详情
func (h *BottleHandler) GetBottleDetail(c *gin.Context) {
	bottleIDStr := c.Param("id")
	bottleID, err := strconv.ParseUint(bottleIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "漂流瓶ID格式错误",
		})
		return
	}

	bottle, err := h.bottleService.GetBottleByID(uint(bottleID))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"success": false,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "获取漂流瓶详情成功",
		"data":    bottle,
	})
}

// GetMyBottles 获取我的漂流瓶
func (h *BottleHandler) GetMyBottles(c *gin.Context) {
	// 从JWT中间件获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "未授权访问",
		})
		return
	}

	// 获取分页参数
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "10"))

	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 50 {
		limit = 10
	}

	bottles, total, err := h.bottleService.GetMyBottles(userID.(uint), page, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "获取我的漂流瓶失败",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "获取我的漂流瓶成功",
		"data": gin.H{
			"bottles": bottles,
			"total":   total,
			"page":    page,
			"limit":   limit,
		},
	})
}

// DeleteBottle 删除漂流瓶
func (h *BottleHandler) DeleteBottle(c *gin.Context) {
	// 从JWT中间件获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "未授权访问",
		})
		return
	}

	bottleIDStr := c.Param("id")
	bottleID, err := strconv.ParseUint(bottleIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "漂流瓶ID格式错误",
		})
		return
	}

	err = h.bottleService.DeleteBottle(uint(bottleID), userID.(uint))
	if err != nil {
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "删除漂流瓶成功",
	})
}
