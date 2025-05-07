import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class DeleteAbyssbossCard extends ConsumerWidget {
  final String id;
  final String name;

  const DeleteAbyssbossCard({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imagePath = ref.read(abyssbossImagesPathProvider);

    return GridTile(
      child: Column(
        children: [
          Clickable(
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
                        child: Text(
                          style: TextStyle(color: Colors.white),
                          "Cancel",
                        ),
                      ),

                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          //notify other widgets to update
                          ref.read(abyssBossProvider).removeBoss(id);
                          //delete relevant images
                          final bossImagePath = ref.read(
                            abyssbossImagesPathProvider,
                          );
                          final bossImageFile = File('$bossImagePath/$id.png');
                          await bossImageFile.delete();
                          //delete from database
                          final db = await DatabaseHelper.getDatabase();
                          await db.delete(
                            'abyssboss_teamrec',
                            where: 'id_abyssboss = ?',
                            whereArgs: [id],
                          );
                          await db.delete(
                            'abyssbosses',
                            where: 'id = ?',
                            whereArgs: [id],
                          );
                          ref.read(deleteProvider).deleteAbyssBoss(id);
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
                          ref.read(deleteProvider).deleteAbyssBoss(id);
                          ref.read(abyssBossProvider).restoreBoss(id);
                          //restore in database
                          final db = await DatabaseHelper.getDatabase();
                          await db.update(
                            'abyssbosses',
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
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 100,
              color: Colors.black,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  height: 80,
                  width: 250,
                  File('$imagePath/$id.png'),
                ),
              ),
            ),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
