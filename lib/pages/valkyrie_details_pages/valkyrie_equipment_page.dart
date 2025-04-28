import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyrieEquipmentPage extends ConsumerWidget {
  final String weapimageName;
  final String topimageName;
  final String midimageName;
  final String botimageName;

  const ValkyrieEquipmentPage({
    super.key,
    required this.weapimageName,
    required this.topimageName,
    required this.midimageName,
    required this.botimageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = ref.read(equipmentImagesPathProvider);

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
                        child: Image.file(
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                          //File('$imagePath/$weapimageName'),
                          File('$imagePath/fwsweap.png'),
                        ),
                      ),
                      ClipRRect(
                        child: Image.file(
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                          //File('$imagePath/$topimageName'),
                          File('$imagePath/fwstop.png'),
                        ),
                      ),
                      ClipRRect(
                        child: Image.file(
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                          //File('$imagePath/$midimageName'),
                          File('$imagePath/fwsmid.png'),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(15),
                        ),
                        child: Image.file(
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                          //File('$imagePath/$botimageName'),
                          File('$imagePath/fwsbot.png'),
                        ),
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
