import 'package:flutter/material.dart';

class ValkyrieOverviewPage extends StatelessWidget {
  final String role;
  final String pullrec;

  const ValkyrieOverviewPage({
    super.key,
    required this.role,
    required this.pullrec,
  });

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
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      'ROLES',
                    ),
                    Text(style: TextStyle(fontSize: 25), role),
                    Divider(color: Colors.white, thickness: 2),
                    Text(
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      'PULL RECOMMENDATION',
                    ),
                    Text(style: TextStyle(fontSize: 25), pullrec),
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
