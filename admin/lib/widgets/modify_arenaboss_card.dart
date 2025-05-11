import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/pages/arenaboss_modify_page.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class ModifyArenabossCard extends ConsumerWidget {
  final ArenaBossModel boss;

  const ModifyArenabossCard({super.key, required this.boss});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getArenaBossImage(String id) {
      final version =
          ref
              .read(imageVersionProvider)
              .arenabosses
              .firstWhere((boss) => boss['id'] == id)['version'];
      final db = DatabaseHelper.supabase;
      final url =
          '${db.storage.from('data').getPublicUrl('images/arenabosses/$id.png')}?v=$version';

      return CachedNetworkImage(
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
                  builder: (context) => ArenabossModifyPage(boss: boss),
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
                child: SizedBox(
                  height: 80,
                  width: 250,
                  child: getArenaBossImage(boss.id),
                ),
              ),
            ),
          ),
          Text(boss.name, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
