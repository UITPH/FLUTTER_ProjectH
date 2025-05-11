import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/pages/preview_elf/elf_overview_page.dart';
import 'package:flutter_honkai/pages/preview_elf/preview_elf_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElfPreviewPage extends ConsumerWidget {
  final ElfModel previewElf;
  final Widget image;
  const ElfPreviewPage({
    required this.previewElf,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elfs = [previewElf];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(style: TextStyle(fontWeight: FontWeight.bold), 'PREVIEW'),
      ),
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
                          return PreviewElfCard(
                            id: id,
                            name: name,
                            image: image,
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
