import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/pages/valkyrie_modify_page.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class ModifyValkCard extends ConsumerWidget {
  final ValkyrieModel valk;

  const ModifyValkCard({super.key, required this.valk});

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
        fit: BoxFit.fill,
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ValkyrieModifyPage(valk: valk),
                ),
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
                child: getValkImage(valk.id),
              ),
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
            valk.name,
          ),
        ],
      ),
    );
  }
}
