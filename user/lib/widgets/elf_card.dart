import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class ElfCard extends ConsumerWidget {
  final String id;
  final String name;
  final bool isFav;
  final VoidCallback onTap;
  final VoidCallback onSecondaryTap;

  const ElfCard({
    super.key,
    required this.id,
    required this.name,
    required this.isFav,
    required this.onTap,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getElfImage(String id) {
      final version =
          ref.read(elfProvider).elfs.firstWhere((elf) => elf.id == id).version;
      final db = DatabaseHelper.supabase;
      final url =
          '${db.storage.from('data').getPublicUrl('images/elfs/$id.png')}?v=$version';

      return CachedNetworkImage(
        width: 120,
        height: 120,
        fit: BoxFit.fill,
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
        height: 30,
        child: Stack(
          children: [
            Positioned(
              right: 40,
              child: Icon(
                size: 30,
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
                child: getElfImage(id),
              ),
            ),
          ),
          Text(name, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
