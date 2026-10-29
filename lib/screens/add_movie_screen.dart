import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/movie_genre.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _directorController = TextEditingController();
  final _yearController = TextEditingController(text: DateTime.now().year.toString());
  final _durationController = TextEditingController(text: '120');
  final _descriptionController = TextEditingController();

  String _selectedGenre = 'Фантастика';
  double _rating = 7.5;
  bool _isWatched = false;
  bool _isFavorite = false;

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newMovie = Movie(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        director: _directorController.text.trim(),
        genre: _selectedGenre,
        year: int.parse(_yearController.text.trim()),
        durationMinutes: int.parse(_durationController.text.trim()),
        rating: double.parse(_rating.toStringAsFixed(1)),
        description: _descriptionController.text.trim(),
        isWatched: _isWatched,
        isFavorite: _isFavorite,
      );

      // Return newly created movie back to caller screen via Navigator.pop
      // (Demonstrating Navigator.pop(context, result) from LAB_TASK.md line 317)
      Navigator.pop(context, newMovie);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _directorController.clear();
    _yearController.text = DateTime.now().year.toString();
    _durationController.text = '120';
    _descriptionController.clear();
    setState(() {
      _selectedGenre = 'Фантастика';
      _rating = 7.5;
      _isWatched = false;
      _isFavorite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить новый фильм'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Очистить форму',
            onPressed: _resetForm,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.movie_creation_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Заполните поля формы для добавления фильма в локальную библиотеку CineVault.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Название фильма *',
                    hintText: 'Например, Бегущий по лезвию 2049',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите название фильма';
                    }
                    if (value.trim().length < 2) {
                      return 'Название должно содержать не менее 2 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Director
                TextFormField(
                  controller: _directorController,
                  decoration: const InputDecoration(
                    labelText: 'Режиссер *',
                    hintText: 'Например, Дени Вильнёв',
                    prefixIcon: Icon(Icons.person_pin_outlined),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, укажите режиссера';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Genre dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedGenre,
                  decoration: const InputDecoration(
                    labelText: 'Жанр *',
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: MovieGenre.allGenres.map((g) {
                    return DropdownMenuItem<String>(
                      value: g.name,
                      child: Row(
                        children: [
                          Icon(g.icon, size: 18, color: g.color),
                          const SizedBox(width: 8),
                          Text(g.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedGenre = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Year and Duration in Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Год выпуска *',
                          prefixIcon: Icon(Icons.calendar_month_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Укажите год';
                          }
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null || parsed < 1888 || parsed > 2035) {
                            return '1888–2035';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Хронометраж (мин) *',
                          prefixIcon: Icon(Icons.timer_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Укажите минуты';
                          }
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null || parsed <= 0 || parsed > 1000) {
                            return 'От 1 до 1000';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Rating Slider with preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Оценка / Рейтинг:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_rating.toStringAsFixed(1)} / 10',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _rating,
                        min: 1.0,
                        max: 10.0,
                        divisions: 90,
                        label: _rating.toStringAsFixed(1),
                        onChanged: (val) {
                          setState(() {
                            _rating = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Описание и сюжет *',
                    hintText: 'Краткий синопсис, основные персонажи и завязка сюжета...',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Icon(Icons.description_outlined),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите описание фильма';
                    }
                    if (value.trim().length < 10) {
                      return 'Описание должно быть информативным (минимум 10 знаков)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Toggles for watched and favorite
                SwitchListTile(
                  title: const Text('Фильм уже просмотрен'),
                  subtitle: const Text('Добавит отметку "Просмотрено" и учтёт в статистике'),
                  value: _isWatched,
                  secondary: Icon(
                    _isWatched ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _isWatched ? Colors.green : Colors.grey,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _isWatched = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Добавить в избранное'),
                  subtitle: const Text('Фильм появится во вкладке любимых фильмов'),
                  value: _isFavorite,
                  secondary: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.grey,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _isFavorite = val;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Return null if canceled
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Отмена'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Сохранить фильм'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
