import 'dart:io';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

/// 系统托盘服务 - 合并了管理和监听功能
class TrayService with TrayListener, WindowListener {
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;
  TrayService._internal();

  /// 初始化系统托盘
  Future<void> init() async {
    try {
      // 尝试设置托盘图标
      try {
        await trayManager.setIcon(
          Platform.isWindows
              ? 'assets/images/tray_icon.ico'
              : 'assets/images/tray_icon.png',
        );
      } catch (e) {
        print('设置托盘图标失败，将使用默认图标: $e');
      }

      // 设置托盘提示文本
      await trayManager.setToolTip('音乐播放器');

      // 创建上下文菜单
      final menu = Menu(
        items: [
          MenuItem(key: 'show_hide', label: '显示/隐藏窗口'),
          MenuItem(key: 'play_pause', label: '播放/暂停'),
          MenuItem(key: 'next_track', label: '下一首'),
          MenuItem(key: 'previous_track', label: '上一首'),
          MenuItem.separator(),
          MenuItem(key: 'volume_up', label: '音量增加'),
          MenuItem(key: 'volume_down', label: '音量减少'),
          MenuItem.separator(),
          MenuItem(key: 'quit', label: '退出应用'),
        ],
      );

      // 设置上下文菜单
      await trayManager.setContextMenu(menu);

      print('系统托盘初始化完成');
    } catch (e) {
      print('初始化系统托盘失败: $e');
    }
  }

  /// 显示/隐藏主窗口
  Future<void> toggleWindowVisibility() async {
    if (await windowManager.isVisible()) {
      await windowManager.hide();
    } else {
      await windowManager.show();
      await windowManager.focus();
    }
  }

  /// 退出应用
  Future<void> quitApp() async {
    await trayManager.destroy();
    exit(0);
  }

  /// 弹出上下文菜单
  Future<void> popUpContextMenu() async {
    await trayManager.popUpContextMenu();
  }

  // ========== 托盘事件监听器方法 ==========

  @override
  void onTrayIconMouseDown() {
    // 左键点击托盘图标时显示/隐藏窗口
    toggleWindowVisibility();
  }

  @override
  void onTrayIconRightMouseDown() async {
    // 右键点击托盘图标时弹出菜单
    // 在弹出前强制获取一次焦点，确保 Windows 系统下菜单在点击外部时能正常隐藏
    await windowManager.focus();
    await popUpContextMenu();
  }

  @override
  void onWindowClose() async {
    // 点击关闭按钮时最小化到托盘而不是退出
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      await windowManager.hide();
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_hide':
        toggleWindowVisibility();
        break;
      case 'play_pause':
        _handlePlayPause();
        break;
      case 'next_track':
        _handleNextTrack();
        break;
      case 'previous_track':
        _handlePreviousTrack();
        break;
      case 'volume_up':
        _handleVolumeUp();
        break;
      case 'volume_down':
        _handleVolumeDown();
        break;
      case 'quit':
        quitApp();
        break;
    }
  }

  // ========== 业务逻辑处理方法 ==========

  /// 处理播放/暂停
  void _handlePlayPause() {
    // TODO: 实现播放/暂停逻辑
    print('播放/暂停');
  }

  /// 处理下一首
  void _handleNextTrack() {
    // TODO: 实现下一首逻辑
    print('下一首');
  }

  /// 处理上一首
  void _handlePreviousTrack() {
    // TODO: 实现上一首逻辑
    print('上一首');
  }

  /// 处理音量增加
  void _handleVolumeUp() {
    // TODO: 实现音量增加逻辑
    print('音量增加');
  }

  /// 处理音量减少
  void _handleVolumeDown() {
    // TODO: 实现音量减少逻辑
    print('音量减少');
  }
}
