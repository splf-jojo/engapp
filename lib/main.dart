// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/home_page.dart';
import 'pages/dictionary_page.dart';
import 'pages/cards_page.dart';
import 'pages/practice_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
// import 'pages/reset_password_page.dart';
import 'pages/add_word_set_page.dart';
import 'pages/word_set_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Инициализация Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quizlet-like App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blue,
        ),
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Colors.lightBlueAccent,
        ),
        iconTheme: IconThemeData(
          color: Colors.lightBlueAccent,
        ),
      ),
      themeMode: ThemeMode.system,
      home: AuthGate(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        // '/reset-password': (context) => ResetPasswordPage(),
        '/add-word-set': (context) => AddWordSetPage(),
        // Добавьте другие маршруты здесь, если необходимо
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Проверка состояния подключения
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Если пользователь не вошёл
        if (!snapshot.hasData) {
          return LoginPage();
        }
        // Если пользователь вошёл
        return MainScreen();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // HomePage(),
    // DictionaryPage(),
    CardsPage(),
    PracticePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Dictionary'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Cards'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Practice'),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      // case 0:
      //   return 'Home';
      // case 1:
      //   return 'Dictionary';
      case 0:
        return 'Наборы слов';
      case 1:
        return 'Practice';
      default:
        return 'Flutter Quizlet-like App';
    }
  }
}
