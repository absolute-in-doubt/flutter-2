import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_cubit.dart';
import '../cubit/movie_state.dart';
import '../models/movie_genre.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        final movies = state.filteredMovies;
        final selectedGenre = state.selectedGenre;

        return Column(
          children: [
            // Search Bar Container
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск по названию, режиссеру, году...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<MovieCubit>().search('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  context.read<MovieCubit>().search(value);
                },
              ),
            ),

            // Horizontal Genre Chips Filter
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: selectedGenre == null || selectedGenre == 'Все',
                      label: const Text('Все фильмы'),
                      onSelected: (_) {
                        context.read<MovieCubit>().selectGenre(null);
                      },
                    ),
                  ),
                  ...MovieGenre.allGenres.map((genre) {
                    final isSelected = selectedGenre == genre.name;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        avatar: Icon(
                          genre.icon,
                          size: 16,
                          color: isSelected
                              ? theme.colorScheme.onSecondaryContainer
                              : genre.color,
                        ),
                        selected: isSelected,
                        label: Text(genre.name),
                        onSelected: (_) {
                          context
                              .read<MovieCubit>()
                              .selectGenre(isSelected ? null : genre.name);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Results count badge
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Фильмы (${movies.length})',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (state.searchQuery.isNotEmpty || selectedGenre != null)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        context.read<MovieCubit>().search('');
                        context.read<MovieCubit>().selectGenre(null);
                      },
                      child: const Text('Сбросить фильтры'),
                    ),
                ],
              ),
            ),

            // Movie List View
            Expanded(
              child: movies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Фильмы не найдены',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Попробуйте изменить поисковый запрос или фильтр',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: movies.length,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemBuilder: (context, index) {
                        return MovieCard(movie: movies[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
