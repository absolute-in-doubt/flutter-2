import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_cubit.dart';
import '../cubit/movie_state.dart';
import '../models/movie_genre.dart';
import '../widgets/stat_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        final total = state.totalMoviesCount;
        final watched = state.watchedCount;
        final watchedPct = total > 0 ? (watched / total) : 0.0;
        final totalHours = state.totalDurationMinutes ~/ 60;
        final totalMins = state.totalDurationMinutes % 60;
        final watchedHours = state.watchedDurationMinutes ~/ 60;
        final watchedMins = state.watchedDurationMinutes % 60;

        // Top 3 highest rated movies
        final sortedMovies = List.of(state.movies)
          ..sort((a, b) => b.rating.compareTo(a.rating));
        final top3 = sortedMovies.take(3).toList();

        final genreStats = state.genreDistribution;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner with Progress (Stack & Container demonstration)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Прогресс библиотеки',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(watchedPct * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: watchedPct,
                        minHeight: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.amberAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Просмотрено $watched из $total фильмов • $watchedHours ч $watchedMins мин хронометража',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2x2 Grid of StatCards
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                children: [
                  StatCard(
                    title: 'Фильмов в базе',
                    value: '$total',
                    subtitle: 'всего',
                    icon: Icons.movie_outlined,
                    color: Colors.blue,
                  ),
                  StatCard(
                    title: 'Средний рейтинг',
                    value: state.averageRating.toStringAsFixed(1),
                    subtitle: 'из 10',
                    icon: Icons.star_half_rounded,
                    color: Colors.amber,
                  ),
                  StatCard(
                    title: 'Общее время',
                    value: '$totalHours ч $totalMins м',
                    subtitle: 'каталог',
                    icon: Icons.timer_outlined,
                    color: Colors.purple,
                  ),
                  StatCard(
                    title: 'В избранном',
                    value: '${state.favoriteMovies.length}',
                    subtitle: 'любимые',
                    icon: Icons.favorite_outline,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Genre breakdown section
              Text(
                'Распределение по жанрам',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...genreStats.entries.map((entry) {
                final genre = MovieGenre.findByName(entry.key);
                final count = entry.value;
                final percentage = total > 0 ? (count / total) : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(genre.icon, size: 18, color: genre.color),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              '$count (${(percentage * 100).toStringAsFixed(0)}%)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 6,
                            backgroundColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(genre.color),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Top rated movies
              Text(
                'Лидеры по рейтингу',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...top3.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final movie = entry.value;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: idx == 1
                        ? Colors.amber
                        : idx == 2
                            ? Colors.blueGrey.shade300
                            : Colors.brown.shade300,
                    child: Text(
                      '#$idx',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${movie.genre} • ${movie.year}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }
}
