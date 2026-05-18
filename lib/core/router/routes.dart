import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'navigationHistory.dart';
import 'package:flutter_app/layout/pc_layout.dart';
import 'package:flutter_app/views/home/home.dart';
import 'package:flutter_app/views/playlist/playlist.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return PcLayout(child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/playlist',
          builder: (context, state) => const PlaylistScreen(),
        ),
      ],
    ),
  ],
);

// 监听路由变化并记录到历史栈
void initRouterListener() {
  // 使用 addListener 监听路由变化
  router.routerDelegate.addListener(() {
    final configuration = router.routerDelegate.currentConfiguration;
    // isNotEmpty 确保 configuration 至少有一个元素，避免空指针异常
    if (configuration.isNotEmpty) {
      final String location = configuration.last.matchedLocation;
      NavigationHistory().push(location);
    }
  });

  // 记录初始位置，确保在第一帧之后执行，避免 configuration 为空
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final configuration = router.routerDelegate.currentConfiguration;
    if (configuration.isNotEmpty) {
      NavigationHistory().push(configuration.last.matchedLocation);
    }
  });
}
