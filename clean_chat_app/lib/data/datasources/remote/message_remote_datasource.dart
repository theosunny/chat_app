import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/message_model.dart';

part 'message_remote_datasource.g.dart';

/// 消息远程数据源接口
abstract class MessageRemoteDataSource {
  Future<MessageModel> sendMessage(int conversationId, int receiverId, String content, String messageType);
  Future<List<MessageModel>> getMessages(int conversationId, int page, int limit);
  Future<void> markMessageAsRead(int messageId);
  Future<void> markConversationAsRead(int conversationId);
  Future<void> deleteMessage(int messageId);
  Future<int> getUnreadMessageCount();
  Future<List<MessageModel>> searchMessages(String query, int? conversationId, int page, int limit);
  Future<List<MessageModel>> getLatestMessages(int limit);
}

/// 消息远程数据源实现
@RestApi()
abstract class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  factory MessageRemoteDataSourceImpl(Dio dio, {String baseUrl}) = _MessageRemoteDataSourceImpl;

  @override
  @POST('/messages')
  Future<MessageModel> sendMessage(
    @Field('conversationId') int conversationId,
    @Field('receiverId') int receiverId,
    @Field('content') String content,
    @Field('messageType') String messageType,
  );

  @override
  @GET('/conversations/{conversationId}/messages')
  Future<List<MessageModel>> getMessages(
    @Path('conversationId') int conversationId,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @override
  @PUT('/messages/{messageId}/read')
  Future<void> markMessageAsRead(@Path('messageId') int messageId);

  @override
  @PUT('/conversations/{conversationId}/read')
  Future<void> markConversationAsRead(@Path('conversationId') int conversationId);

  @override
  @DELETE('/messages/{messageId}')
  Future<void> deleteMessage(@Path('messageId') int messageId);

  @override
  @GET('/messages/unread-count')
  Future<int> getUnreadMessageCount();

  @override
  @GET('/messages/search')
  Future<List<MessageModel>> searchMessages(
    @Query('q') String query,
    @Query('conversationId') int? conversationId,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @override
  @GET('/messages/latest')
  Future<List<MessageModel>> getLatestMessages(@Query('limit') int limit);
}