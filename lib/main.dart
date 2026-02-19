import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'main_wrapper.dart';

void main() {
  runApp(const DelhiAQIApp());
}

class DelhiAQIApp extends StatelessWidget {
  const DelhiAQIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delhi AQI Monitoring App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6FBFF),
      ),
      home: const LoginScreen(),

      routes: {
        "/mainApp": (context) => const MainWrapper(),
      },
    );
  }
}
