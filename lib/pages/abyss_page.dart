import 'package:flutter/material.dart';

class AbyssPage extends StatefulWidget {
  const AbyssPage({super.key});

  @override
  State<AbyssPage> createState() => _AbyssPageState();
}

class _AbyssPageState extends State<AbyssPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/citybridge.jpg'),
              opacity: AlwaysStoppedAnimation(0.3),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Abyss Boss Database',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
