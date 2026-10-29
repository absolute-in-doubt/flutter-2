Лабораторная работа №2.
Введение в фреймворк Flutter

Количество часов: 4ч.

Ход работы: Создание простого интерфейса. Организация структуры проекта. Работа с эмулятором. Построение базовой архитектуры: выбор методики управлением состоянием. Создание двухстраничного приложения.

Установка Flutter SDK:
https://docs.flutter.dev/install

Структура Flutter-приложения
Flutter-приложение содержит каталог lib, в котором располагается исходный код на Dart. Точка входа в приложение обычно находится в файле lib/main.dart.
Для небольшого приложения рекомендуется использовать следующую структуру:

lib/
├── main.dart              # точка входа и корневой виджет
├── screens/               # экраны приложения
│   ├── home_screen.dart
├── models/                # модели данных
│   └── user.dart



Теоретический раздел:

Простейшее Flutter-приложение вызывает функцию runApp() с помощью виджета. Функция runApp() принимает заданное значение Widget и делает его корнем дерева виджетов.
В данном примере дерево виджетов состоит из виджета MaterialApp и его дочернего виджета Example. Фреймворк заставляет корневой виджет занимать всю площадь экрана, что означает, что содержимое Example будет отображено на всём экране устройства. В этом случае направление текста, тема и другие параметры Material Design задаются автоматически благодаря использованию виджета MaterialApp.

import 'package:flutter/material.dart';


void main() =>  runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      home: const Example(),
    );
  }
}

При разработке приложения обычно создаются новые виджеты, которые являются подклассами либо StatelessWidget, либо StatefulWidget, в зависимости от того, управляет ли ваш виджет каким-либо состоянием. Основная задача виджета – реализовать build() функцию, которая описывает виджет с точки зрения других, более низкоуровневых виджетов.
StatelessWidget используется в случаях, когда виджет не хранит изменяемого состояния. Например, текст, иконка или страница с постоянным содержимым могут быть реализованы как StatelessWidget.
StatefulWidget используется, если внешний вид виджета должен изменяться во время работы приложения. Например, выбранный пункт нижней панели навигации, значение счётчика или введённый пользователем текст являются состоянием.

import 'package:flutter/material.dart';


class CounterExample extends StatefulWidget {
  const CounterExample({super.key});

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Значение: $count'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: const Text('Увеличить'),
        ),
      ],
    );
  }
}


Метод setState() сообщает Flutter, что состояние виджета изменилось. После этого Flutter повторно вызывает метод build() и обновляет необходимые элементы интерфейса.

Базовые виджеты
Flutter поставляется с набором базовых виджетов, из которых наиболее часто используются следующие:
Scaffold
Виджет Scaffold представляет собой базовый каркас экрана Material-приложения. Он может содержать верхнюю панель AppBar, основное содержимое body, боковую панель drawer и нижнюю панель bottomNavigationBar.

Scaffold(
  appBar: AppBar(
    title: const Text('Главная страница'),
  ),
  body: const Center(
    child: Text('Содержимое страницы'),
  ),
)


Text
Этот виджет позволяет создавать последовательность стилизованного текста внутри вашего приложения. Для настройки внешнего вида текста используется свойство style и класс TextStyle.

const Text(
  'Заголовок',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)


Row , Column
Эти гибкие виджеты позволяют создавать гибкие макеты как по горизонтали (Row), так и по вертикали (Column).

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text('Название приложения'),
    const SizedBox(height: 12),
    ElevatedButton(
      onPressed: () {},
      child: const Text('Продолжить'),
    ),
  ],
)


Stack
Вместо линейной ориентации (горизонтальной или вертикальной), виджет Stack позволяет размещать дочерние виджеты друг над другом. Для точного размещения дочернего элемента внутри Stack используется виджет Positioned.

Stack(
  children: [
    Container(
      width: 200,
      height: 120,
      color: Colors.blue.shade100,
    ),
    const Positioned(
      right: 8,
      top: 8,
      child: Icon(Icons.star),
    ),
  ],
)

Container
Виджет Container создаёт прямоугольный визуальный элемент. Он позволяет задать размеры, внешние и внутренние отступы, фон, границу, скругление углов и тень.

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  margin: const EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.blue.shade200),
  ),
  child: const Text('Пример информационной карточки'),
)

В Flutter стиль интерфейса задаётся свойствами виджетов. Для настройки отступов применяются классы EdgeInsets, для стилизации текста — TextStyle, а для оформления контейнеров — BoxDecoration.
Flutter предоставляет разработчикам два варианта стиля виджетов с разным набором компонентов для пользовательского интерфейса, а также отличающимся поведением: Material и Cupertino.
Material Design – дизайн-система с открытым исходным кодом, созданная и поддерживаемая дизайнерами и разработчиками Google. Начиная с Flutter 3.16 по умолчанию используется ее третья версия, более адаптированная для экранов различного размера. При ее проектировании изначально была заложена концепция, что виджеты в стиле Material могут использоваться на различных платформах: Android, iOS, Web и даже Desktop. Чтобы подключить данный стиль, в начале файла с кодом, укажите следующий импорт:

