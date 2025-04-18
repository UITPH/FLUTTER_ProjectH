import 'package:flutter/material.dart';

class AstralopCard extends StatelessWidget {
  final String name;
  final String imageName;

  const AstralopCard({super.key, required this.name, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return GridTile(
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
              child: Image.asset('lib/assets/images/elf&astralop/$imageName'),
            ),
          ),
          Text(name, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
