import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/main_scaffold.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/services/path_helper.dart';
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

  final abyssbossimagespath = await getAbyssBossImagesPath();
  final arenabossimagespath = await getArenaBossImagesPath();
  final valkimagespath = await getValkImagesPath();
  final elfimagespath = await getElfImagesPath();
  final equipmentimagespath = await getEquipmentImagesPath();
  databaseFactory = databaseFactoryFfi;
  runApp(
    ProviderScope(
      overrides: [
        abyssbossImagesPathProvider.overrideWith((ref) => abyssbossimagespath),
        arenabossImagesPathProvider.overrideWith((ref) => arenabossimagespath),
        valkImagesPathPathProvider.overrideWith((ref) => valkimagespath),
        elfImagesPathProvider.overrideWith((ref) => elfimagespath),
        equipmentImagesPathProvider.overrideWith((ref) => equipmentimagespath),
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
      debugShowCheckedModeBanner: false,
      title: 'Honkai Station',
      theme: ThemeData.dark(useMaterial3: true),
      home: MainScaffold(),
    );
  }
}
