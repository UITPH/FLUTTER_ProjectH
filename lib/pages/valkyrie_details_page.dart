import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_equipment_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_lineup_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_overview_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_rankup_page.dart';
import 'package:flutter_honkai/widgets/valk_navi_child.dart';
import 'package:path_provider/path_provider.dart';

class ValkyrieDetailsPage extends StatefulWidget {
  final String label;
  final String id;
  final List<dynamic> lineup;
  final List<dynamic> equip;
  const ValkyrieDetailsPage({
    super.key,
    required this.label,
    required this.id,
    required this.lineup,
    required this.equip,
  });

  @override
  State<ValkyrieDetailsPage> createState() => _ValkyrieDetailsPageState();
}

class _ValkyrieDetailsPageState extends State<ValkyrieDetailsPage> {
  int currentnavi = 0;
  late Future<Map<String, String>> dataFuture;

  void onTap(int index) {
    setState(() {
      currentnavi = index;
    });
  }

  Future<Map<String, String>> loadData() async {
    final dir = await getApplicationDocumentsDirectory();
    final roleFile = File(
      '${dir.path}/Honkai Station/text/${widget.id}/role.txt',
    );
    final pullrecFile = File(
      '${dir.path}/Honkai Station/text/${widget.id}/pullrec.txt',
    );
    final rankupFile = File(
      '${dir.path}/Honkai Station/text/${widget.id}/rankup.txt',
    );

    final role = await roleFile.readAsString();
    final pullrec = await pullrecFile.readAsString();
    final rankup = await rankupFile.readAsString();

    return {'role': role, 'pullrec': pullrec, 'rankup': rankup};
  }

  @override
  void initState() {
    super.initState();
    dataFuture = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final data = snapshot.data!;

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                widget.label,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: SizedBox(
                  width: 1064,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ValkNaviChild(
                          text: 'Overview',
                          onTap: () => onTap(0),
                          isSelected: currentnavi == 0,
                        ),
                      ),
                      Expanded(
                        child: ValkNaviChild(
                          text: 'Lineup',
                          onTap: () => onTap(1),
                          isSelected: currentnavi == 1,
                        ),
                      ),
                      Expanded(
                        child: ValkNaviChild(
                          text: 'Equipment',
                          onTap: () => onTap(2),
                          isSelected: currentnavi == 2,
                        ),
                      ),
                      Expanded(
                        child: ValkNaviChild(
                          text: 'Rank Up',
                          onTap: () => onTap(3),
                          isSelected: currentnavi == 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: IndexedStack(
              index: currentnavi,
              children: [
                ValkyrieOverviewPage(
                  role: data['role']!,
                  pullrec: data['pullrec']!,
                ),
                ValkyrieLineupPage(lineup: widget.lineup),
                ValkyrieEquipmentPage(
                  weapimageName: widget.equip[0],
                  topimageName: widget.equip[1],
                  midimageName: widget.equip[2],
                  botimageName: widget.equip[3],
                ),
                ValkyrieRankupPage(rankup: data['rankup']!),
              ],
            ),
          );
        }
      },
    );
  }
}
