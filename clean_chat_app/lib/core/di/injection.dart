import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../network/dio_client.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/message/send_message_usecase.dart';
import '../../domain/usecases/message/get_messages_usecase.dart';
import '../../domain/usecases/conversation/get_conversations_usecase.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/message_repository.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../data/repositories/conversation_repository_impl.dart';
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/datasources/remote/message_remote_datasource.dart';
import '../../data/datasources/remote/conversation_remote_datasource.dart';
import '../../data/datasources/local/user_local_datasource.dart';
import '../../data/datasources/local/message_local_datasource.dart';
import '../../data/datasources/local/conversation_local_datasource.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // 初始化Hive
  await Hive.initFlutter();
  
  // 注册SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // 注册Hive Boxes
  final userBox = await Hive.openBox(AppConfig.userBoxName);
  final messageBox = await Hive.openBox(AppConfig.messageBoxName);
  final conversationBox = await Hive.openBox(AppConfig.conversationBoxName);
  
  getIt.registerSingleton<Box>(userBox, instanceName: 'userBox');
  getIt.registerSingleton<Box>(messageBox, instanceName: 'messageBox');
  getIt.registerSingleton<Box>(conversationBox, instanceName: 'conversationBox');
  
  // 注册网络客户端
  getIt.registerSingleton<DioClient>(DioClient());
  
  // 注册远程数据源
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<ConversationRemoteDataSource>(
    () => ConversationRemoteDataSourceImpl(getIt<DioClient>().dio),
  );
  
  // 注册本地数据源
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
      userBox: getIt<Box<Map<dynamic, dynamic>>>(instanceName: 'userBox'),
      userListBox: getIt<Box<List<dynamic>>>(instanceName: 'userListBox'),
    ),
  );
  getIt.registerLazySingleton<MessageLocalDataSource>(
    () => MessageLocalDataSourceImpl(
      messageBox: getIt<Box<Map<dynamic, dynamic>>>(instanceName: 'messageBox'),
    ),
  );
  getIt.registerLazySingleton<ConversationLocalDataSource>(
    () => ConversationLocalDataSourceImpl(
      conversationBox: getIt<Box<Map<dynamic, dynamic>>>(instanceName: 'conversationBox'),
    ),
  );
  
  // 注册仓库
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt<UserRemoteDataSource>(),
      localDataSource: getIt<UserLocalDataSource>(),
    ),
  );
  
  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(
      remoteDataSource: getIt<MessageRemoteDataSource>(),
      localDataSource: getIt<MessageLocalDataSource>(),
    ),
  );
  
  getIt.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(
      remoteDataSource: getIt<ConversationRemoteDataSource>(),
      localDataSource: getIt<ConversationLocalDataSource>(),
    ),
  );
  
  // 注册用例
  getIt.registerLazySingleton(() => LoginUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => SendMessageUseCase(
    getIt<MessageRepository>(),
    getIt<ConversationRepository>(),
  ));
  getIt.registerLazySingleton(() => GetMessagesUseCase(getIt<MessageRepository>()));
  getIt.registerLazySingleton(() => GetConversationsUseCase(getIt<ConversationRepository>()));
}
}