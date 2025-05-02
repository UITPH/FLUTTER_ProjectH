import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/pages/abyss_boss_details_page.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/favorite_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/widgets/abyss_boss_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbyssPage extends ConsumerStatefulWidget {
  const AbyssPage({super.key});

  @override
  ConsumerState<AbyssPage> createState() => _AbyssPageState();
}

class _AbyssPageState extends ConsumerState<AbyssPage> {
  // Consider this List is json file
  List<WeatherModel> weathers = [];

  String selectedWeather = '';

  @override
  Widget build(BuildContext context) {
    final favorite = ref.watch(favoriteProvider);
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
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 40,
                              ),
                          itemBuilder: (context, index) {
                            final bool isFav = favorite.isAbyssBossFavorite(
                              filteredBosses[index].id,
                            );
                            final WeatherModel weather =
                                weathers
                                    .where(
                                      (weather) =>
                                          weather.id ==
                                          filteredBosses[index].idWeather,
                                    )
                                    .toList()[0];
                            final String id = filteredBosses[index].id;
                            final String name = filteredBosses[index].name;
                            final String mechanic =
                                filteredBosses[index].mechanic;
                            final String resistance =
                                filteredBosses[index].resistance;
                            final List firstValk =
                                filteredBosses[index].firstValk;
                            final List secondValk =
                                filteredBosses[index].secondValk;
                            final List thirdValk =
                                filteredBosses[index].thirdValk;
                            final List elf = filteredBosses[index].elf;
                            final List note = filteredBosses[index].note;
                            return AbyssBossCard(
                              id: id,
                              name: name,
                              isFav: isFav,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AbyssBossDetailsPage(
                                        id: id,
                                        name: name,
                                        weatherName: weather.name,
                                        weatherSpecific: weather.specific,
                                        mechanic: mechanic,
                                        resistance: resistance,
                                        firstValk: firstValk,
                                        secondValk: secondValk,
                                        thirdValk: thirdValk,
                                        elf: elf,
                                        note: note,
                                      );
                                    },
                                  ),
                                );
                              },
                              onSecondaryTap: () {
                                ref
                                    .read(favoriteProvider)
                                    .toggleAbyssBoss(filteredBosses[index].id);
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
