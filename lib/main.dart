import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RadarApp());
}

class RadarApp extends StatelessWidget {
  const RadarApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(15, 137, 203, 253),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
