import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
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
    Widget getElfImage(String id) {
      final version =
          ref.read(elfProvider).elfs.firstWhere((elf) => elf.id == id).version;
      final db = DatabaseHelper.supabase;
      final url =
          '${db.storage.from('data').getPublicUrl('images/elfs/$id.png')}?v=$version';

      return CachedNetworkImage(
        width: 100,
        height: 100,
        fit: BoxFit.fill,
        placeholder:
            (context, url) => LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: url,
      );
    }

    Widget getValkImage(String id) {
      final version =
          ref
              .read(valkyrieProvider)
              .valkyries
              .firstWhere((valk) => valk.id == id)
              .version;
      final db = DatabaseHelper.supabase;
      final url =
          '${db.storage.from('data').getPublicUrl('images/valkyries/$id.png')}?v=$version';
      return CachedNetworkImage(
        width: 100,
        height: 100,
        fit: BoxFit.fill,
        placeholder:
            (context, url) => LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: url,
      );
    }

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
                child: getValkImage(valk1),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: getValkImage(valk2),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: getValkImage(valk3),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: getElfImage(elf),
              ),
            ],
          ),
          Visibility(visible: note != '', child: SizedBox(height: 10)),
          Visibility(
            visible: note != '',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black),
                note,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
