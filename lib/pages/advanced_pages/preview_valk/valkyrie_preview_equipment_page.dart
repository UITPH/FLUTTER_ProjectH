import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyriePreviewEquipmentPage extends ConsumerWidget {
  final String weapImagePath;
  final String topImagePath;
  final String midImagePath;
  final String botImagePath;

  const ValkyriePreviewEquipmentPage({
    super.key,
    required this.weapImagePath,
    required this.topImagePath,
    required this.midImagePath,
    required this.botImagePath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          File(weapImagePath),
                        ),
                      ),
                      ClipRRect(
                        child: Image.file(
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                          File(topImagePath),
                        ),
                      ),
                      ClipRRect(
                        child: Image.file(
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                          File(midImagePath),
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
                          File(botImagePath),
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
