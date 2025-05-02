import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    } else {
      var dir = await getApplicationDocumentsDirectory();
      var path =
          '${dir.path}/Honkai Station/honkai_station.db'; // Đường dẫn đến database sẵn có
      _database = await openDatabase(
        path,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
      return _database!;
    }
  }
}
