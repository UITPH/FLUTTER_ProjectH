import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class ValkCard extends ConsumerWidget {
  final String id;
  final String name;
  final bool isFav;
  final VoidCallback onTap;
  final VoidCallback onSecondaryTap;
  const ValkCard({
    super.key,
    required this.id,
    required this.name,
    required this.onTap,
    required this.isFav,
    required this.onSecondaryTap,
  });

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
      header: SizedBox(
        height: 25,
        child: Stack(
          children: [
            Positioned(
              right: 15,
              child: Icon(
                color: isFav ? Colors.pinkAccent : Colors.white,
                isFav ? Icons.favorite : Icons.favorite_border,
              ),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          Clickable(
            onTap: onTap,
            onSecondaryTap: onSecondaryTap,
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
