import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
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
    final String imagePath = ref.read(elfImagesPathProvider);

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
                child: Image.file(File('$imagePath/$id.png')),
              ),
            ),
          ),
          Text(name, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
