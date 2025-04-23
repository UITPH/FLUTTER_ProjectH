import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopteamsWidget extends ConsumerWidget {
  final String valk1;
  final String valk2;
  final String valk3;
  final String elf;
  final String note;
  const TopteamsWidget({
    super.key,
    required this.valk1,
    required this.valk2,
    required this.valk3,
    required this.elf,
    required this.note,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String valkimagePath = ref.read(valkImagesPathPathProvider);
    final String elfimagePath = ref.read(elfImagesPathProvider);
    return Container(
      width: 450,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                  File('$valkimagePath/$valk1'),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                  File('$valkimagePath/$valk2'),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                  File('$valkimagePath/$valk3'),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                  File('$elfimagePath/$elf'),
                ),
              ),
            ],
          ),
          Visibility(visible: note != "", child: SizedBox(height: 20)),
          Visibility(
            visible: note != "",
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black),
                note,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
