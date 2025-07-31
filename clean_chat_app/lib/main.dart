import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化 Hive
  await Hive.initFlutter();
  
  // 打开 Hive boxes
  await Hive.openBox<Map<dynamic, dynamic>>('userBox');
  await Hive.openBox<List<dynamic>>('userListBox');
  await Hive.openBox<Map<dynamic, dynamic>>('messageBox');
  await Hive.openBox<Map<dynamic, dynamic>>('conversationBox');
  
  // 初始化 SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // 初始化依赖注入
  await configureDependencies(sharedPreferences);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Chat App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}