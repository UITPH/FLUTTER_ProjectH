import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyriePreviewEquipmentPage extends ConsumerWidget {
  final Widget weapImage;
  final Widget topImage;
  final Widget midImage;
  final Widget botImage;

  const ValkyriePreviewEquipmentPage({
    super.key,
    required this.weapImage,
    required this.topImage,
    required this.midImage,
    required this.botImage,
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
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: weapImage,
                        ),
                      ),
                      ClipRRect(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: topImage,
                        ),
                      ),
                      ClipRRect(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: midImage,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(15),
                        ),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: botImage,
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
