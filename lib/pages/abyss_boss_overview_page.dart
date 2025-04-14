import 'package:flutter/material.dart';

class AbyssBossOverviewPage extends StatefulWidget {
  const AbyssBossOverviewPage({super.key});

  @override
  State<AbyssBossOverviewPage> createState() => _AbyssBossOverviewPageState();
}

class _AbyssBossOverviewPageState extends State<AbyssBossOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abyss boss Overview')),
      body: Center(child: Text('Abyss boss Overview Page')),
    );
  }
}
