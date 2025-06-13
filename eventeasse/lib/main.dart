import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/event.dart';
import 'core/models/user.dart';
import 'core/models/location.dart';
import 'core/models/favorite.dart';
import 'core/models/organizer_request.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/home/home_page.dart';
import 'features/home/main_user_nav.dart';
import 'features/organizer/main_organizer_nav.dart';
import 'features/admin/main_admin_nav.dart';
import 'features/profile/apply_organizer_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(FavoriteAdapter());
  Hive.registerAdapter(OrganizerRequestAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventEase',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF388E3C),
          primary: const Color(0xFF388E3C),
          secondary: const Color(0xFFB2FF59),
          background: Colors.white,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: const Color(0xFF1B5E20),
          onBackground: const Color(0xFF1B5E20),
          onSurface: const Color(0xFF1B5E20),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1B5E20)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
            fontSize: 26,
            fontFamily: 'Montserrat',
            letterSpacing: 1.2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF388E3C),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.1),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 28),
            elevation: 6,
            shadowColor: Color(0xFFB2FF59),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F8E9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF388E3C), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF388E3C), width: 2.5),
          ),
          labelStyle: const TextStyle(color: Color(0xFF388E3C), fontWeight: FontWeight.bold, fontSize: 16),
          prefixIconColor: const Color(0xFF388E3C),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 8,
          margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          shadowColor: const Color(0xFFB2FF59),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF388E3C),
          foregroundColor: Colors.white,
          shape: StadiumBorder(),
          elevation: 8,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF388E3C),
          unselectedItemColor: Color(0xFFBDBDBD),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Montserrat', color: Color(0xFF1B5E20), fontSize: 18),
          bodyMedium: TextStyle(fontFamily: 'Montserrat', color: Color(0xFF388E3C), fontSize: 16),
          titleLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), fontSize: 24),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF388E3C),
          contentTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          titleTextStyle: const TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Montserrat'),
          contentTextStyle: const TextStyle(color: Color(0xFF388E3C), fontSize: 16, fontFamily: 'Montserrat'),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF388E3C),
          circularTrackColor: Color(0xFFB2FF59),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFB2FF59),
          thickness: 1.2,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainUserNav(),
        '/organizer': (context) => const MainOrganizerNav(),
        '/admin': (context) => const MainAdminNav(),
        '/apply-organizer': (context) => const ApplyOrganizerForm(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
