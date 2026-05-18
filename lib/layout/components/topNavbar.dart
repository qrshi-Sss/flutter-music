import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import '../../core/platform/window_service.dart';
import '../../core/router/navigationHistory.dart';

class TopNavBar extends StatefulWidget {
  const TopNavBar({super.key});

  @override
  State<TopNavBar> createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  final NavigationHistory _navHistory = NavigationHistory();

  @override
  void initState() {
    super.initState();
    _navHistory.addListener(_onNavChanged);
  }

  @override
  void dispose() {
    _navHistory.removeListener(_onNavChanged);
    super.dispose();
  }

  void _onNavChanged() {
    // mounted是widget是否挂载到树上，避免在dispose销毁后调用setState造成异常
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          // 背景拖拽区域 - 覆盖除右侧控制按钮外的区域
          const Positioned.fill(
            right: 120, // 避开右侧控制按钮区域
            child: DragToMoveArea(child: SizedBox.expand()),
          ),
          // 内容区域 - 放在拖拽区域上方，但不作为其子组件
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左侧按钮和搜索框
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _navHistory.canPop()
                          ? () {
                              final route = _navHistory.pop();
                              if (route != null) context.go(route);
                            }
                          : null,
                      style: IconButton.styleFrom(
                        enabledMouseCursor: SystemMouseCursors.click,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _navHistory.canForward()
                          ? () {
                              final route = _navHistory.forward();
                              if (route != null) context.go(route);
                            }
                          : null,
                      style: IconButton.styleFrom(
                        enabledMouseCursor: SystemMouseCursors.click,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // 搜索框
                    Container(
                      width: 400,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: '搜索',
                          prefixIcon: Icon(Icons.search, size: 18),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                // 右侧按钮区域
                const WindowControlButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 窗口控制按钮组件
class WindowControlButtons extends StatefulWidget {
  const WindowControlButtons({super.key});

  @override
  State<WindowControlButtons> createState() => _WindowControlButtonsState();
}

class _WindowControlButtonsState extends State<WindowControlButtons> {
  final WindowService _windowService = WindowService();
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    // 延迟检查窗口状态，避免在布局过程中触发setState
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _checkWindowState();
    // });
  }

  // 检查窗口状态
  Future<void> _checkWindowState() async {
    try {
      _isMaximized = await _windowService.isWindowMaximized();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('检查窗口状态失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 18),
          onPressed: _minimizeWindow,
          style: IconButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
        ),
        IconButton(
          icon: _isMaximized
              ? const Icon(Icons.filter_none, size: 18)
              : const Icon(Icons.crop_square, size: 18),
          onPressed: _toggleWindowSize,
          style: IconButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: _minimizeToTray,
          style: IconButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
        ),
      ],
    );
  }

  /// 最小化到托盘
  Future<void> _minimizeToTray() async {
    try {
      await _windowService.minimizeToTray();
    } catch (e) {
      print('最小化到托盘失败: $e');
    }
  }

  /// 最小化窗口
  Future<void> _minimizeWindow() async {
    try {
      await _windowService.minimizeWindow();
    } catch (e) {
      print('最小化窗口失败: $e');
    }
  }

  /// 切换窗口大小（最大化/还原）
  Future<void> _toggleWindowSize() async {
    try {
      await _windowService.toggleWindowSize();
      // 更新状态
      await _checkWindowState();
    } catch (e) {
      print('切换窗口大小失败: $e');
    }
  }

  /// 关闭窗口
  Future<void> _closeWindow() async {
    try {
      // 先设置允许关闭，然后关闭窗口
      await _windowService.setPreventClose(false);
      await _windowService.closeWindow();
    } catch (e) {
      print('关闭窗口失败: $e');
      // 恢复防止关闭
      await _windowService.setPreventClose(true);
    }
  }
}
