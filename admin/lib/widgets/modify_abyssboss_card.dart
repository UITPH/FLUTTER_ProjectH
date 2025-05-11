import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/pages/abyssboss_modify_page.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/widgets/clickable.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModifyAbyssbossCard extends ConsumerWidget {
  final AbyssBossModel boss;

  const ModifyAbyssbossCard({super.key, required this.boss});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getAbyssBossImage(String id) {
      final version =
          ref
              .read(imageVersionProvider)
              .abyssbosses
              .firstWhere((boss) => boss['id'] == id)['version'];
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AbyssbossModifyPage(boss: boss),
                ),
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
                child: getAbyssBossImage(boss.id),
              ),
            ),
          ),
          Text(boss.name, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
