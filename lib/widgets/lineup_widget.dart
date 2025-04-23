import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineupWidget extends ConsumerWidget {
  final String note;
  final String leader;
  final List<String> firstvalks;
  final List<dynamic> secondvalks;
  final List<String> elfs;
  const LineupWidget({
    super.key,
    required this.note,
    required this.leader,
    required this.firstvalks,
    required this.secondvalks,
    required this.elfs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String valkimagePath = ref.read(valkImagesPathPathProvider);
    final String elfimagePath = ref.read(elfImagesPathProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            note,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 50),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      width: 120,
                      height: 120,
                      File('$valkimagePath/$leader'),
                    ),
                  ),
                ),
                Icon(size: 30, Icons.add),
                IntrinsicWidth(
                  child: Row(
                    children: List.generate(
                      firstvalks.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            width: 120,
                            height: 120,
                            File('$valkimagePath/${firstvalks[index]}'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: secondvalks.isNotEmpty,
                  child: Icon(size: 30, Icons.add),
                ),
                IntrinsicWidth(
                  child: Row(
                    children: List.generate(
                      secondvalks.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            width: 120,
                            height: 120,
                            File('$valkimagePath/${secondvalks[index]}'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(size: 30, Icons.add),
                IntrinsicWidth(
                  child: Row(
                    children: List.generate(
                      elfs.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            width: 120,
                            height: 120,
                            File('$elfimagePath/${elfs[index]}'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
