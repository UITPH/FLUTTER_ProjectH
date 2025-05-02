import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewValkCard extends ConsumerWidget {
  final String name;
  final String valkImagePath;
  final VoidCallback onTap;
  const PreviewValkCard({
    super.key,
    required this.name,
    required this.valkImagePath,
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
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 100,
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(width: 100, height: 100, File(valkImagePath)),
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
