import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final String imagePath = ref.read(abyssbossImagesPathProvider);

    return GestureDetector(
      onTap: onTap,
      onSecondaryTap: onSecondaryTap,
      child: GridTile(
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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 100,
              color: Colors.black,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  height: 80,
                  width: 250,
                  File('$imagePath/$id.png'),
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
      ),
    );
  }
}
