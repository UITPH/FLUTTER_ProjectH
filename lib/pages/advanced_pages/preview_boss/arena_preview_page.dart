import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/pages/advanced_pages/preview_boss/arenaboss_preview_details_page.dart';
import 'package:flutter_honkai/pages/advanced_pages/preview_boss/preview_boss_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenaPreviewPage extends ConsumerStatefulWidget {
  final ArenaBossModel previewBoss;
  final String imagePath;
  const ArenaPreviewPage({
    super.key,
    required this.previewBoss,
    required this.imagePath,
  });

  @override
  ConsumerState<ArenaPreviewPage> createState() => _ArenaPreviewPageState();
}

class _ArenaPreviewPageState extends ConsumerState<ArenaPreviewPage> {
  List<Map<String, dynamic>> rank = [
    {'label': 'SS', 'value': 2},
    {'label': 'SSS', 'value': 3},
  ];

  int selectedRank = -1;

  @override
  Widget build(BuildContext context) {
    final bosses = [widget.previewBoss];
    final filteredBosses =
        bosses
            .where((boss) => selectedRank == 0 || boss.rank == selectedRank)
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
      appBar: AppBar(title: Text('Preview')),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/citybridge.jpg'),
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
                      requestFocusOnTap: false,
                      hintText: 'Type or select a rank',
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
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 40,
                              ),
                          itemBuilder: (context, index) {
                            final String id = filteredBosses[index].id;
                            final String name = filteredBosses[index].name;
                            final int rank = filteredBosses[index].rank;
                            final List firstValk =
                                filteredBosses[index].firstValk;
                            final List secondValk =
                                filteredBosses[index].secondValk;
                            final List thirdValk =
                                filteredBosses[index].thirdValk;
                            final List elf = filteredBosses[index].elf;
                            return PreviewBossCard(
                              id: id,
                              name: name,
                              imagePath: widget.imagePath,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ArenabossPreviewDetailsPage(
                                        id: id,
                                        name: name,
                                        imagePath: widget.imagePath,
                                        rank: rank,
                                        firstValk: firstValk,
                                        secondValk: secondValk,
                                        thirdValk: thirdValk,
                                        elf: elf,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
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
