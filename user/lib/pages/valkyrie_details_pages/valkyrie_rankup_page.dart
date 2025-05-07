import 'package:flutter/material.dart';

class ValkyrieRankupPage extends StatelessWidget {
  final String rankup;
  const ValkyrieRankupPage({super.key, required this.rankup});

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 50,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      'NOTABLE RANK-UP',
                    ),
                    Text(style: TextStyle(fontSize: 25), rankup),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
