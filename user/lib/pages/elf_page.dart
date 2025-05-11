import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/elf_overview_page.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/favorite_provider.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/widgets/elf_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElfPage extends ConsumerWidget {
  const ElfPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(imageVersionProvider);
    final elfs = ref.watch(elfProvider).elfs;
    final favories = ref.watch(favoriteProvider);
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
                        'Select an Elf/AstralOP',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                      flex: 3,
                      child: GridView.builder(
                        itemCount: elfs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisExtent: 200,
                        ),
                        itemBuilder: (context, index) {
                          final id = elfs[index].id;
                          final name = elfs[index].name;
                          bool isFav = favories.isElfFavorite(id);
                          return ElfCard(
                            id: id,
                            name: name,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ElfOverviewPage(
                                      overview: elfs[index].overview,
                                    );
                                  },
                                ),
                              );
                            },
                            isFav: isFav,
                            onSecondaryTap: () async {
                              ref.read(favoriteProvider).toggleElf(id);
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
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
