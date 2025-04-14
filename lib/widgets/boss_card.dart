import 'package:flutter/material.dart';
import 'dart:io';

class BossCard extends StatelessWidget {
  final String name;
  final String imageName;
  final String imagePath = 'D:/images/bosses';

  const BossCard({super.key, required this.name, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return GridTile(
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
    );
  }
}
