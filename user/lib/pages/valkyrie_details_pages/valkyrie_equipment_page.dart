import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyrieEquipmentPage extends ConsumerWidget {
  final String id;
  final String weapimageName;
  final String topimageName;
  final String midimageName;
  final String botimageName;

  const ValkyrieEquipmentPage({
    super.key,
    required this.id,
    required this.weapimageName,
    required this.topimageName,
    required this.midimageName,
    required this.botimageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getEquipmentImage(String name) {
      final db = DatabaseHelper.supabase;
      final url = db.storage
          .from('data')
          .getPublicUrl('images/equipments/$name.png');

      return CachedNetworkImage(
        width: 150,
        height: 150,
        fit: BoxFit.fill,
        placeholder:
            (context, url) => LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: url,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/futurebridge.png'),
              opacity: AlwaysStoppedAnimation(0.3),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 200),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      'BEST SET',
                    ),
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(15),
                        ),
                        child: getEquipmentImage(weapimageName),
                      ),
                      ClipRRect(child: getEquipmentImage(topimageName)),
                      ClipRRect(child: getEquipmentImage(midimageName)),
                      ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(15),
                        ),
                        child: getEquipmentImage(botimageName),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
