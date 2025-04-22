import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_equipment_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_lineup_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_overview_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_pages/valkyrie_rankup_page.dart';
import 'package:flutter_honkai/widgets/valk_navi_child.dart';

class ValkyrieDetailsPage extends StatefulWidget {
  const ValkyrieDetailsPage({super.key});

  @override
  State<ValkyrieDetailsPage> createState() => _ValkyrieDetailsPageState();
}

class _ValkyrieDetailsPageState extends State<ValkyrieDetailsPage> {
  int currentnavi = 0;

  void onTap(int index) {
    setState(() {
      currentnavi = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('data'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
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
      ),
      body: IndexedStack(
        index: currentnavi,
        children: [
          ValkyrieOverviewPage(),
          ValkyrieLineupPage(),
          ValkyrieEquipmentPage(),
          ValkyrieRankupPage(),
        ],
      ),
    );
  }
}
