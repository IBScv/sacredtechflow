import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ibs_sacred_tech_flow/screens/daily_dashboard.dart';
import 'package:ibs_sacred_tech_flow/screens/new_synchronicity_screen.dart';
import 'package:ibs_sacred_tech_flow/screens/synchronicity_screen.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard.dart';
import 'screens/journal_entry.dart';
import 'models/lunar_entry.dart';
import 'dart:convert';
import 'app_state.dart';

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await Hive.initFlutter();
  await appState.init();

  // Optionally: register adapters if you create typed Hive objects
  // For quick start, we'll use a simple box storing JSON maps.
  await Hive.openBox('lunarEntries');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final theme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal[300],
    scaffoldBackgroundColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        color: Colors.amberAccent,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.amberAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Sacred Tech Flow',
        debugShowCheckedModeBanner: false, // 👈 remove the banner
        theme: theme,
        initialRoute: '/',
        routes: {
          '/': (_) => DashboardScreen(),
          '/new': (_) => JournalEntryScreen(),
          '/dashboard': (_) => DailyDashboard(),
          '/synchronicity': (_) => SynchronicityScreen(),
          '/newSynchronicity': (_) => NewSynchronicityScreen(),
        },
      ),
    );
  }
}
