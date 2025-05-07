import 'package:path_provider/path_provider.dart';

Future<String> getAbyssBossImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/abyssbosses';
}

Future<String> getArenaBossImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/arenabosses';
}

Future<String> getValkImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/valkyries';
}

Future<String> getElfImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/elfs';
}

Future<String> getEquipmentImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/equipments';
}
