import 'package:countries_explorer_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/country_provider.dart';
import './providers/favourite_provider.dart';
import './screens/country_detail_screen.dart';
import './screens/favorites_note_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
      ],
      child: MaterialApp(
        title: 'Countries Explorer',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.teal),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF1F2937),
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: TextTheme(
            titleLarge: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            titleMedium: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            titleSmall: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFF1F2937),
            ),
            bodyMedium: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        home: MainScreen(),
        routes: {
          CountryDetailScreen.routeName: (ctx) => CountryDetailScreen(),
          FavoritesNoteScreen.routeName: (ctx) => FavoritesNoteScreen(),
        },
      ),
    );
  }
}
