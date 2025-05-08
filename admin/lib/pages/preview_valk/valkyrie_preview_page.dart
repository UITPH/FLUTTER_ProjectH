import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/pages/preview_valk/preview_valk_card.dart';
import 'package:flutter_honkai/pages/preview_valk/valkyrie_preview_details_page.dart';
import 'package:flutter_honkai/widgets/valk_astralop_filter.dart';
import 'package:flutter_honkai/widgets/valk_type_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyriePreviewPage extends ConsumerStatefulWidget {
  final ValkyrieModel previewValkyrie;
  final String valkImagePath;
  final String weapImagePath;
  final String topImagePath;
  final String midImagePath;
  final String botImagePath;
  const ValkyriePreviewPage({
    super.key,
    required this.previewValkyrie,
    required this.valkImagePath,
    required this.weapImagePath,
    required this.topImagePath,
    required this.midImagePath,
    required this.botImagePath,
  });

  @override
  ConsumerState<ValkyriePreviewPage> createState() =>
      _ValkyriePreviewPageState();
}

class _ValkyriePreviewPageState extends ConsumerState<ValkyriePreviewPage> {
  int astralopFilter = 0;
  int typeFilter = 0;
  int dameFilter = 0;

  List<ValkyrieModel> valkyries = [];
  List<ValkyrieModel> filteredValkyries = [];

  @override
  void initState() {
    valkyries.add(widget.previewValkyrie);
    super.initState();
  }

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

  bool valkdame(List listdame, int filter) {
    for (int i = 0; i < listdame.length; i++) {
      if (listdame[i] == filter) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    filteredValkyries =
        valkyries.where((valk) {
          bool matchesAstralop =
              astralopFilter == 0 || valk.astralop == astralopFilter;
          bool matchesType = typeFilter == 0 || valk.type == typeFilter;
          bool matchesDame =
              dameFilter == 0 || valkdame(valk.damage, dameFilter);
          return matchesAstralop && matchesType && matchesDame;
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('PREVIEW')),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisExtent: 200,
                        ),
                        itemBuilder: (context, index) {
                          final String id = filteredValkyries[index].id;
                          final String name = filteredValkyries[index].name;
                          final String role = filteredValkyries[index].role;
                          final String pullrec =
                              filteredValkyries[index].pullrec;
                          final String rankup = filteredValkyries[index].rankup;
                          final List lineup = filteredValkyries[index].lineup;
                          return PreviewValkCard(
                            name: name,
                            valkImagePath: widget.valkImagePath,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => ValkyriePreviewDetailsPage(
                                        name: name,
                                        id: id,
                                        lineup: lineup,
                                        valkImagePath: widget.valkImagePath,
                                        weapImagePath: widget.weapImagePath,
                                        topImagePath: widget.topImagePath,
                                        midImagePath: widget.midImagePath,
                                        botImagePath: widget.botImagePath,
                                        role: role,
                                        pullrec: pullrec,
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
