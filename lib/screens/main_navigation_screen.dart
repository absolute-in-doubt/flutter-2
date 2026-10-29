import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_cubit.dart';
import '../cubit/theme_cubit.dart';
import '../models/movie.dart';
import '../widgets/app_drawer.dart';
import 'add_movie_screen.dart';
import 'movie_list_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';
import 'watchlist_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MovieListScreen(),
    WatchlistScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = const [
    'Каталог фильмов',
    'К просмотру & Избранное',
    'Статистика библиотеки',
    'Профиль & Настройки',
  ];

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == ThemeMode.dark ||
        (themeCubit.state == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Сменить тему оформления',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeCubit.toggleTheme();
            },
          ),
        ],
      ),
      // Drawer implementation (LAB_TASK.md lines 394-432)
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      // Body switches based on selected index
      body: _pages[_selectedIndex],
      // Bottom Navigation Bar implementation (LAB_TASK.md lines 325-390)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Каталог',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'К просмотру',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
      // Floating Action Button with data exchange (LAB_TASK.md lines 297-310)
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Добавить фильм'),
              onPressed: () async {
                final newMovie = await Navigator.push<Movie>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMovieScreen(),
                  ),
                );

                if (!context.mounted) return;

                if (newMovie != null) {
                  context.read<MovieCubit>().addMovie(newMovie);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Фильм "${newMovie.title}" успешно добавлен!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            )
          : null,
    );
  }
}
