import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../domain/usecases/conversation/get_conversations_usecase.dart';
import '../../../domain/usecases/user/get_current_user_usecase.dart';
import '../conversations/conversations_page.dart';
import '../conversations/cubit/conversations_cubit.dart';
import '../profile/profile_page.dart';
import '../profile/cubit/profile_cubit.dart';
import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              BlocProvider(
                create: (context) => ConversationsCubit(
                  getIt<GetConversationsUseCase>(),
                )..loadConversations(),
                child: const ConversationsPage(),
              ),
              BlocProvider(
                create: (context) => ProfileCubit(
                  getIt<GetCurrentUserUseCase>(),
                )..loadCurrentUser(),
                child: const ProfilePage(),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<HomeCubit>().changeTab(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: '聊天',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: '我的',
              ),
            ],
          ),
        );
      },
    );
  }
}