import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class AbyssBossCard extends ConsumerWidget {
  final String id;
  final String name;
  final bool isFav;
  final VoidCallback onTap;
  final VoidCallback onSecondaryTap;

  const AbyssBossCard({
    super.key,
    required this.id,
    required this.name,
    required this.isFav,
    required this.onTap,
    required this.onSecondaryTap,
  });

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
      header: SizedBox(
        height: 21,
        child: Stack(
          children: [
            Positioned(
              right: 0,
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
