import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_projecth/screens/home_screen.dart';
import 'package:flutter_projecth/providers/message_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
