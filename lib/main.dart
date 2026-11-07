import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/app/presentation/app_shell.dart';

void main() {
  runApp(const BodimaApp());
}

class BodimaApp extends StatelessWidget {
  const BodimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'BODIMA',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: const AppShell(),
        );
      },
    );
  }
}
