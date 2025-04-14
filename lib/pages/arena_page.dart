import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/boss_model.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/providers/boss_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/widgets/boss_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenaPage extends ConsumerStatefulWidget {
  const ArenaPage({super.key});

  @override
  ConsumerState<ArenaPage> createState() => _ArenaPageState();
}

class _ArenaPageState extends ConsumerState<ArenaPage> {
  // Consider this List is json file
  List<WeatherModel> weathers = [];
  List<BossModel> bosses = [];

  late final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  List<BossModel> filteredBosses = [];

  void applyFilters(String selectedWeather) {
    filteredBosses =
        bosses.where((boss) => boss.weather == selectedWeather).toList();
  }

  @override
  void initState() {
    super.initState();
    bosses = ref.read(bossProvider);
    weathers = ref.read(weatherProvider);
    dropdownMenuEntries =
        weathers
            .map(
              (item) => DropdownMenuEntry<String>(
                label: item.label,
                value: item.value,
              ),
            )
            .toList();
  }

  @override
  Widget build(BuildContext context) {
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
                      menuStyle: MenuStyle(),
                      dropdownMenuEntries: dropdownMenuEntries,
                      onSelected: (selectedWeather) {
                        setState(() {
                          if (selectedWeather != null) {
                            applyFilters(selectedWeather);
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
                            final String name = filteredBosses[index].name;
                            final String imageName =
                                filteredBosses[index].imageName;
                            return BossCard(name: name, imageName: imageName);
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
