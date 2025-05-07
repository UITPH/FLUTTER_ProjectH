import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/arena_boss_details_page.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/providers/favorite_provider.dart';
import 'package:flutter_honkai/widgets/arena_boss_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenaPage extends ConsumerStatefulWidget {
  const ArenaPage({super.key});

  @override
  ConsumerState<ArenaPage> createState() => _AbyssPageState();
}

class _AbyssPageState extends ConsumerState<ArenaPage> {
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
    final favorite = ref.watch(favoriteProvider);
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
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 40,
                              ),
                          itemBuilder: (context, index) {
                            final bool isFav = favorite.isArenaBossFavorite(
                              filteredBosses[index].id,
                            );
                            final String id = filteredBosses[index].id;
                            final String name = filteredBosses[index].name;
                            final int rank = filteredBosses[index].rank;
                            final List teamrec = filteredBosses[index].teamrec;
                            return ArenaBossCard(
                              id: id,
                              name: name,
                              isFav: isFav,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ArenaBossDetailsPage(
                                        id: id,
                                        name: name,
                                        rank: rank,
                                        teamrec: teamrec,
                                      );
                                    },
                                  ),
                                );
                              },
                              onSecondaryTap: () {
                                ref
                                    .read(favoriteProvider)
                                    .toggleArenaBoss(filteredBosses[index].id);
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
