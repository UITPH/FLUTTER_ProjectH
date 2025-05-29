import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class DeleteAbyssbossCard extends ConsumerWidget {
  final String id;
  final String name;

  const DeleteAbyssbossCard({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getAbyssBossImage(String id) {
      final version =
          ref
              .read(deleteProvider)
              .abyssbossDeletes
              .firstWhere((boss) => boss.id == id)
              .version;
      final db = DatabaseHelper.supabase;
      final url =
          '${db.storage.from('data').getPublicUrl('images/abyssbosses/$id.png')}?v=$version';

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
                          final connectionStatus =
                              await Connectivity().checkConnectivity();
                          if (connectionStatus.contains(
                                ConnectivityResult.none,
                              ) &&
                              context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text(
                                  "The internet connection is lost",
                                ),
                              ),
                            );
                            return;
                          }
                          if (context.mounted) Navigator.of(context).pop();
                          //notify other widgets to update
                          ref.read(abyssBossProvider).removeBoss(id);
                          //delete relevant images
                          final db = DatabaseHelper.supabase;
                          await db.storage.from('data').remove([
                            'images/abyssbosses/$id.png',
                          ]);
                          //delete from database
                          await db.from('abyssbosses').delete().eq('id', id);
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
                          final connectionStatus =
                              await Connectivity().checkConnectivity();
                          if (connectionStatus.contains(
                                ConnectivityResult.none,
                              ) &&
                              context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text(
                                  "The internet connection is lost",
                                ),
                              ),
                            );
                            return;
                          }
                          if (context.mounted) Navigator.of(context).pop();
                          //restore
                          ref.read(deleteProvider).restoreAbyssBoss(id, ref);
                          //restore in database
                          final db = DatabaseHelper.supabase;
                          await db
                              .from('abyssbosses')
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
                child: getAbyssBossImage(id),
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
