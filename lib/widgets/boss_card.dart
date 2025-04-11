import 'package:flutter/material.dart';

class BossCard extends StatelessWidget {
  final String name;
  final String imageName;

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
              child: Image.asset('lib/assets/images/boss/$imageName'),
            ),
          ),
          Text(name, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
