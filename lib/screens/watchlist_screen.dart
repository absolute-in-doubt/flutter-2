import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_cubit.dart';
import '../cubit/movie_state.dart';
import '../widgets/movie_card.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  int _selectedTab = 0; // 0: Избранное, 1: К просмотру

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        final currentList = _selectedTab == 0
            ? state.favoriteMovies
            : state.toWatchMovies;

        return Column(
          children: [
            // Segmented switch
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SegmentedButton<int>(
                segments: [
                  ButtonSegment<int>(
                    value: 0,
                    icon: const Icon(Icons.favorite),
                    label: Text('Избранное (${state.favoriteMovies.length})'),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    icon: const Icon(Icons.bookmark_added_outlined),
                    label: Text('К просмотру (${state.toWatchMovies.length})'),
                  ),
                ],
                selected: {_selectedTab},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    _selectedTab = newSelection.first;
                  });
                },
              ),
            ),

            // Content list
            Expanded(
              child: currentList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedTab == 0
                                ? Icons.favorite_border_rounded
                                : Icons.bookmark_border_rounded,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedTab == 0
                                ? 'Список избранного пуст'
                                : 'Все запланированные фильмы просмотрены!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              _selectedTab == 0
                                  ? 'Нажмите на иконку сердечка на карточке любого фильма, чтобы добавить его сюда.'
                                  : 'Добавляйте новые фильмы или снимайте отметку "Просмотрено" в деталях фильма.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: currentList.length,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemBuilder: (context, index) {
                        return MovieCard(movie: currentList[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
