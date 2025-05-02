import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewBossCard extends ConsumerWidget {
  final String id;
  final String name;
  final String imagePath;
  final VoidCallback onTap;

  const PreviewBossCard({
    super.key,
    required this.id,
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: Image.file(height: 80, width: 250, File(imagePath)),
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
