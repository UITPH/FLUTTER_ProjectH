import 'package:flutter/material.dart';

class ElfOverviewPage extends StatefulWidget {
  final String overview;
  const ElfOverviewPage({super.key, required this.overview});

  @override
  State<ElfOverviewPage> createState() => _ElfOverviewPageState();
}

class _ElfOverviewPageState extends State<ElfOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Elf Overview')),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 50,
                ),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                        'OVERVIEW',
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        style: TextStyle(fontSize: 40),
                        widget.overview,
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
