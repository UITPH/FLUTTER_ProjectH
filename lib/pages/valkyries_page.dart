import 'package:flutter/material.dart';
import 'package:flutter_honkai/widgets/valk_astralop_filter.dart';
import 'package:flutter_honkai/widgets/valk_card.dart';
import 'package:flutter_honkai/widgets/valk_type_filter.dart';

class ValkyriesPage extends StatefulWidget {
  const ValkyriesPage({super.key});

  @override
  State<ValkyriesPage> createState() => _ValkyriesPageState();
}

class _ValkyriesPageState extends State<ValkyriesPage> {
  int astralopFilter = 0;
  int typeFilter = 0;
  int dameFilter = 0;

  List<Map<String, dynamic>> valkyries = [
    {'name': 'sú', 'imageName': 'physsus.png'},
    {'name': 'sparkle', 'imageName': 'sparkle.png'},
    {'name': 'vita', 'imageName': 'lp.png'},
    {'name': 'hoh', 'imageName': 'hoh.png'},
    {'name': 'dudufbi', 'imageName': 'duduloli.png'},
    // Add more valkyries as needed
  ];

  void onDameFilterTap(int index) {
    setState(() {
      dameFilter = index;
    });
  }

  void onTypeFilterTap(int index) {
    setState(() {
      typeFilter = index;
    });
  }

  void onAstralopFilterTap(int index) {
    setState(() {
      astralopFilter = index;
    });
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
                                  imageName: 'lightning.png',
                                  onTap: () => onDameFilterTap(1),
                                  isSelected: dameFilter == 1,
                                ),
                                ValkTypeFilter(
                                  imageName: 'ice.png',
                                  onTap: () => onDameFilterTap(2),
                                  isSelected: dameFilter == 2,
                                ),
                                ValkTypeFilter(
                                  imageName: 'fire.png',
                                  onTap: () => onDameFilterTap(3),
                                  isSelected: dameFilter == 3,
                                ),
                                ValkTypeFilter(
                                  imageName: 'phys.png',
                                  onTap: () => onDameFilterTap(4),
                                  isSelected: dameFilter == 4,
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
                        itemCount: 5,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 40,
                        ),
                        itemBuilder: (context, index) {
                          final String name = valkyries[index]['name'];
                          final String imageName =
                              valkyries[index]['imageName'];
                          return ValkCard(name: name, imageName: imageName);
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
