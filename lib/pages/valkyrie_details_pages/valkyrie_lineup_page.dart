import 'package:flutter/material.dart';
import 'package:flutter_honkai/widgets/lineup_widget.dart';

class ValkyrieLineupPage extends StatelessWidget {
  final List<Map<String, dynamic>> lineup;
  const ValkyrieLineupPage({super.key, required this.lineup});

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
              child: ListView.builder(
                itemCount: lineup.length,
                itemBuilder: (context, index) {
                  return LineupWidget(
                    note: lineup[index]['note'],
                    leader: lineup[index]['leader'],
                    firstvalks: lineup[index]['firstvalks'],
                    secondvalks: lineup[index]['secondvalks'],
                    elfs: lineup[index]['elfs'],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
