import 'package:flutter/material.dart';

class NavigationHistory extends ChangeNotifier {
  static final NavigationHistory _instance = NavigationHistory._internal();
  factory NavigationHistory() => _instance;
  NavigationHistory._internal(); // 私有构造函数，防止外部实例化

  final List<String> _history = [];
  int _currentIndex = -1;

  // 页面跳转时调用
  void push(String routeName) {
    // 如果跳转的页面和当前页面相同，则不处理
    if (_currentIndex >= 0 && _history[_currentIndex] == routeName) {
      return;
    }
    // 移除当前位置之后的历史（实现标准浏览器行为）
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }
    _history.add(routeName);
    _currentIndex++;
    notifyListeners();
  }

  // 后退
  String? pop() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
      return _history[_currentIndex];
    }
    return null;
  }

  // 前进
  String? forward() {
    if (_currentIndex < _history.length - 1) {
      _currentIndex++;
      notifyListeners();
      return _history[_currentIndex];
    }
    return null;
  }

  // 能否后退
  bool canPop() => _currentIndex > 0;

  // 能否前进
  bool canForward() => _currentIndex < _history.length - 1;

  // 打印历史（调试用）
  void printHistory() {
    print('历史: $_history');
    print('当前位置: $_currentIndex');
  }
}
