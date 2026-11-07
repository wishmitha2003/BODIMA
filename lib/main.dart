import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';

void main() {
  runApp(const BodimaApp());
}

class BodimaApp extends StatelessWidget {
  const BodimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BODIMA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
