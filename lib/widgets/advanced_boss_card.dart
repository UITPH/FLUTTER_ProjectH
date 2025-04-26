import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/boss_model.dart';
import 'package:flutter_honkai/providers/boss_provider.dart';
import 'dart:io';

import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdvancedBossCard extends ConsumerWidget {
  final String label;
  final String imageName;
  final String id;

  const AdvancedBossCard({
    super.key,
    required this.label,
    required this.id,
    required this.imageName,
  });

  void showBasicAlertDialog(
    BuildContext context,
    List<BossModel> bosses,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete boss?'),
          content: const Text('Are you sure you want to delete this boss?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                bosses.removeWhere((boss) => boss.id == id);
                ref.read(bossProvider).saveBossesListToJson(bosses);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Delete successfully'),
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imagePath = ref.read(bossImagesPathProvider);
    List<BossModel> bosses = ref.read(bossProvider).bosses;

    return GestureDetector(
      onTap: () {
        showBasicAlertDialog(context, bosses, ref);
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
            Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
