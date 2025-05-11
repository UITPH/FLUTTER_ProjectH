import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'package:flutter_honkai/widgets/delete_abyssboss_card.dart';
import 'package:flutter_honkai/widgets/delete_arenaboss_card.dart';
import 'package:flutter_honkai/widgets/delete_elf_card.dart';
import 'package:flutter_honkai/widgets/delete_valk_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeletePage extends ConsumerWidget {
  const DeletePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valkDeletes = ref.watch(deleteProvider).valkDeletes;
    final abyssbossDeletes = ref.watch(deleteProvider).abyssbossDeletes;
    final arenabossDeletes = ref.watch(deleteProvider).arenabossDeletes;
    final elfDeletes = ref.watch(deleteProvider).elfDeletes;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(style: TextStyle(fontWeight: FontWeight.bold), 'Restore'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/quantasea.png'),
              opacity: AlwaysStoppedAnimation(0.2),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              'Deleted Valkyries',
                            ),
                          ),
                          Wrap(
                            runSpacing: 30,
                            children: List.generate(valkDeletes.length, (
                              index,
                            ) {
                              final String id = valkDeletes[index].id;
                              final String name = valkDeletes[index].name;
                              return SizedBox(
                                width: 150,
                                child: DeleteValkCard(id: id, name: name),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              'Deleted Elfs',
                            ),
                          ),
                          Wrap(
                            runSpacing: 30,
                            children: List.generate(elfDeletes.length, (index) {
                              final String id = elfDeletes[index].id;
                              final String name = elfDeletes[index].name;
                              return SizedBox(
                                width: 150,
                                child: DeleteElfCard(id: id, name: name),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              'Deleted Abyss Bosses',
                            ),
                          ),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: List.generate(abyssbossDeletes.length, (
                              index,
                            ) {
                              final String id = abyssbossDeletes[index].id;
                              final String name = abyssbossDeletes[index].name;
                              return SizedBox(
                                width: 180,
                                child: DeleteAbyssbossCard(id: id, name: name),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              'Deleted Arena Bosses',
                            ),
                          ),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: List.generate(arenabossDeletes.length, (
                              index,
                            ) {
                              final String id = arenabossDeletes[index].id;
                              final String name = arenabossDeletes[index].name;
                              return SizedBox(
                                width: 180,
                                child: DeleteArenabossCard(id: id, name: name),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
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
