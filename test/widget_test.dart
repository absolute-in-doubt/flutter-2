import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2_1/main.dart';
import 'package:flutter_application_2_1/cubit/movie_cubit.dart';
import 'package:flutter_application_2_1/models/movie.dart';

void main() {
  group('CineVault Widget & Navigation Tests', () {
    testWidgets('Renders app title and initial movie catalog', (WidgetTester tester) async {
      await tester.pumpWidget(const CineVaultApp());
      await tester.pumpAndSettle();

      // Verify AppBar title
      expect(find.text('Каталог фильмов'), findsOneWidget);

      // Verify some initial movies are present
      expect(find.text('Интерстеллар'), findsOneWidget);
      expect(find.text('Начало'), findsOneWidget);

      // Verify search input is present
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Switches tabs using NavigationBar', (WidgetTester tester) async {
      await tester.pumpWidget(const CineVaultApp());
      await tester.pumpAndSettle();

      // Tap on "К просмотру"
      await tester.tap(find.text('К просмотру'));
      await tester.pumpAndSettle();
      expect(find.text('К просмотру & Избранное'), findsOneWidget);

      // Tap on "Статистика"
      await tester.tap(find.text('Статистика'));
      await tester.pumpAndSettle();
      expect(find.text('Статистика библиотеки'), findsOneWidget);
      expect(find.text('Прогресс библиотеки'), findsOneWidget);

      // Tap on "Профиль"
      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      expect(find.text('Профиль & Настройки'), findsOneWidget);
      expect(find.text('Кинолюбитель'), findsOneWidget);
    });

    testWidgets('Opens AddMovieScreen and validates form', (WidgetTester tester) async {
      await tester.pumpWidget(const CineVaultApp());
      await tester.pumpAndSettle();

      // Tap FAB "Добавить фильм"
      await tester.tap(find.text('Добавить фильм'));
      await tester.pumpAndSettle();

      // Verify screen title and presence of form fields
      expect(find.text('Добавить новый фильм'), findsOneWidget);
      final saveBtn = find.text('Сохранить фильм');
      await tester.ensureVisible(saveBtn);
      await tester.pumpAndSettle();

      // Try submitting empty form
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Expect validation error
      expect(find.text('Пожалуйста, введите название фильма'), findsOneWidget);
    });
  });

  group('MovieCubit Unit Tests', () {
    test('Initial state contains 6 sample movies', () {
      final cubit = MovieCubit();
      expect(cubit.state.movies.length, 6);
      expect(cubit.state.watchedCount, 4);
    });

    test('addMovie prepends new movie', () {
      final cubit = MovieCubit();
      const testMovie = Movie(
        id: 'test-1',
        title: 'Тестовый фильм',
        director: 'Тестовый режиссер',
        genre: 'Фантастика',
        year: 2026,
        durationMinutes: 100,
        rating: 9.0,
        description: 'Описание тестового фильма для проверки кубита.',
      );

      cubit.addMovie(testMovie);
      expect(cubit.state.movies.length, 7);
      expect(cubit.state.movies.first.title, 'Тестовый фильм');
    });

    test('toggleFavorite updates favorite flag', () {
      final cubit = MovieCubit();
      final target = cubit.state.movies.firstWhere((m) => !m.isFavorite);
      cubit.toggleFavorite(target.id);
      expect(cubit.state.movies.firstWhere((m) => m.id == target.id).isFavorite, true);
    });

    test('toggleWatched updates watched flag', () {
      final cubit = MovieCubit();
      final target = cubit.state.movies.first;
      final initialWatched = target.isWatched;
      cubit.toggleWatched(target.id);
      expect(cubit.state.movies.firstWhere((m) => m.id == target.id).isWatched, !initialWatched);
    });

    test('deleteMovie removes movie by id', () {
      final cubit = MovieCubit();
      cubit.deleteMovie('1');
      expect(cubit.state.movies.any((m) => m.id == '1'), false);
      expect(cubit.state.movies.length, 5);
    });
  });
}