import 'package:flutter/material.dart';

https://docs.flutter.dev/ui/widgets/material

Cupertino Design – дизайн-система от Apple, содержащая набор рекомендаций по пользовательскому интерфейсу приложений для операционной системы iOS. Красивые и высококачественные виджеты, соответствующие рекомендациям Apple по проектированию пользовательского интерфейса для iOS и macOS. Чтобы использовать виджеты данного стиля, в начале файла с кодом, укажите следующий импорт:

import 'package:flutter/cupertino.dart';

https://docs.flutter.dev/ui/widgets/cupertino

В зависимости от того, какой стиль был выбран для приложения в качестве основного, в корне дерева должен располагаться виджет MaterialApp или CupertinoApp. Это делается для того, чтобы задать функциональность, характерную для конкретной дизайн-системы. А именно: стиль текста, навигацию по экранам приложения, анимацию и т.д.
Аргументы конструктора классов MaterialApp и CupertinoApp мало чем отличаются. У всех аргументов конструктора есть значение по умолчанию, поэтому при объявлении экземпляра класса используйте только необходимые для конкретного случая. 
Flutter предоставляет ряд виджетов, которые помогают создавать приложения, соответствующие Material Design. Приложение Material начинается с MaterialApp виджета, который создает ряд виджетов в корне вашего приложения, включая виджет Navigator, который управляет стеком виджетов, идентифицируемых «маршрутами». Виджет Navigator позволяет плавно переходить между экранами вашего приложения. 

Виджет Navigator отображает экраны в виде стека, используя правильные анимации перехода для целевой платформы. Для перехода на новый экран обращайтесь к виджету Navigator через маршрут BuildContext и вызывайте императивные методы, такие как push() или pop():

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DetailsScreen(),
  ),
);

Navigator.pop(context);

Пример простого двухстраничного приложения:

import 'package:flutter/material.dart';

void main() =>  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Two Page App',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная страница'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailsScreen(),
              ),
            );
          },
          child: const Text('Открыть вторую страницу'),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вторая страница'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Вернуться назад'),
        ),
      ),
    );
  }
}


Данные на другую страницу обычно передаются через параметры конструктора виджета. Для этого необходимо добавить поле в класс второй страницы и передать ему значение при создании маршрута:

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DetailsScreen(
      message: 'Данные переданы с главной страницы',
    ),
  ),
);

class DetailsScreen extends StatelessWidget {
  final String message;

