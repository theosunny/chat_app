import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/conversation_model.dart';

part 'conversation_remote_datasource.g.dart';

/// 会话远程数据源接口
abstract class ConversationRemoteDataSource {
  Future<List<ConversationModel>> getConversations(int page, int limit);
  Future<ConversationModel> createConversation(int otherUserId);
  Future<ConversationModel> getConversationById(int conversationId);
  Future<ConversationModel?> getConversationByUserId(int otherUserId);
  Future<void> deleteConversation(int conversationId);
  Future<void> updateLastMessage(int conversationId, int messageId, String content, String timestamp);
  Future<void> updateUnreadCount(int conversationId, int userId, int count);
  Future<void> clearUnreadCount(int conversationId, int userId);
  Future<List<ConversationModel>> searchConversations(String query);
  Future<int> getTotalUnreadCount();
}

/// 会话远程数据源实现
@RestApi()
abstract class ConversationRemoteDataSourceImpl implements ConversationRemoteDataSource {
  factory ConversationRemoteDataSourceImpl(Dio dio, {String baseUrl}) = _ConversationRemoteDataSourceImpl;

  @override
  @GET('/conversations')
  Future<List<ConversationModel>> getConversations(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @override
  @POST('/conversations')
  Future<ConversationModel> createConversation(
    @Field('otherUserId') int otherUserId,
  );

  @override
  @GET('/conversations/{conversationId}')
  Future<ConversationModel> getConversationById(
    @Path('conversationId') int conversationId,
  );

  @override
  @GET('/conversations/user/{userId}')
  Future<ConversationModel?> getConversationByUserId(
    @Path('userId') int otherUserId,
  );

  @override
  @DELETE('/conversations/{conversationId}')
  Future<void> deleteConversation(
    @Path('conversationId') int conversationId,
  );

  @override
  @PUT('/conversations/{conversationId}/last-message')
  Future<void> updateLastMessage(
    @Path('conversationId') int conversationId,
    @Field('messageId') int messageId,
    @Field('content') String content,
    @Field('timestamp') String timestamp,
  );

  @override
  @PUT('/conversations/{conversationId}/unread-count')
  Future<void> updateUnreadCount(
    @Path('conversationId') int conversationId,
    @Field('userId') int userId,
    @Field('count') int count,
  );

  @override
  @PUT('/conversations/{conversationId}/clear-unread')
  Future<void> clearUnreadCount(
    @Path('conversationId') int conversationId,
    @Field('userId') int userId,
  );

  @override
  @GET('/conversations/search')
  Future<List<ConversationModel>> searchConversations(
    @Query('q') String query,
  );

  @override
  @GET('/conversations/total-unread-count')
  Future<int> getTotalUnreadCount();
}