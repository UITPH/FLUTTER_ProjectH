import 'package:flutter/material.dart';
import 'package:flutter_honkai/widgets/boss_card.dart';

class AbyssPage extends StatefulWidget {
  const AbyssPage({super.key});

  @override
  State<AbyssPage> createState() => _AbyssPageState();
}

class _AbyssPageState extends State<AbyssPage> {
  // Consider this List is json file
  List<Map<String, String>> weathers = [
    {"value": "bleed", "label": "Bleed"},
    {"value": "blood", "label": "Bloodthirsty"},
    {"value": "dominance", "label": "Dominance"},
    {"value": "ice", "label": "Ice"},
  ];
  List<Map<String, String>> bosses = [
    {'name': 'Raven', 'imageName': 'raven.png', 'weather': 'ice'},
    {'name': '36mobs', 'imageName': '36mobs.png', 'weather': 'blood'},
    {'name': 'Hos', 'imageName': 'hos.png', 'weather': 'bleed'},
    {'name': 'Apo', 'imageName': 'Apo.png', 'weather': 'dominance'},
    // Add more valkyries as needed
  ];

  late final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  List<Map<String, String>> filteredBosses = [];

  void applyFilters(String selectedWeather) {
    filteredBosses =
        bosses.where((boss) => boss['weather'] == selectedWeather).toList();
  }

  @override
  void initState() {
    super.initState();
    dropdownMenuEntries =
        weathers
            .map(
              (item) => DropdownMenuEntry<String>(
                value: item['value']!,
                label: item['label']!,
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
                            final String name = filteredBosses[index]['name']!;
                            final String imageName =
                                filteredBosses[index]['imageName']!;
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
