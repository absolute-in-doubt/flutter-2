import '../models/movie.dart';

class MovieState {
  final List<Movie> movies;
  final String? selectedGenre;
  final String searchQuery;

  const MovieState({
    required this.movies,
    this.selectedGenre,
    this.searchQuery = '',
  });

  MovieState copyWith({
    List<Movie>? movies,
    String? selectedGenre,
    bool clearGenre = false,
    String? searchQuery,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      selectedGenre: clearGenre ? null : (selectedGenre ?? this.selectedGenre),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<Movie> get filteredMovies {
    return movies.where((movie) {
      final matchesGenre = selectedGenre == null ||
          selectedGenre!.isEmpty ||
          selectedGenre == 'Все' ||
          movie.genre.toLowerCase() == selectedGenre!.toLowerCase();

      final matchesQuery = searchQuery.trim().isEmpty ||
          movie.title.toLowerCase().contains(searchQuery.toLowerCase().trim()) ||
          movie.director.toLowerCase().contains(searchQuery.toLowerCase().trim()) ||
          movie.genre.toLowerCase().contains(searchQuery.toLowerCase().trim()) ||
          movie.year.toString().contains(searchQuery.trim());

      return matchesGenre && matchesQuery;
    }).toList();
  }

  List<Movie> get favoriteMovies =>
      movies.where((movie) => movie.isFavorite).toList();

  List<Movie> get watchedMovies =>
      movies.where((movie) => movie.isWatched).toList();

  List<Movie> get toWatchMovies =>
      movies.where((movie) => !movie.isWatched).toList();

  int get totalMoviesCount => movies.length;

  int get watchedCount => watchedMovies.length;

  int get totalDurationMinutes =>
      movies.fold(0, (sum, m) => sum + m.durationMinutes);

  int get watchedDurationMinutes =>
      watchedMovies.fold(0, (sum, m) => sum + m.durationMinutes);

  double get averageRating {
    if (movies.isEmpty) return 0.0;
    final total = movies.fold(0.0, (sum, m) => sum + m.rating);
    return total / movies.length;
  }

  Map<String, int> get genreDistribution {
    final map = <String, int>{};
    for (final movie in movies) {
      map[movie.genre] = (map[movie.genre] ?? 0) + 1;
    }
    return map;
  }
}
