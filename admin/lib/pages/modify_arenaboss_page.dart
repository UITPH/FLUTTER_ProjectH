import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/widgets/modify_arenaboss_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModifyArenabossPage extends ConsumerStatefulWidget {
  const ModifyArenabossPage({super.key});

  @override
  ConsumerState<ModifyArenabossPage> createState() =>
      _ModifyArenabossPageState();
}

class _ModifyArenabossPageState extends ConsumerState<ModifyArenabossPage> {
  final TextEditingController dropdownMenuController = TextEditingController(
    text: 'All',
  );
  List<Map<String, dynamic>> rank = [
    {'label': 'All', 'value': 1},
    {'label': 'SS', 'value': 2},
    {'label': 'SSS', 'value': 3},
  ];

  int selectedRank = 1;

  @override
  Widget build(BuildContext context) {
    final bosses = ref.watch(arenabossProvider).bosses;
    final filteredBosses =
        bosses
            .where((boss) => selectedRank == 1 || boss.rank == selectedRank)
            .toList();
    final dropdownMenuEntries =
        rank
            .map(
              (item) => DropdownMenuEntry<int>(
                label: item['label'],
                value: item['value'],
              ),
            )
            .toList();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Modify Arena Boss Page'),
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
                    'Arena Boss Database',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownMenu(
                  controller: dropdownMenuController,
                  initialSelection: 1,
                  requestFocusOnTap: false,
                  hintText: 'Select a rank',
                  width: 250,
                  menuHeight: 250,
                  menuStyle: MenuStyle(),
                  dropdownMenuEntries: dropdownMenuEntries,
                  onSelected: (value) {
                    setState(() {
                      if (value != null) {
                        selectedRank = value;
                      }
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: GridView.builder(
                      itemCount: filteredBosses.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 40,
                        mainAxisSpacing: 40,
                      ),
                      itemBuilder: (context, index) {
                        return ModifyArenabossCard(boss: filteredBosses[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
