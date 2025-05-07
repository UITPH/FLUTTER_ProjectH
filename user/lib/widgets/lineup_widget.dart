import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineupWidget extends ConsumerWidget {
  final String note;
  final String leader;
  final List<dynamic> firstvalks;
  final List<dynamic> secondvalks;
  final List<dynamic> elfs;
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
    Widget getElfImage(String id) {
      final db = DatabaseHelper.supabase;
      final url = db.storage.from('data').getPublicUrl('images/elfs/$id.png');

      return CachedNetworkImage(
        width: 100,
        height: 100,
        placeholder:
            (context, url) => LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: url,
      );
    }

    Widget getValkImage(String id) {
      final db = DatabaseHelper.supabase;
      final url = db.storage
          .from('data')
          .getPublicUrl('images/valkyries/$id.png');

      return CachedNetworkImage(
        width: 100,
        height: 100,
        placeholder:
            (context, url) => LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: url,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            note,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 30),
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
                    child: getValkImage(leader),
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
                          child: getValkImage(firstvalks[index]),
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
                          child: getValkImage(secondvalks[index]),
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
                          child: getElfImage(elfs[index]),
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
