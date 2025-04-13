import 'package:flutter/material.dart';

class ComingsoonPage extends StatelessWidget {
  const ComingsoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              child: Image(image: AssetImage('lib/assets/images/logo.png')),
            ),
          ],
        ),
      ),
    );
  }
}
