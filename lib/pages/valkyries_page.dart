import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/pages/valkyrie_details_page.dart';
import 'package:flutter_honkai/widgets/valk_astralop_filter.dart';
import 'package:flutter_honkai/widgets/valk_card.dart';
import 'package:flutter_honkai/widgets/valk_type_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';

class ValkyriesPage extends ConsumerStatefulWidget {
  const ValkyriesPage({super.key});

  @override
  ConsumerState<ValkyriesPage> createState() => _ValkyriesPageState();
}

class _ValkyriesPageState extends ConsumerState<ValkyriesPage> {
  int astralopFilter = 0;
  int typeFilter = 0;
  int dameFilter = 0;

  List<ValkyrieModel> valkyries = [];
  List<ValkyrieModel> filteredValkyries = [];

  //dummy data
  final List<String> overview = ['role.txt', 'pullrec.txt'];
  //FWS PS LP TFM RS JDS HoH teri kiana ds
  final List<Map<String, dynamic>> lineup = [
    {
      "note": "Ba-dum! Fiery Wishing Star DPS",
      "leader": "FWS.png",
      "firstvalks": [
        "PS.png",
        "LP.png",
        "TFM.png",
        "RS.png",
        "JDS.png",
        "HoH.png",
      ],
      "secondvalks": [],
      "elfs": ["teri.png", "kiana.png", "ds.png"],
    },
    {
      "note": "Reign Solaris DPS",
      "leader": "RS.png",
      "firstvalks": ["FWS.png"],
      "secondvalks": [
        "PS.png",
        "LP.png",
        "TFM.png",
        "RS.png",
        "JDS.png",
        "HoH.png",
      ],
      "elfs": ["teri.png", "sera.png", "bunny.png", "ds.png", "songque.png"],
    },
  ];
  final List<String> equip = [
    'fwsweap.png',
    'fwstop.png',
    'fwsmid.png',
    'fwsbot.png',
  ];
  final String rankup = 'rankup.txt';

  @override
  void initState() {
    super.initState();
    valkyries = ref.read(valkyrieProvider);
    applyFilters();
  }

  void onDameFilterTap(int index) {
    setState(() {
      dameFilter = index;
      applyFilters();
    });
  }

  void onTypeFilterTap(int index) {
    setState(() {
      typeFilter = index;
      applyFilters();
    });
  }

  void onAstralopFilterTap(int index) {
    setState(() {
      astralopFilter = index;
      applyFilters();
    });
  }

  bool valkdame(List listdame, int filter) {
    for (int i = 0; i < listdame.length; i++) {
      if (listdame[i] == filter) {
        return true;
      }
    }
    return false;
  }

  void applyFilters() {
    filteredValkyries =
        valkyries.where((valk) {
          bool matchesAstralop =
              astralopFilter == 0 || valk.astralop == astralopFilter;
          bool matchesType = typeFilter == 0 || valk.type == typeFilter;
          bool matchesDame = dameFilter == 0 || valkdame(valk.dame, dameFilter);
          return matchesAstralop && matchesType && matchesDame;
        }).toList();
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
              image: AssetImage('lib/assets/images/futurebridge.png'),
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
                        'Select a Valkyrie',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 70,
                            width: 500,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 15,
                              children: [
                                ValkTypeFilter(
                                  imageName: 'null.png',
                                  onTap: () => onTypeFilterTap(0),
                                  isSelected: typeFilter == 0,
                                ),
                                ValkTypeFilter(
                                  imageName: 'mech.png',
                                  onTap: () => onTypeFilterTap(1),
                                  isSelected: typeFilter == 1,
                                ),
                                ValkTypeFilter(
                                  imageName: 'bio.png',
                                  onTap: () => onTypeFilterTap(2),
                                  isSelected: typeFilter == 2,
                                ),
                                ValkTypeFilter(
                                  imageName: 'psy.png',
                                  onTap: () => onTypeFilterTap(3),
                                  isSelected: typeFilter == 3,
                                ),
                                ValkTypeFilter(
                                  imageName: 'qua.png',
                                  onTap: () => onTypeFilterTap(4),
                                  isSelected: typeFilter == 4,
                                ),
                                ValkTypeFilter(
                                  imageName: 'img.png',
                                  onTap: () => onTypeFilterTap(5),
                                  isSelected: typeFilter == 5,
                                ),
                                ValkTypeFilter(
                                  imageName: 'sd.png',
                                  onTap: () => onTypeFilterTap(6),
                                  isSelected: typeFilter == 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 70,
                            width: 500,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 15,
                              children: [
                                ValkTypeFilter(
                                  imageName: 'null.png',
                                  onTap: () => onDameFilterTap(0),
                                  isSelected: dameFilter == 0,
                                ),
                                ValkTypeFilter(
                                  imageName: 'fire.png',
                                  onTap: () => onDameFilterTap(1),
                                  isSelected: dameFilter == 1,
                                ),
                                ValkTypeFilter(
                                  imageName: 'ice.png',
                                  onTap: () => onDameFilterTap(2),
                                  isSelected: dameFilter == 2,
                                ),
                                ValkTypeFilter(
                                  imageName: 'lightning.png',
                                  onTap: () => onDameFilterTap(3),
                                  isSelected: dameFilter == 3,
                                ),
                                ValkTypeFilter(
                                  imageName: 'phys.png',
                                  onTap: () => onDameFilterTap(4),
                                  isSelected: dameFilter == 4,
                                ),
                                ValkTypeFilter(
                                  imageName: 'bleed.png',
                                  onTap: () => onDameFilterTap(5),
                                  isSelected: dameFilter == 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      width: 1032,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValkAstralopFilter(
                            text: 'All',
                            onTap: () => onAstralopFilterTap(0),
                            isSelected: astralopFilter == 0,
                          ),
                          ValkAstralopFilter(
                            text: 'Law Of Ascension',
                            onTap: () => onAstralopFilterTap(1),
                            isSelected: astralopFilter == 1,
                          ),
                          ValkAstralopFilter(
                            text: 'Wheels of Destiny',
                            onTap: () => onAstralopFilterTap(2),
                            isSelected: astralopFilter == 2,
                          ),
                          ValkAstralopFilter(
                            text: 'Rite of Oblivion',
                            onTap: () => onAstralopFilterTap(3),
                            isSelected: astralopFilter == 3,
                          ),
                          ValkAstralopFilter(
                            text: 'World Star',
                            onTap: () => onAstralopFilterTap(4),
                            isSelected: astralopFilter == 4,
                          ),
                          ValkAstralopFilter(
                            text: 'Part 1',
                            onTap: () => onAstralopFilterTap(5),
                            isSelected: astralopFilter == 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Expanded(
                      child: GridView.builder(
                        itemCount: filteredValkyries.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 40,
                        ),
                        itemBuilder: (context, index) {
                          final String label = filteredValkyries[index].label;
                          final String imageName =
                              filteredValkyries[index].imageName;
                          return ValkCard(
                            label: label,
                            imageName: imageName,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => ValkyrieDetailsPage(
                                        label: label,
                                        overview: overview,
                                        lineup: lineup,
                                        equip: equip,
                                        rankup: rankup,
                                      ),
                                ),
                              );
                            },
                          );
                        },
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
