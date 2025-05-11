import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/widgets/advanced_elf_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteElfPage extends ConsumerWidget {
  const DeleteElfPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elfs = ref.watch(elfProvider).elfs;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Delete Elf Page'),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1064,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select an Elf/AstralOP to delete',
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisExtent: 200,
                    ),
                    itemBuilder: (context, index) {
                      final id = elfs[index].id;
                      final name = elfs[index].name;
                      return AdvancedElfCard(id: id, name: name);
                    },
                  ),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
