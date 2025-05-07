import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/abyss_page.dart';
import 'package:flutter_honkai/pages/arena_page.dart';
import 'package:flutter_honkai/pages/crystal_cal_page.dart';
import 'package:flutter_honkai/pages/favorite_page.dart';
import 'package:flutter_honkai/pages/elf_page.dart';
import 'package:flutter_honkai/pages/home_page.dart';
import 'package:flutter_honkai/pages/valkyries_page.dart';
import 'package:flutter_honkai/widgets/top_navi_child.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int currentnavi = 0;

  void onTap(int index) {
    setState(() {
      currentnavi = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TopNaviChild(
                  text: 'Home',
                  isSelected: currentnavi == 0,
                  onTap: () => onTap(0),
                ),
              ),
              Expanded(
                child: TopNaviChild(
                  text: 'Valkyries',
                  isSelected: currentnavi == 1,
                  onTap: () => onTap(1),
                ),
              ),
              Expanded(
                child: TopNaviChild(
                  text: 'Elf/AstralOP',
                  isSelected: currentnavi == 2,
                  onTap: () => onTap(2),
                ),
              ),
              Expanded(
                child: TopNaviChild(
                  text: 'Abyss',
                  isSelected: currentnavi == 3,
                  onTap: () => onTap(3),
                ),
              ),
              Expanded(
                child: TopNaviChild(
                  text: 'Arena',
                  isSelected: currentnavi == 4,
                  onTap: () => onTap(4),
                ),
              ),
              Expanded(
                child: TopNaviChild(
                  text: 'Favorites',
                  isSelected: currentnavi == 5,
                  onTap: () => onTap(5),
                ),
              ),
              Expanded(
                child: TopNaviChild(
                  text: 'Crystal Calculator',
                  isSelected: currentnavi == 6,
                  onTap: () => onTap(6),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: currentnavi,
        children: [
          HomePage(),
          ValkyriesPage(),
          ElfPage(),
          AbyssPage(),
          ArenaPage(),
          FavoritePage(),
          CrystalCalPage(),
        ],
      ),
    );
  }
}
