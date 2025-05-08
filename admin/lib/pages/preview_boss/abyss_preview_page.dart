import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/pages/preview_boss/abyssboss_preview_details_page.dart';
import 'package:flutter_honkai/pages/preview_boss/preview_boss_card.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbyssPreviewPage extends ConsumerStatefulWidget {
  final AbyssBossModel previewBoss;
  final String imagePath;
  const AbyssPreviewPage({
    super.key,
    required this.previewBoss,
    required this.imagePath,
  });

  @override
  ConsumerState<AbyssPreviewPage> createState() => _AbyssPreviewPageState();
}

class _AbyssPreviewPageState extends ConsumerState<AbyssPreviewPage> {
  final TextEditingController dropdownMenuController = TextEditingController(
    text: 'All',
  );
  String selectedWeather = 'all';

  @override
  Widget build(BuildContext context) {
    final weathers = ref.read(weatherProvider).weathers;
    final bosses = [widget.previewBoss];
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
                      requestFocusOnTap: true,
                      enableFilter: true,
                      initialSelection: 'all',
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
                            final List teamrec = filteredBosses[index].teamrec;
                            return PreviewBossCard(
                              id: id,
                              name: name,
                              imagePath: widget.imagePath,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AbyssbossPreviewDetailsPage(
                                        id: id,
                                        name: name,
                                        imagePath: widget.imagePath,
                                        weatherName: weather.name,
                                        weatherSpecific: weather.specific,
                                        mechanic: mechanic,
                                        resistance: resistance,
                                        teamrec: teamrec,
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
