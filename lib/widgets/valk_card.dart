import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final String imagePath = ref.read(valkImagesPathPathProvider);

    return GestureDetector(
      onTap: onTap,
      onSecondaryTap: onSecondaryTap,
      child: GridTile(
        header: SizedBox(
          height: 21,
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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 100,
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  width: 100,
                  height: 100,
                  File('$imagePath/$id.png'),
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
      ),
    );
  }
}
