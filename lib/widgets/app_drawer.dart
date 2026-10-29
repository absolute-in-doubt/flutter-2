import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/theme_cubit.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == ThemeMode.dark ||
        (themeCubit.state == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.movie_filter_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'CineVault',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Каталог & трекер фильмов',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.movie_outlined),
            title: const Text('Каталог фильмов'),
            selected: selectedIndex == 0,
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_outline),
            title: const Text('К просмотру / Избранное'),
            selected: selectedIndex == 1,
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: const Text('Статистика'),
            selected: selectedIndex == 2,
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Профиль'),
            selected: selectedIndex == 3,
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected(3);
            },
          ),
          const Divider(),
          SwitchListTile(
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Тёмная тема'),
            value: isDark,
            onChanged: (val) {
              themeCubit.toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О приложении'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'CineVault',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.movie_filter, size: 48),
                children: const [
                  Text(
                    'Лабораторная работа №2 по курсу КПМП.\n'
                    'Приложение разработано с использованием Material 3, '
                    'Cubit (flutter_bloc), навигации между экранами и валидации форм.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
