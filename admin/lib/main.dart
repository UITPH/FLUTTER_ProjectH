import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/loading_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1440, 900),
    center: true,
    minimumSize: Size(1360, 765),
    maximumSize: Size(2560, 1600),
    title: "Honkai Station",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await windowManager.setAspectRatio(16 / 10);
  databaseFactory = databaseFactoryFfi;
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Honkai Station',
      theme: ThemeData.dark(useMaterial3: true),
      home: LoadingPage(),
    );
  }
}
