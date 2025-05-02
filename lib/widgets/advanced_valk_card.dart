import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'dart:io';

import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdvanceValkCard extends ConsumerWidget {
  final String name;
  final String id;

  const AdvanceValkCard({super.key, required this.name, required this.id});

  void showBasicAlertDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete valk?'),
          content: const Text('Are you sure you want to delete this valk?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                //soft delete
                ref
                    .read(deleteProvider)
                    .addValk(
                      ref
                          .read(valkyrieProvider)
                          .valkyries
                          .firstWhere((valk) => valk.id == id),
                    );
                //notify other widgets to update
                ref.read(valkyrieProvider).removeValkyrie(id);
                //soft delete in database
                final db = await DatabaseHelper.getDatabase();
                await db.update(
                  'valkyries',
                  {'is_deleted': 1},
                  where: 'id = ?',
                  whereArgs: [id],
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Delete successfully'),
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imagePath = ref.read(valkImagesPathPathProvider);

    return GestureDetector(
      onTap: () {
        showBasicAlertDialog(context, ref);
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
