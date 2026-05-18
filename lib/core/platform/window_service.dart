import 'package:window_manager/window_manager.dart';

/// 窗口管理服务
class WindowService {
  static final WindowService _instance = WindowService._internal();
  factory WindowService() => _instance;
  WindowService._internal();

  /// 初始化窗口管理器
  Future<void> initialize() async {
    await windowManager.ensureInitialized();
  }

  /// 最小化到托盘（隐藏窗口）
  Future<void> minimizeToTray() async {
    try {
      await windowManager.hide();
      print('窗口已最小化到托盘');
    } catch (e) {
      print('最小化到托盘失败: $e');
      rethrow;
    }
  }

  /// 最小化窗口
  Future<void> minimizeWindow() async {
    try {
      await windowManager.minimize();
      print('窗口已最小化');
    } catch (e) {
      print('最小化窗口失败: $e');
      rethrow;
    }
  }

  /// 最大化窗口
  Future<void> maximizeWindow() async {
    try {
      await windowManager.maximize();
      print('窗口已最大化');
    } catch (e) {
      print('最大化窗口失败: $e');
      rethrow;
    }
  }

  /// 还原窗口
  Future<void> unmaximizeWindow() async {
    try {
      await windowManager.unmaximize();
      print('窗口已还原');
    } catch (e) {
      print('还原窗口失败: $e');
      rethrow;
    }
  }

  /// 切换窗口大小（最大化/还原）
  Future<void> toggleWindowSize() async {
    try {
      bool isMaximized = await windowManager.isMaximized();
      if (isMaximized) {
        await unmaximizeWindow();
      } else {
        await maximizeWindow();
      }
    } catch (e) {
      print('切换窗口大小失败: $e');
      rethrow;
    }
  }

  /// 关闭窗口
  Future<void> closeWindow() async {
    try {
      await windowManager.close();
      print('窗口已关闭');
    } catch (e) {
      print('关闭窗口失败: $e');
      rethrow;
    }
  }

  /// 检查窗口是否最大化
  Future<bool> isWindowMaximized() async {
    try {
      return await windowManager.isMaximized();
    } catch (e) {
      print('检查窗口状态失败: $e');
      return false;
    }
  }

  /// 设置窗口可关闭（用于托盘菜单的退出功能）
  Future<void> setPreventClose(bool prevent) async {
    try {
      windowManager.setPreventClose(prevent);
    } catch (e) {
      print('设置窗口关闭行为失败: $e');
      rethrow;
    }
  }
}