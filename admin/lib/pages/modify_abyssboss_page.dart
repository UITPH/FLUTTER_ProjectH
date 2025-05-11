import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/widgets/modify_abyssboss_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModifyAbyssbossPage extends ConsumerStatefulWidget {
  const ModifyAbyssbossPage({super.key});

  @override
  ConsumerState<ModifyAbyssbossPage> createState() =>
      _ModifyAbyssbossPageState();
}

class _ModifyAbyssbossPageState extends ConsumerState<ModifyAbyssbossPage> {
  List<AbyssBossModel> filteredBosses = [];
  final TextEditingController dropdownMenuController = TextEditingController(
    text: 'All',
  );

  String selectedWeather = 'all';

  @override
  Widget build(BuildContext context) {
    final bosses = ref.watch(abyssBossProvider).bosses;
    final weathers = ref.read(weatherProvider).weathers;
    final filteredBosses =
        bosses
            .where(
              (boss) =>
                  selectedWeather == 'all' || boss.idWeather == selectedWeather,
            )
            .toList();
    final dropdownMenuEntries =
        weathers
            .map(
              (item) =>
                  DropdownMenuEntry<String>(label: item.name, value: item.id),
            )
            .toList();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
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
                  controller: dropdownMenuController,
                  initialSelection: 'all',
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
                        return ModifyAbyssbossCard(boss: filteredBosses[index]);
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
