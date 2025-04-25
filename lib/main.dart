import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/main_scaffold.dart';
import 'package:flutter_honkai/providers/boss_provider.dart';
import 'package:flutter_honkai/providers/elf_astralop_provider.dart';
import 'package:flutter_honkai/providers/favorite_provider.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1440, 900),
    center: true,
    minimumSize: Size(1440, 900),
    maximumSize: Size(2560, 1600),
    title: "Honkai Station",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await windowManager.setAspectRatio(16 / 10);

  final dir = await getApplicationDocumentsDirectory();
  final bossimagespath = '${dir.path}/Honkai Station/images/bosses';
  final valkimagespath = '${dir.path}/Honkai Station/images/valkyries';
  final elfimagespath = '${dir.path}/Honkai Station/images/elfs';
  final equipmentimagespath = '${dir.path}/Honkai Station/images/equipments';
  //Đọc JSON từ file
  final valkyriesData = await loadValkyriesListFromJson();
  final bossesData = await loadBossesListFromJson();
  final elfsData = await loadElfsListFromJson();
  final weathersData = await loadWeathersListFromJson();
  runApp(
    ProviderScope(
      overrides: [
        //data
        valkyrieProvider.overrideWith((ref) => valkyriesData),
        bossProvider.overrideWith((ref) => bossesData),
        elfProvider.overrideWith((ref) => elfsData),
        weatherProvider.overrideWith((ref) => weathersData),
        //imagepath
        bossImagesPathProvider.overrideWith((ref) => bossimagespath),
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
