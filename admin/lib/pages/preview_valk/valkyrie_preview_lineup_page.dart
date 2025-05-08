import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/preview_valk/lineup_widget.dart';

class ValkyriePreviewLineupPage extends StatelessWidget {
  final String id;
  final String valkImagePath;
  final List lineup;
  const ValkyriePreviewLineupPage({
    super.key,
    required this.id,
    required this.valkImagePath,
    required this.lineup,
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
                itemCount: lineup.length,
                itemBuilder: (context, index) {
                  return LineupWidget(
                    id: id,
                    valkImagePath: valkImagePath,
                    note: lineup[index]['note'],
                    leader: lineup[index]['leader'],
                    firstvalks: jsonDecode(lineup[index]['first_valk_list']),
                    secondvalks: jsonDecode(lineup[index]['second_valk_list']),
                    elfs: jsonDecode(lineup[index]['elf_list']),
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
