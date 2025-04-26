import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/boss_model.dart';
import 'package:flutter_honkai/providers/boss_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/widgets/advanced_boss_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteAbyssBossPage extends ConsumerStatefulWidget {
  const DeleteAbyssBossPage({super.key});

  @override
  ConsumerState<DeleteAbyssBossPage> createState() =>
      _DeleteAbyssBossPageState();
}

class _DeleteAbyssBossPageState extends ConsumerState<DeleteAbyssBossPage> {
  // Consider this List is json file
  List<BossModel> filteredBosses = [];
  String selectedWeather = '';

  @override
  Widget build(BuildContext context) {
    final bosses = ref.watch(bossProvider).bosses;
    final weathers = ref.read(weatherProvider).weathers;
    final filteredBosses =
        bosses
            .where(
              (boss) =>
                  selectedWeather == 'all' || boss.weather == selectedWeather,
            )
            .toList();
    final dropdownMenuEntries =
        weathers
            .map(
              (item) => DropdownMenuEntry<String>(
                label: item.label,
                value: item.value,
              ),
            )
            .toList();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        //foregroundColor: Colors.transparent,
        title: Text('Delete Abyss Boss Page'),
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
                    'Abyss Boss Database',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownMenu(
                  hintText: 'Type or select a weather',
                  requestFocusOnTap: true,
                  enableFilter: true,
                  width: 250,
                  menuHeight: 250,
                  menuStyle: MenuStyle(),
                  dropdownMenuEntries: dropdownMenuEntries,
                  onSelected: (value) {
                    setState(() {
                      if (value != null) {
                        selectedWeather = value;
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
                        final String label = filteredBosses[index].label;
                        final String id = filteredBosses[index].id;
                        final String imageName =
                            filteredBosses[index].imageName;
                        return AdvancedBossCard(
                          label: label,
                          id: id,
                          imageName: imageName,
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
    );
  }
}
