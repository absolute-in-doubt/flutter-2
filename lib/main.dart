import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/movie_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const CineVaultApp());
}

class CineVaultApp extends StatelessWidget {
  const CineVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<MovieCubit>(
          create: (_) => MovieCubit(),
        ),
      ],
      child: const _CineVaultMaterialApp(),
    );
  }
}

class _CineVaultMaterialApp extends StatelessWidget {
  const _CineVaultMaterialApp();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'CineVault',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          // Material 3 light theme (LAB_TASK.md lines 165-179, 206-209)
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.deepOrange,
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            cardTheme: const CardThemeData(
              surfaceTintColor: Colors.transparent,
            ),
          ),
          // Material 3 dark theme
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.deepOrange,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            cardTheme: const CardThemeData(
              surfaceTintColor: Colors.transparent,
            ),
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
