import 'package:flutter/material.dart';

class ValkyrieOverviewPage extends StatefulWidget {
  const ValkyrieOverviewPage({super.key});

  @override
  State<ValkyrieOverviewPage> createState() => _ValkyrieOverviewPageState();
}

class _ValkyrieOverviewPageState extends State<ValkyrieOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Valkyrie Overview')),
      body: Center(child: Text('Valkyrie Overview Page')),
    );
  }
}
