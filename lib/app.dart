import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'core/router/routes.dart';
import 'core/platform/tray_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// 以下划线开头的类名是私有状态类，表示仅当前文件可见
// with关键字作为Dart的混入使用（将多个类的功能混入到当前类中）
// 这里extends State<MyApp>是为了告诉状态类服务于哪个widget（MyApp），以及访问widget(MyApp)的属性和方法
class _MyAppState extends State<MyApp> {
  final TrayService _trayService = TrayService();

  // 重写State的initState,初始化异步操作（窗口管理器、系统托盘）
  @override
  void initState() {
    super.initState(); //执行父类的initState方法
    initRouterListener(); // 初始化路由监听
    _initAsync(); //自定义的异步初始化方法
  }

  // Future 指将来会返回什么 <void>代表会返回一个空值
  Future<void> _initAsync() async {
    // 初始化窗口管理器
    await windowManager.ensureInitialized();

    // 设置窗口选项
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 800), // 窗口大小
      center: true, // 居中显示
      backgroundColor: Colors.transparent,
      skipTaskbar: false, // 不跳过任务栏
      titleBarStyle: TitleBarStyle.hidden, // 隐藏标题栏
    );

    // 设置窗口关闭行为（最小化到托盘）
    windowManager.setPreventClose(true);

    // 等待窗口创建
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setHasShadow(true);
    });

    // 初始化系统托盘
    await _trayService.init();

    // 添加监听器
    trayManager.addListener(_trayService);
    windowManager.addListener(_trayService);
  }

  @override
  void dispose() {
    trayManager.removeListener(_trayService);
    windowManager.removeListener(_trayService);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // 必填参数，路由配置
      routerConfig: router,

      // 常用参数
      // 隐藏调试模式banner
      debugShowCheckedModeBanner: false,
      // 主题配置
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: Colors.white, // 确保 Scaffold 背景是白色
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionsBuilder(),
            TargetPlatform.windows: NoTransitionsBuilder(),
            TargetPlatform.macOS: NoTransitionsBuilder(),
            TargetPlatform.linux: NoTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
