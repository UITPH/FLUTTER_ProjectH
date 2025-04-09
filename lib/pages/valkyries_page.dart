import 'package:flutter/material.dart';

class ValkyriesPage extends StatefulWidget {
  const ValkyriesPage({super.key});

  @override
  State<ValkyriesPage> createState() => _ValkyriesPageState();
}

class _ValkyriesPageState extends State<ValkyriesPage> {
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Select a Valkyrie',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Placeholder(
                          fallbackHeight: 70,
                          fallbackWidth: 500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Placeholder(
                          fallbackHeight: 70,
                          fallbackWidth: 500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    width: 1032,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Placeholder(fallbackHeight: 70, fallbackWidth: 150),
                        Placeholder(fallbackHeight: 70, fallbackWidth: 150),
                        Placeholder(fallbackHeight: 70, fallbackWidth: 150),
                        Placeholder(fallbackHeight: 70, fallbackWidth: 150),
                        Placeholder(fallbackHeight: 70, fallbackWidth: 150),
                        Placeholder(fallbackHeight: 70, fallbackWidth: 150),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
