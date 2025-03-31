import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<MessageProvider>(
          builder: (context, provider, child) {
            return Text(provider.message.text, style: TextStyle(fontSize: 24));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<MessageProvider>().updateMessage("Hello Flutter!"),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
