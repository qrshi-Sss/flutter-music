import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  // 入口一般做一些初始化工作
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
