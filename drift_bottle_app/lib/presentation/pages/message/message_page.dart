import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/conversation_model.dart';
import '../../../utils/image_utils.dart';
import '../../providers/message_provider.dart';
import '../../providers/auth_provider.dart';
import 'chat_page.dart';
import '../chat/em_chat_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConversations();
    });
  }

  Future<void> _loadConversations() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    
    // 等待认证状态确定
    while (authProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    // 确保用户已登录后再加载会话列表
    if (authProvider.isLoggedIn) {
      await messageProvider.fetchConversations();
      // 同时加载环信会话列表
      await messageProvider.fetchEMConversations();
    }
  }

  Future<void> _deleteConversation(String conversationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个会话吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final messageProvider = Provider.of<MessageProvider>(context, listen: false);
        await messageProvider.deleteConversation(conversationId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('会话已删除')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('删除失败: $e')),
        );
      }
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${time.month}-${time.day}';
    }
  }

  String _getMessagePreview(MessageModel message) {
    switch (message.type) {
      case MessageType.text:
        return message.content;
      case MessageType.image:
        return '[图片]';
      case MessageType.system:
        return message.content;
      default:
        return message.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 实现搜索功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('搜索功能开发中')),
              );
            },
          ),
        ],
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          if (messageProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 检查是否有任何会话
          final hasConversations = messageProvider.conversations.isNotEmpty || messageProvider.emConversations.isNotEmpty;
          
          if (!hasConversations) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无消息',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '去漂流瓶或动态中与其他用户互动吧',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadConversations,
            child: ListView.builder(
              itemCount: _getTotalItemCount(messageProvider),
              itemBuilder: (context, index) {
                return _buildListItem(context, messageProvider, index);
              },
            ),
          );
        },
      ),
    );
  }
  
  int _getTotalItemCount(MessageProvider messageProvider) {
    int count = 0;
    
    // 环信会话
    if (messageProvider.emConversations.isNotEmpty) {
      count += 1; // 标题
      count += messageProvider.emConversations.length;
    }
    
    // 原有会话
    if (messageProvider.conversations.isNotEmpty) {
      count += 1; // 标题
      count += messageProvider.conversations.length;
    }
    
    return count;
  }
  
  Widget _buildListItem(BuildContext context, MessageProvider messageProvider, int index) {
    int currentIndex = 0;
    
    // 环信会话部分
    if (messageProvider.emConversations.isNotEmpty) {
      if (index == currentIndex) {
        return _buildSectionHeader('即时聊天');
      }
      currentIndex++;
      
      if (index < currentIndex + messageProvider.emConversations.length) {
        final emConversation = messageProvider.emConversations[index - currentIndex];
        return _buildEMConversationItem(context, emConversation, messageProvider);
      }
      currentIndex += messageProvider.emConversations.length;
    }
    
    // 原有会话部分
    if (messageProvider.conversations.isNotEmpty) {
      if (index == currentIndex) {
        return _buildSectionHeader('系统消息');
      }
      currentIndex++;
      
      if (index < currentIndex + messageProvider.conversations.length) {
        final conversation = messageProvider.conversations[index - currentIndex];
        return _buildOriginalConversationItem(context, conversation, messageProvider);
      }
    }
    
    return const SizedBox.shrink();
  }
  
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
    );
  }
  
  Widget _buildEMConversationItem(BuildContext context, EMConversation conversation, MessageProvider messageProvider) {
    return Column(
      children: [
        ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 24,
                child: Text(
                  conversation.id[0].toUpperCase(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              if (conversation.unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: FutureBuilder<int>(
                      future: conversation.unreadCount(),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        return Text(
                          count > 99 ? '99+' : count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          title: FutureBuilder<int>(
            future: conversation.unreadCount(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Text(
                conversation.id,
                style: TextStyle(
                  fontWeight: count > 0 ? FontWeight.bold : FontWeight.normal,
                ),
              );
            },
          ),
          subtitle: FutureBuilder<EMMessage?>(
            future: conversation.latestMessage(),
            builder: (context, messageSnapshot) {
              return FutureBuilder<int>(
                future: conversation.unreadCount(),
                builder: (context, countSnapshot) {
                  final count = countSnapshot.data ?? 0;
                  final message = messageSnapshot.data;
                  return Text(
                    message?.body ?? '暂无消息',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: count > 0 ? Colors.black87 : Colors.grey[600],
                      fontWeight: count > 0 ? FontWeight.w500 : FontWeight.normal,
                    ),
                  );
                },
              );
            },
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FutureBuilder<EMMessage?>(
                future: conversation.latestMessage(),
                builder: (context, snapshot) {
                  final message = snapshot.data;
                  return Text(
                    message != null
                        ? _formatTime(DateTime.fromMillisecondsSinceEpoch(message.serverTime))
                        : '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  );
                },
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EMChatPage(
                  conversationId: conversation.id,
                  conversationName: conversation.id,
                  conversationType: conversation.type,
                ),
              ),
            ).then((_) {
              _loadConversations();
            });
          },
        ),
        Divider(
          height: 1,
          color: Colors.grey[200],
        ),
      ],
    );
  }
  
  Widget _buildOriginalConversationItem(BuildContext context, EMConversation conversation, MessageProvider messageProvider) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.id ?? '';
    
    return Column(
      children: [
        Dismissible(
          key: Key(conversation.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('确认删除'),
                content: const Text('确定要删除这个会话吗？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('删除', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            _deleteConversation(conversation.id);
          },
          child: ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: otherUser.avatar != null && otherUser.avatar!.isNotEmpty
                      ? CachedNetworkImageProvider(ImageUtils.buildImageUrl(otherUser.avatar!))
                      : null,
                  child: otherUser.avatar == null || otherUser.avatar!.isEmpty
                      ? Text(
                          otherUser.nickname[0],
                          style: const TextStyle(fontSize: 18),
                        )
                      : null,
                ),
                if (conversation.unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        conversation.unreadCount > 99
                            ? '99+'
                            : conversation.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              otherUser.nickname,
              style: TextStyle(
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              conversation.lastMessage != null
                  ? _getMessagePreview(conversation.lastMessage!)
                  : '暂无消息',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conversation.unreadCount > 0
                    ? Colors.black87
                    : Colors.grey[600],
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.lastMessage != null
                      ? _formatTime(conversation.lastMessage!.createdAt)
                      : '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                if (conversation.unreadCount > 0)
                  const SizedBox(height: 4),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    otherUser: otherUser,
                    conversationId: conversation.id,
                  ),
                ),
              ).then((_) {
                // 返回时刷新会话列表
                _loadConversations();
              });
            },
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey[200],
        ),
      ],
    );
  }
}