import 'package:flutter/material.dart';

class MovieGenre {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const MovieGenre({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  static const List<MovieGenre> allGenres = [
    MovieGenre(
      id: 'sci-fi',
      name: 'Фантастика',
      icon: Icons.rocket_launch_outlined,
      color: Colors.indigo,
    ),
    MovieGenre(
      id: 'drama',
      name: 'Драма',
      icon: Icons.theater_comedy_outlined,
      color: Colors.deepPurple,
    ),
    MovieGenre(
      id: 'action',
      name: 'Боевик',
      icon: Icons.flash_on_outlined,
      color: Colors.red,
    ),
    MovieGenre(
      id: 'comedy',
      name: 'Комедия',
      icon: Icons.sentiment_very_satisfied_outlined,
      color: Colors.amber,
    ),
    MovieGenre(
      id: 'thriller',
      name: 'Триллер',
      icon: Icons.visibility_outlined,
      color: Colors.blueGrey,
    ),
    MovieGenre(
      id: 'animation',
      name: 'Мультфильм',
      icon: Icons.auto_awesome_outlined,
      color: Colors.teal,
    ),
    MovieGenre(
      id: 'adventure',
      name: 'Приключения',
      icon: Icons.explore_outlined,
      color: Colors.orange,
    ),
  ];

  static MovieGenre findByName(String name) {
    return allGenres.firstWhere(
      (g) => g.name.toLowerCase() == name.toLowerCase() || g.id == name.toLowerCase(),
      orElse: () => const MovieGenre(
        id: 'other',
        name: 'Другое',
        icon: Icons.movie_outlined,
        color: Colors.blue,
      ),
    );
  }
}
