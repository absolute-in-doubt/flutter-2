import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/movie.dart';
import 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieState(movies: Movie.initialMovies));

  void addMovie(Movie movie) {
    final updatedList = List<Movie>.from(state.movies)..insert(0, movie);
    emit(state.copyWith(movies: updatedList));
  }

  void updateMovie(Movie movie) {
    final updatedList = state.movies.map((m) {
      return m.id == movie.id ? movie : m;
    }).toList();
    emit(state.copyWith(movies: updatedList));
  }

  void deleteMovie(String id) {
    final updatedList = state.movies.where((m) => m.id != id).toList();
    emit(state.copyWith(movies: updatedList));
  }

  void toggleFavorite(String id) {
    final updatedList = state.movies.map((m) {
      if (m.id == id) {
        return m.copyWith(isFavorite: !m.isFavorite);
      }
      return m;
    }).toList();
    emit(state.copyWith(movies: updatedList));
  }

  void toggleWatched(String id) {
    final updatedList = state.movies.map((m) {
      if (m.id == id) {
        return m.copyWith(isWatched: !m.isWatched);
      }
      return m;
    }).toList();
    emit(state.copyWith(movies: updatedList));
  }

  void selectGenre(String? genre) {
    if (genre == null || genre == 'Все') {
      emit(state.copyWith(clearGenre: true));
    } else {
      emit(state.copyWith(selectedGenre: genre));
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void resetToDefaults() {
    emit(MovieState(movies: Movie.initialMovies));
  }
}
