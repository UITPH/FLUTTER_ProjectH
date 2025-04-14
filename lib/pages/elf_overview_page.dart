import 'package:flutter/material.dart';

class ElfOverviewPage extends StatefulWidget {
  const ElfOverviewPage({super.key});

  @override
  State<ElfOverviewPage> createState() => _ElfOverviewPageState();
}

class _ElfOverviewPageState extends State<ElfOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elf Overview')),
      body: Center(child: Text('Elf Overview Page')),
    );
  }
}
