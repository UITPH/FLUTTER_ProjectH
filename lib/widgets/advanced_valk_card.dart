import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'dart:io';

import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdvanceValkCard extends ConsumerWidget {
  final String label;
  final String imageName;
  final String id;
  final VoidCallback onTap;

  const AdvanceValkCard({
    super.key,
    required this.label,
    required this.id,
    required this.imageName,
    required this.onTap,
  });

  void showBasicAlertDialog(
    BuildContext context,
    List<ValkyrieModel> valkyries,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete valk?'),
          content: const Text('Are you sure you want to delete this valk?'),
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
                valkyries.removeWhere((valk) => valk.id == id);
                saveValkyriesListToJson(valkyries);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Delete successfully'),
                  ),
                );
                onTap();
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
    final String imagePath = ref.read(valkImagesPathPathProvider);
    List<ValkyrieModel> valkyries = ref.read(valkyrieProvider);

    return GestureDetector(
      onTap: () {
        showBasicAlertDialog(context, valkyries, ref);
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
                child: Image.file(
                  width: 100,
                  height: 100,
                  File('$imagePath/$imageName'),
                ),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
              label,
            ),
          ],
        ),
      ),
    );
  }
}
