import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class DeleteValkCard extends ConsumerWidget {
  final String id;
  final String name;

  const DeleteValkCard({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imagePath = ref.read(valkImagesPathPathProvider);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Delete permanently or restore this valk"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(style: TextStyle(color: Colors.white), "Cancel"),
                ),

                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // delete relevant images
                    Directory dir = await getApplicationDocumentsDirectory();
                    final valkImagePath = ref.read(valkImagesPathPathProvider);
                    final valkImageFile = File('$valkImagePath/$id.png');
                    final weapImageFile = File(
                      '${dir.path}/Honkai Station/images/equipments/${id}weap.png',
                    );
                    final topImageFile = File(
                      '${dir.path}/Honkai Station/images/equipments/${id}top.png',
                    );
                    final midImageFile = File(
                      '${dir.path}/Honkai Station/images/equipments/${id}mid.png',
                    );
                    final botImageFile = File(
                      '${dir.path}/Honkai Station/images/equipments/${id}bot.png',
                    );
                    await valkImageFile.delete();
                    await weapImageFile.delete();
                    await topImageFile.delete();
                    await midImageFile.delete();
                    await botImageFile.delete();
                    //delete relevant txt file
                    dir = Directory('${dir.path}/Honkai Station/text/$id');
                    await dir.delete(recursive: true);
                    //delete from database
                    final db = await DatabaseHelper.getDatabase();
                    await db.delete(
                      'valk_lineup',
                      where: 'id_valk = ?',
                      whereArgs: [id],
                    );
                    await db.delete(
                      'valkyries',
                      where: 'id = ?',
                      whereArgs: [id],
                    );
                    ref.read(deleteProvider).deleteValk(id);
                  },
                  child: Text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    "Delete permanently",
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    //restore
                    ref.read(deleteProvider).deleteValk(id);
                    ref.read(valkyrieProvider).restoreValkyrie(id);
                    //restore in database
                    final db = await DatabaseHelper.getDatabase();
                    await db.update(
                      'valkyries',
                      {'is_deleted': 0},
                      where: 'id = ?',
                      whereArgs: [id],
                    );
                  },
                  child: Text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    "Restore",
                  ),
                ),
              ],
            );
          },
        );
      },
      child: GridTile(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 100,
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  width: 100,
                  height: 100,
                  File('$imagePath/$id.png'),
                ),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
              name,
            ),
          ],
        ),
      ),
    );
  }
}
