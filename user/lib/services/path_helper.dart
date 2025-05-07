import 'package:path_provider/path_provider.dart';

Future<String> getElfImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/elfs';
}

Future<String> getEquipmentImagesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/Honkai Station/images/equipments';
}
