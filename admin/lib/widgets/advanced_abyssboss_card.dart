import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'package:flutter_honkai/widgets/clickable.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdvanceAbyssbossCard extends ConsumerWidget {
  final String id;
  final String name;

  const AdvanceAbyssbossCard({super.key, required this.id, required this.name});

  void showBasicAlertDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete boss?'),
          content: const Text('Are you sure you want to delete this boss?'),
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
                    .addAbyssBoss(
                      ref
                          .read(abyssBossProvider)
                          .bosses
                          .firstWhere((boss) => boss.id == id),
                    );
                //notify other widgets to update
                ref.read(abyssBossProvider).removeBoss(id);
                //soft delete in database
                final db = DatabaseHelper.supabase;
                await db
                    .from('abyssbosses')
                    .update({'is_deleted': 1})
                    .eq('id', id);
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
    Widget getAbyssBossImage(String id) {
      final version =
          ref
              .read(abyssBossProvider)
              .bosses
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
              showBasicAlertDialog(context, ref);
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
          Text(name, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
