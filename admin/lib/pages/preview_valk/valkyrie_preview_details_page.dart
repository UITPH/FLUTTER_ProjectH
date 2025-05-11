import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/preview_valk/valkyrie_overview_page.dart';
import 'package:flutter_honkai/pages/preview_valk/valkyrie_preview_equipment_page.dart';
import 'package:flutter_honkai/pages/preview_valk/valkyrie_preview_lineup_page.dart';
import 'package:flutter_honkai/pages/preview_valk/valkyrie_rankup_page.dart';
import 'package:flutter_honkai/widgets/valk_navi_child.dart';

class ValkyriePreviewDetailsPage extends StatefulWidget {
  final String name;
  final String id;
  final Widget valkImage;
  final Widget weapImage;
  final Widget topImage;
  final Widget midImage;
  final Widget botImage;
  final List lineup;
  final String role;
  final String pullrec;
  final String rankup;

  const ValkyriePreviewDetailsPage({
    super.key,
    required this.name,
    required this.id,
    required this.valkImage,
    required this.weapImage,
    required this.topImage,
    required this.midImage,
    required this.botImage,
    required this.lineup,
    required this.role,
    required this.pullrec,
    required this.rankup,
  });

  @override
  State<ValkyriePreviewDetailsPage> createState() =>
      _ValkyriePreviewDetailsPageState();
}

class _ValkyriePreviewDetailsPageState
    extends State<ValkyriePreviewDetailsPage> {
  int currentnavi = 0;
  late Future<Map<String, String>> dataFuture;

  void onTap(int index) {
    setState(() {
      currentnavi = index;
    });
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
          ValkyriePreviewLineupPage(
            id: widget.id,
            valkImage: widget.valkImage,
            lineup: widget.lineup,
          ),
          ValkyriePreviewEquipmentPage(
            weapImage: widget.weapImage,
            topImage: widget.topImage,
            midImage: widget.midImage,
            botImage: widget.botImage,
          ),
          ValkyrieRankupPage(rankup: widget.rankup),
        ],
      ),
    );
  }
}
