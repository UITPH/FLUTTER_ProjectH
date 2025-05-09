import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class PreviewElfCard extends ConsumerWidget {
  final String id;
  final String name;
  final String imagePath;
  final VoidCallback onTap;

  const PreviewElfCard({
    super.key,
    required this.id,
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridTile(
      child: Column(
        children: [
          Clickable(
            onTap: onTap,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 100,
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  fit: BoxFit.fill,
                  width: 120,
                  height: 120,
                  File(imagePath),
                ),
              ),
            ),
          ),
          Text(name, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
