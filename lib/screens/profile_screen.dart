import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_cubit.dart';
import '../cubit/theme_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == ThemeMode.dark ||
        (themeCubit.state == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          // User Avatar & Card
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 54,
                  color: theme.colorScheme.primary,
                ),
              ),
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Кинолюбитель',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Студент БГУИР • КПМП Лаб. №2',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Settings Section
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: isDark ? Colors.amber : Colors.orange,
                  ),
                  title: const Text('Тёмный режим оформления'),
                  subtitle: Text(isDark ? 'Включена тёмная тема' : 'Включена светлая тема'),
                  value: isDark,
                  onChanged: (val) {
                    themeCubit.toggleTheme();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Дизайн-система'),
                  subtitle: const Text('Material 3 (M3) с динамическим Seed Color'),
                  trailing: const Icon(Icons.check, color: Colors.green),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.architecture_outlined),
                  title: const Text('Архитектура и состояние'),
                  subtitle: const Text('Cubit (flutter_bloc) + Navigator'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Management Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restore_page_outlined, color: Colors.blue),
                  title: const Text('Сбросить каталог к начальным данным'),
                  subtitle: const Text('Восстановить демонстрационные 6 фильмов'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Восстановление данных'),
                        content: const Text(
                          'Вы уверены, что хотите сбросить базу фильмов к начальному состоянию?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<MovieCubit>().resetToDefaults();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Каталог успешно сброшен к начальному набору!'),
                                ),
                              );
                            },
                            child: const Text('Сбросить'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.teal),
                  title: const Text('О приложении CineVault'),
                  subtitle: const Text('Версия 1.0.0 • Лабораторная работа'),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'CineVault',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.movie_filter, size: 48),
                      applicationLegalese: 'Разработано в рамках лабораторной работы по курсу КПМП.',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
