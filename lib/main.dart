import 'package:flutter/material.dart';
import 'package:text_to_speace/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text to Speace',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}
