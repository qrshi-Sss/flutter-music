import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AsideBar extends StatelessWidget {
  const AsideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Container(
        color: const Color(0xFFF0F0F0),
        child: Column(
          children: [
            // 用户信息
            const UserInfoSection(),
            // 菜单列表
            Expanded(
              child: ListView(
                children: [
                  const MenuItem(icon: Icons.home, title: '首页', route: '/'),
                  const MenuItem(
                    icon: Icons.history,
                    title: '最近播放',
                    route: '/recent',
                  ),
                  const MenuItem(
                    icon: Icons.favorite,
                    title: '我喜欢',
                    route: '/favorite',
                  ),
                  const MenuItem(
                    icon: Icons.download,
                    title: '本地和下载',
                    route: '/download',
                  ),
                  const MenuItem(
                    icon: Icons.list,
                    title: '试听列表',
                    route: '/playlist',
                  ),
                  // 分隔线
                  const Divider(height: 1),
                  // 自建歌单
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '自建歌单',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const MenuItem(
                    icon: Icons.music_note,
                    title: '这是一个歌单',
                    route: '/custom-playlist',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 用户信息区域
class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(radius: 24),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 菜单项
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    // 获取当前路由
    final routeState = GoRouterState.of(context);
    final currentRoute = routeState.uri.path;
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.green : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.green : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFFE8F5E9),
      onTap: () {
        context.go(route);
      },
    );
  }
}
