import 'package:path_provider/path_provider.dart';

Future<String> getJsonFilesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/json';
}

Future<String> getBossImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/bosses';
}

Future<String> getValkImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/valkyries';
}

Future<String> getElfImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/elfs';
}
