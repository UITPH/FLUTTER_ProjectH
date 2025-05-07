import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_equipment_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_lineup_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_overview_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_rankup_page.dart';
import 'package:flutter_honkai/widgets/valk_navi_child.dart';

class ValkyrieDetailsPage extends StatefulWidget {
  final String name;
  final String id;
  final List equipment;
  final List lineup;
  final String role;
  final String pullrec;
  final String rankup;

  const ValkyrieDetailsPage({
    super.key,
    required this.name,
    required this.id,
    required this.equipment,
    required this.lineup,
    required this.role,
    required this.pullrec,
    required this.rankup,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          widget.name,
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
          ValkyrieOverviewPage(role: widget.role, pullrec: widget.pullrec),
          ValkyrieLineupPage(lineup: widget.lineup),
          ValkyrieEquipmentPage(
            id: widget.id,
            weapimageName: widget.equipment[0],
            topimageName: widget.equipment[1],
            midimageName: widget.equipment[2],
            botimageName: widget.equipment[3],
          ),
          ValkyrieRankupPage(rankup: widget.rankup),
        ],
      ),
    );
  }
}
