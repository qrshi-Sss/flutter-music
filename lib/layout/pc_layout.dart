import 'package:flutter/material.dart';
import './components/topNavbar.dart';
import './components/asideBar.dart';
import './components/bottomPlayer.dart';

// PC端左右结构
class PcLayout extends StatelessWidget {
  final Widget child;

  const PcLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      body: Row(
        children: [
          const AsideBar(), // 左侧菜单
          // // 右侧内容区域
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const TopNavBar(), // 顶部导航栏
                  Expanded(child: Container(child: child)), // 主内容区域
                  const BottomPlayer(), // 底部播放器
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
