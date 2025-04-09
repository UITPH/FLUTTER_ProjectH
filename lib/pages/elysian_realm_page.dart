import 'package:flutter/material.dart';

class ElysianRealmPage extends StatefulWidget {
  const ElysianRealmPage({super.key});

  @override
  State<ElysianRealmPage> createState() => _ElysianRealmPageState();
}

class _ElysianRealmPageState extends State<ElysianRealmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/elybridge.jpg'),
              opacity: AlwaysStoppedAnimation(0.3),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
