import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'package:flutter_honkai/widgets/delete_abyssboss_card.dart';
import 'package:flutter_honkai/widgets/delete_arenaboss_card.dart';
import 'package:flutter_honkai/widgets/delete_valk_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeletePage extends ConsumerWidget {
  const DeletePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valkDeletes = ref.watch(deleteProvider).valkDeletes;
    final abyssbossDeletes = ref.watch(deleteProvider).abyssbossDeletes;
    final arenabossDeletes = ref.watch(deleteProvider).arenabossDeletes;
    return Scaffold(
      appBar: AppBar(title: Text('Restore')),
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 35,
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 35,
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
                                width: 200,
                                child: DeleteAbyssbossCard(id: id, name: name),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 35,
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
                                width: 200,
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
