import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_honkai/pages/abyss_boss_overview_page.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BossCard extends ConsumerWidget {
  final String name;
  final String imageName;

  const BossCard({super.key, required this.name, required this.imageName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imagePath = ref.read(bossImagesPathProvider);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AbyssBossOverviewPage();
            },
          ),
        );
      },
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
            Text(name, style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