  const DetailsScreen({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вторая страница'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

Метод Navigator.push() возвращает объект Future. Это позволяет получить данные, возвращённые со второй страницы. Для возврата значения необходимо передать его вторым аргументом в Navigator.pop().

final result = await Navigator.push<String>(
  context,
  MaterialPageRoute(
    builder: (context) => const DetailsScreen(),
  ),
);

if (!context.mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(result ?? 'Данные не были возвращены'),
  ),
);


На второй странице:

ElevatedButton(
  onPressed: () {
    Navigator.pop(context, 'Результат со второй страницы');
  },
  child: const Text('Вернуть результат'),
)


Панель навигации

Нижняя панель навигации используется для быстрого перехода между основными разделами приложения. В Material 3 для этой цели применяется виджет NavigationBar.
Так как выбранный пункт нижней панели может изменяться, экран с NavigationBar обычно создаётся как StatefulWidget.

void main() =>  runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Two Page App',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    Center(child: Text('Главная')),
    Center(child: Text('Профиль')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Навигация'),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

В примере переменная selectedIndex хранит индекс выбранного пункта панели, а список pages содержит виджеты, которые отображаются в зависимости от выбранного раздела.

Боковая панель навигации в Material-приложении реализуется с помощью виджета Drawer. Виджет Drawer передаётся в свойство drawer виджета Scaffold.
Обычно боковая панель содержит пункты меню, которые позволяют перейти на основные экраны приложения. Перед выполнением перехода панель следует закрыть вызовом Navigator.pop(context).

Scaffold(
  appBar: AppBar(
    title: const Text('Главная'),
  ),
  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            'Меню',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Главная'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('О приложении'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  ),
  body: const Center(
    child: Text('Главная страница'),
  ),
);

Управление состоянием
Состоянием называют данные, изменение которых должно привести к обновлению интерфейса. Например, выбранный пункт нижней панели, значение счётчика, список задач или данные пользователя являются состоянием приложения.
Для небольших локальных изменений состояния может применяться метод setState(). Он подходит, когда состояние используется только внутри одного StatefulWidget.
В более крупных приложениях состояние обычно выносится из виджетов в отдельные классы. Это упрощает разделение интерфейса и логики приложения.

Существуют различные подходы к управлению состоянием:
Подход	Назначение
setState()	Локальное состояние одного виджета или экрана
Provider	Простое общее состояние приложения
Cubit	Упрощённый вариант BLoC с методами, изменяющими состояние
BLoC	Подход с отдельными событиями и состояниями
Riverpod	Альтернативный подход к управлению состоянием


setState() — встроенный механизм Flutter для работы с локальным состоянием внутри StatefulWidget. Изменение переменной оборачивается в setState(), что помечает виджет на перестройку.
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);
  void _decrement() => setState(() => _counter--);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('setState example'),
      ),
      body: Center(
        child: Text(
          'Значение: $_counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: _increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: _decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

Для использования Cubit необходимо добавить пакет flutter_bloc в файл pubspec.yaml или выполнить команду:
flutter pub add flutter_bloc

Cubit — упрощённая версия BLoC, где состояние хранится в классе и обновляется через emit(). Виджеты подписываются на изменения через BlocBuilder, а экземпляр передаётся через BlocProvider.

Пример Cubit для счётчика:
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
  }

  void decrement() {
    emit(state - 1);
  }
}


Для передачи Cubit в дерево виджетов используется BlocProvider.

void main() {
  runApp(
    BlocProvider(
      create: (context) => CounterCubit(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubit Counter Example',
      home: const CounterScreen(),
    );
  }
}


Для построения интерфейса на основе состояния используется BlocBuilder.

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubit example'),
      ),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, count) {
            return Text(
              'Значение: $count',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () {
              context.read<CounterCubit>().increment();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: () {
              context.read<CounterCubit>().decrement();
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}


BlocProvider создаёт и передаёт экземпляр Cubit дочерним виджетам. BlocBuilder перестраивает часть интерфейса при изменении состояния. Метод context.read<CounterCubit>() используется для вызова методов Cubit без подписки на изменения состояния.
При использовании классического BLoC вместо Cubit дополнительно создаются классы событий (Event) и состояний (State). Событие передаётся в BLoC, BLoC обрабатывает его и формирует новое состояние. Такой подход используется, когда логика приложения содержит несколько видов событий и состояний.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const App());
}

// Пользовательский [BlocObserver], отслеживающий все изменения состояний Bloc и Cubit.
class AppBlocObserver extends BlocObserver {
 
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

// [StatelessWidget], который:
// * использует [bloc](https://pub.dev/packages/bloc) и
// [flutter_bloc](https://pub.dev/packages/flutter_bloc)
// для управления состоянием счетчика и темой приложения.
class App extends StatelessWidget {
  
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: const AppView(),
    );
  }
}

// [StatelessWidget], который:
// * реагирует на изменения состояния в [ThemeCubit]
// и обновляет тему [MaterialApp];
// * отрисовывает [CounterPage].
class AppView extends StatelessWidget {
  
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (_, theme) {
        return MaterialApp(
          theme: theme,
          home: const CounterPage(),
        );
      },
    );
  }
}


// [StatelessWidget], который:
// * предоставляет [CounterBloc] виджету [CounterView].
class CounterPage extends StatelessWidget {

  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const CounterView(),
    );
  }
}

// [StatelessWidget], который:
// * демонстрирует, как использовать [CounterBloc] и взаимодействовать с ним.
class CounterView extends StatelessWidget {
  
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, count) {
            return Text(
              '$count',
              style: Theme.of(context).textTheme.displayLarge,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              context.read<CounterBloc>().add(CounterIncrementPressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              context.read<CounterBloc>().add(CounterDecrementPressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}

// Событие обрабатывается [CounterBloc].
abstract class CounterEvent {}

// Уведомляет bloc о необходимости увеличить состояние.
class CounterIncrementPressed extends CounterEvent {}

// Уведомляет bloc о необходимости уменьшить состояние.
class CounterDecrementPressed extends CounterEvent {}

// Простой [Bloc], управляющий состоянием типа 'int'.
class CounterBloc extends Bloc<CounterEvent, int> {
  
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
    on<CounterDecrementPressed>((event, emit) => emit(state - 1));
  }
}

// Простой [Cubit], управляющий [ThemeData] в качестве своего состояния.
class ThemeCubit extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData.light();

  static final _darkTheme = ThemeData.dark();

 // Переключает текущую тему между светлым и тёмным режимами.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}


Задание:
Создайте Flutter-приложение на произвольную тему: список задач, каталог фильмов, карточки пользователя, заметки, рецепты, планировщик или другое приложение по согласованию с преподавателем.
Корректно организуйте исходный код по папкам.
Реализуйте не менее 4 различных экранов приложения, включая передачу данных и\или возврат результата между экранами, панель навигации, минимум одну форму ввода.
Используйте любой способ управления состоянием по согласованию с преподавателем.
