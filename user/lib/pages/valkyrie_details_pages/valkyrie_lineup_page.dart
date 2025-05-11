import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/widgets/lineup_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyrieLineupPage extends ConsumerWidget {
  final List lineup;
  const ValkyrieLineupPage({super.key, required this.lineup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(imageVersionProvider);
    ref.watch(valkyrieProvider);
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
                    firstvalks: lineup[index]['first_valk_list'],
                    secondvalks: lineup[index]['second_valk_list'],
                    elfs: lineup[index]['elf_list'],
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
