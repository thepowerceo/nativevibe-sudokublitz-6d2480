import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_blitz/config/routes.dart';
import 'package:sudoku_blitz/providers/app_provider.dart';
import 'package:sudoku_blitz/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: AppProviders.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SudokuBlitz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Can be changed to ThemeMode.dark or ThemeMode.light
      routerConfig: AppRouter.router,
    );
  }
}