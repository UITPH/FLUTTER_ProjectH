import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class DeleteValkCard extends ConsumerWidget {
  final String id;
  final String name;

  const DeleteValkCard({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getValkImage(String id) {
      final version =
          ref
              .read(imageVersionProvider)
              .valkyries
              .firstWhere((valk) => valk['id'] == id)['version'];
      final db = DatabaseHelper.supabase;
      final url =
          '${db.storage.from('data').getPublicUrl('images/valkyries/$id.png')}?v=$version';

      return CachedNetworkImage(
        width: 100,
        height: 100,
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
                          ref.read(valkyrieProvider).removeValkyrie(id);
                          // delete relevant images
                          final db = DatabaseHelper.supabase;
                          await db.storage.from('data').remove([
                            'images/valkyries/$id.png',
                            'images/equipments/${id}weap.png',
                            'images/equipments/${id}top.png',
                            'images/equipments/${id}mid.png',
                            'images/equipments/${id}bot.png',
                          ]);
                          //delete from database
                          await db.from('valkyries').delete().eq('id', id);
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
                          ref.read(deleteProvider).restoreValk(id, ref);
                          //restore in database
                          final db = DatabaseHelper.supabase;
                          await db
                              .from('valkyries')
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
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 100,
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: getValkImage(id),
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
    );
  }
}
