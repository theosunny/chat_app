package handlers

import (
	"net/http"
	"strconv"

	"chat_app_backend/services"
	"github.com/gin-gonic/gin"
)

type MessageHandler struct {
	messageService *services.MessageService
}

// NewMessageHandler 创建消息处理器实例
func NewMessageHandler() *MessageHandler {
	return &MessageHandler{
		messageService: services.NewMessageService(),
	}
}

// ConversationResponse 会话响应结构
type ConversationResponse struct {
	ID          uint      `json:"id"`
	OtherUser   interface{} `json:"other_user"`
	LastMessage interface{} `json:"last_message"`
	UnreadCount int       `json:"unread_count"`
	UpdatedAt   string    `json:"updated_at"`
}

// GetConversations 获取会话列表
func (h *MessageHandler) GetConversations(c *gin.Context) {
	// 获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "用户未认证",
		})
		return
	}

	conversations, err := h.messageService.GetConversations(userID.(uint))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "获取会话列表失败",
			"error":   err.Error(),
		})
		return
	}

	// 转换为前端期望的格式
	var responseData []ConversationResponse
	for _, conv := range conversations {
		// 确定对方用户
		var otherUser interface{}
		var unreadCount int
		if conv.User1ID == userID.(uint) {
			otherUser = conv.User2
			unreadCount = conv.User1UnreadCount
		} else {
			otherUser = conv.User1
			unreadCount = conv.User2UnreadCount
		}

		// 构建最后一条消息
		var lastMessage interface{}
		if conv.LastMessageID != nil {
			lastMessage = map[string]interface{}{
				"id":         *conv.LastMessageID,
				"content":    conv.LastMessageContent,
				"created_at": conv.LastMessageTime.Format("2006-01-02T15:04:05Z07:00"),
			}
		}

		responseData = append(responseData, ConversationResponse{
			ID:          conv.ID,
			OtherUser:   otherUser,
			LastMessage: lastMessage,
			UnreadCount: unreadCount,
			UpdatedAt:   conv.UpdatedAt.Format("2006-01-02T15:04:05Z07:00"),
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "获取会话列表成功",
		"data":    responseData,
	})
}

// GetMessages 获取消息列表
func (h *MessageHandler) GetMessages(c *gin.Context) {
	// 获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "用户未认证",
		})
		return
	}

	// 获取会话ID
	conversationIDStr := c.Query("conversation_id")
	if conversationIDStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "缺少会话ID参数",
		})
		return
	}

	conversationID, err := strconv.ParseUint(conversationIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "无效的会话ID",
		})
		return
	}

	// 获取分页参数
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	pageSize, _ := strconv.Atoi(c.DefaultQuery("page_size", "50"))

	if page < 1 {
		page = 1
	}
	if pageSize < 1 || pageSize > 100 {
		pageSize = 50
	}

	messages, total, err := h.messageService.GetMessages(uint(conversationID), page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "获取消息列表失败",
			"error":   err.Error(),
		})
		return
	}

	// 标记消息为已读
	go h.messageService.MarkMessagesAsRead(uint(conversationID), userID.(uint))

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "获取消息列表成功",
		"data": gin.H{
			"messages":  messages,
			"total":     total,
			"page":      page,
			"page_size": pageSize,
		},
	})
}

// SendMessage 发送消息
func (h *MessageHandler) SendMessage(c *gin.Context) {
	// 获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "用户未认证",
		})
		return
	}

	var req struct {
		ReceiverID  uint   `json:"receiver_id" binding:"required"`
		Content     string `json:"content" binding:"required"`
		MessageType string `json:"message_type"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "请求参数错误",
			"error":   err.Error(),
		})
		return
	}

	// 设置默认消息类型
	if req.MessageType == "" {
		req.MessageType = "text"
	}

	// 获取或创建会话
	conversation, err := h.messageService.GetOrCreateConversation(userID.(uint), req.ReceiverID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "创建会话失败",
			"error":   err.Error(),
		})
		return
	}

	// 发送消息
	message, err := h.messageService.SendMessage(
		conversation.ID,
		userID.(uint),
		req.ReceiverID,
		req.Content,
		req.MessageType,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "发送消息失败",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "发送消息成功",
		"data":    message,
	})
}

// StartConversation 开始会话
func (h *MessageHandler) StartConversation(c *gin.Context) {
	// 获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "用户未认证",
		})
		return
	}

	var req struct {
		TargetUserID uint `json:"target_user_id" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "请求参数错误",
			"error":   err.Error(),
		})
		return
	}

	// 不能和自己开始会话
	if userID.(uint) == req.TargetUserID {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "不能和自己开始会话",
		})
		return
	}

	// 获取或创建会话
	conversation, err := h.messageService.GetOrCreateConversation(userID.(uint), req.TargetUserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "创建会话失败",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "会话创建成功",
		"data":    conversation,
	})
}

// DeleteMessage 删除消息
func (h *MessageHandler) DeleteMessage(c *gin.Context) {
	// 获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "用户未认证",
		})
		return
	}

	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "无效的消息ID",
		})
		return
	}

	err = h.messageService.DeleteMessage(uint(id), userID.(uint))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "删除消息成功",
	})
}