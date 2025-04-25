import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BossCard extends ConsumerWidget {
  final String label;
  final String imageName;
  final VoidCallback onTap;

  const BossCard({
    super.key,
    required this.label,
    required this.imageName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imagePath = ref.read(bossImagesPathProvider);

    return GestureDetector(
      onTap: onTap,
      child: GridTile(
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
                child: Image.file(File('$imagePath/$imageName')),
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
