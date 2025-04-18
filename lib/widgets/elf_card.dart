import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_honkai/pages/elf_overview_page.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElfCard extends ConsumerWidget {
  final String name;
  final String imageName;

  const ElfCard({super.key, required this.name, required this.imageName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imagePath = ref.read(elfImagesPathProvider);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ElfOverviewPage();
            },
          ),
        );
      },
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
