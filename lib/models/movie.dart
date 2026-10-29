class Movie {
  final String id;
  final String title;
  final String director;
  final String genre;
  final int year;
  final int durationMinutes;
  final double rating;
  final String description;
  final bool isFavorite;
  final bool isWatched;

  const Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.genre,
    required this.year,
    required this.durationMinutes,
    required this.rating,
    required this.description,
    this.isFavorite = false,
    this.isWatched = false,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? director,
    String? genre,
    int? year,
    int? durationMinutes,
    double? rating,
    String? description,
    bool? isFavorite,
    bool? isWatched,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isWatched: isWatched ?? this.isWatched,
    );
  }

  String get durationFormatted {
    final hours = durationMinutes ~/ 60;
    final mins = durationMinutes % 60;
    if (hours == 0) return '$mins мин';
    if (mins == 0) return '$hours ч';
    return '$hours ч $mins мин';
  }

  static List<Movie> get initialMovies => [
        const Movie(
          id: '1',
          title: 'Интерстеллар',
          director: 'Кристофер Нолан',
          genre: 'Фантастика',
          year: 2014,
          durationMinutes: 169,
          rating: 8.7,
          description:
              'Когда засуха, пыльные бури и вымирание растений приводят человечество к продовольственному кризису, коллектив исследователей и учёных отправляется сквозь червоточину в поисках нового дома для человечества.',
          isFavorite: true,
          isWatched: true,
        ),
        const Movie(
          id: '2',
          title: 'Начало',
          director: 'Кристофер Нолан',
          genre: 'Фантастика',
          year: 2010,
          durationMinutes: 148,
          rating: 8.8,
          description:
              'Кобб — непревзойденный вор в искусстве извлечения ценных секретов из глубин подсознания во время сна. Ему предстоит совершить невозможное: не украсть мысль, а внедрить новую.',
          isFavorite: true,
          isWatched: true,
        ),
        const Movie(
          id: '3',
          title: 'Побег из Шоушенка',
          director: 'Фрэнк Дарабонт',
          genre: 'Драма',
          year: 1994,
          durationMinutes: 142,
          rating: 9.3,
          description:
              'Успешный банкир Энди Дюфрейн несправедливо обвинен в убийстве собственной жены и ее любовника. Оказавшись в тюрьме Шоушенк, он сохраняет надежду и силу духа вопреки жестокости заключения.',
          isFavorite: false,
          isWatched: true,
        ),
        const Movie(
          id: '4',
          title: 'Криминальное чтиво',
          director: 'Квентин Тарантино',
          genre: 'Триллер',
          year: 1994,
          durationMinutes: 154,
          rating: 8.9,
          description:
              'Нелинейная криминальная сага о двух бандитах Винсенте Веге и Джулсе Виннфилде, жене криминального авторитета, боксере и незадачливой парочке грабителей закусочной.',
          isFavorite: false,
          isWatched: false,
        ),
        const Movie(
          id: '5',
          title: 'Унесённые призраками',
          director: 'Хаяо Миядзаки',
          genre: 'Мультфильм',
          year: 2001,
          durationMinutes: 125,
          rating: 8.6,
          description:
              'Маленькая Тихиро вместе с родителями переезжает в новый дом. Заблудившись в пути, они оказываются в таинственном заброшенном городке, где правит колдунья Юбаба.',
          isFavorite: true,
          isWatched: false,
        ),
        const Movie(
          id: '6',
          title: 'Тёмный рыцарь',
          director: 'Кристофер Нолан',
          genre: 'Боевик',
          year: 2008,
          durationMinutes: 152,
          rating: 9.0,
          description:
              'Бэтмен поднимает ставки в войне с криминалом. С помощью лейтенанта Джима Гордона и прокурора Харви Дента он намерен очистить улицы Готэма, пока не объявляется Джокер.',
          isFavorite: false,
          isWatched: true,
        ),
      ];
}
