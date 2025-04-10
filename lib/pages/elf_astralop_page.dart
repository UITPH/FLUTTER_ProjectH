import 'package:flutter/material.dart';
import 'package:flutter_honkai/widgets/astralop_card.dart';

class ElfAstralopPage extends StatefulWidget {
  const ElfAstralopPage({super.key});

  @override
  State<ElfAstralopPage> createState() => _ElfAstralopPageState();
}

class _ElfAstralopPageState extends State<ElfAstralopPage> {
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
                        itemCount: 7,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 40,
                        ),
                        itemBuilder: (context, index) {
                          return AstralopCard(
                            name: 'Elf/AstralOP $index',
                            imageName: 'teri.png',
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
