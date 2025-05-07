import 'package:flutter/material.dart';
import 'package:flutter_honkai/widgets/lineup_widget.dart';

class ValkyrieLineupPage extends StatelessWidget {
  final List note;
  final List leader;
  final List firstvalkList;
  final List secondvalkList;
  final List elfList;
  const ValkyrieLineupPage({
    super.key,
    required this.note,
    required this.leader,
    required this.firstvalkList,
    required this.secondvalkList,
    required this.elfList,
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
              child: ListView.builder(
                itemCount: note.length,
                itemBuilder: (context, index) {
                  return LineupWidget(
                    note: note[index],
                    leader: leader[index],
                    firstvalks: firstvalkList[index],
                    secondvalks: secondvalkList[index],
                    elfs: elfList[index],
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
