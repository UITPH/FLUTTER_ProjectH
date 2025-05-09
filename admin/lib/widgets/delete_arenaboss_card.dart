import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class DeleteArenabossCard extends ConsumerWidget {
  final String id;
  final String name;

  const DeleteArenabossCard({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getArenaBossImage(String id) {
      final db = DatabaseHelper.supabase;
      final url = db.storage
          .from('data')
          .getPublicUrl('images/arenabosses/$id.png');

      return CachedNetworkImage(
        height: 80,
        width: 250,
        fit: BoxFit.contain,
        placeholder:
            (context, url) => LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: url,
      );
    }

    return GridTile(
      child: Column(
        children: [
          Clickable(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Delete permanently or restore this boss"),
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
                          ref.read(arenabossProvider).removeBoss(id);
                          //delete relevant images
                          final db = DatabaseHelper.supabase;
                          await db.storage.from('data').remove([
                            'images/arenabosses/$id.png',
                          ]);
                          //delete from database
                          await db.from('arenabosses').delete().eq('id', id);
                          ref.read(deleteProvider).deleteArenaBoss(id);
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
                          ref.read(deleteProvider).restoreArenaBoss(id, ref);
                          //restore in database
                          final db = DatabaseHelper.supabase;
                          await db
                              .from('arenabosses')
                              .update({'is_deleted': 0})
                              .eq('id', id);
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
                child: getArenaBossImage(id),
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
