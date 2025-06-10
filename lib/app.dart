import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'routes/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/shared/screens/splash_screen.dart';

class LanaYaGoApp extends StatelessWidget {
  const LanaYaGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🚚 LanaYaGo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}