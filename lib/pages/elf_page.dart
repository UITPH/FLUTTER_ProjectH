import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/widgets/elf_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElfPage extends ConsumerWidget {
  const ElfPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elfs = ref.read(elfProvider).elfs;
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
              child: SizedBox(
                width: 1064,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Select an Elf/AstralOP',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                      flex: 3,
                      child: GridView.builder(
                        itemCount: elfs.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 40,
                        ),
                        itemBuilder: (context, index) {
                          return ElfCard(
                            id: elfs[index].id,
                            name: elfs[index].name,
                            overview: elfs[index].overview,
                          );
                        },
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
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
