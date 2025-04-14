import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_honkai/pages/elf_overview_page.dart';

class ElfCard extends StatelessWidget {
  final String name;
  final String imageName;
  final String imagePath = 'D:/images/elfs';

  const ElfCard({super.key, required this.name, required this.imageName});

  @override
  Widget build(BuildContext context) {
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
