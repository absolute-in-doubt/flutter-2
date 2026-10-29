import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_cubit.dart';
import '../cubit/movie_state.dart';
import '../models/movie.dart';
import '../models/movie_genre.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final genreInfo = MovieGenre.findByName(movie.genre);

    // Read the latest state of this movie from MovieCubit in case it was toggled
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        final currentMovie = state.movies.firstWhere(
          (m) => m.id == movie.id,
          orElse: () => movie,
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Sliver AppBar with banner image and movie icon
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    currentMovie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Backdrop colored gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              genreInfo.color.withValues(alpha: 0.9),
                              theme.colorScheme.surface,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Large genre background watermark
                      Positioned(
                        right: -30,
                        top: 20,
                        child: Icon(
                          genreInfo.icon,
                          size: 200,
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      // Center prominent icon
                      Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            genreInfo.icon,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      currentMovie.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: currentMovie.isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      context.read<MovieCubit>().toggleFavorite(currentMovie.id);
                      final status = currentMovie.isFavorite
                          ? 'Удалено из избранного'
                          : 'Добавлено в избранное';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(status),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Detail content body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick info row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: genreInfo.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: genreInfo.color.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  genreInfo.icon,
                                  size: 16,
                                  color: genreInfo.color,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  currentMovie.genre,
                                  style: TextStyle(
                                    color: genreInfo.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text('${currentMovie.year} г.'),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(currentMovie.durationFormatted),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Rating and Watched banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      currentMovie.rating.toStringAsFixed(1),
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Рейтинг',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: theme.colorScheme.outlineVariant,
                            ),
                            Column(
                              children: [
                                Icon(
                                  currentMovie.isWatched
                                      ? Icons.check_circle
                                      : Icons.pending_actions,
                                  color: currentMovie.isWatched
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 26,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentMovie.isWatched
                                      ? 'Просмотрено'
                                      : 'Не просмотрено',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: currentMovie.isWatched
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Director
                      Text(
                        'Режиссер',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentMovie.director,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Описание и сюжет',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentMovie.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<MovieCubit>()
                                    .toggleWatched(currentMovie.id);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(
                                currentMovie.isWatched
                                    ? Icons.undo
                                    : Icons.done_all,
                              ),
                              label: Text(
                                currentMovie.isWatched
                                    ? 'В список к просмотру'
                                    : 'Отметить просмотренным',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Удаление фильма'),
                                    content: Text(
                                      'Вы действительно хотите удалить "${currentMovie.title}" из каталога?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Отмена'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          context
                                              .read<MovieCubit>()
                                              .deleteMovie(currentMovie.id);
                                          // Return status to caller screen (LAB_TASK.md line 319)
                                          Navigator.pop(
                                            context,
                                            'Фильм "${currentMovie.title}" удален',
                                          );
                                        },
                                        child: const Text(
                                          'Удалить',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.redAccent),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Удалить из библиотеки'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            // Returning result back using Navigator.pop
                            Navigator.pop(
                              context,
                              'Просмотр фильма "${currentMovie.title}" завершен',
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Вернуться назад в каталог'),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
