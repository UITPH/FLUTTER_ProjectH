import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/parameter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaintainancePage extends ConsumerStatefulWidget {
  final int? counter;
  const MaintainancePage({super.key, this.counter});

  @override
  ConsumerState<MaintainancePage> createState() => _MaintainancePageState();
}

class _MaintainancePageState extends ConsumerState<MaintainancePage> {
  late Timer _timer;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.counter != null) {
      counter = widget.counter!;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          counter--;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parameters = ref.read(parameterProvider).parameters;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Icon(
              size: 600,
              color: Colors.white24,
              Icons.construction_rounded,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  'The app is under maintainance',
                ),
                SizedBox(height: 20),
                Text(
                  style: TextStyle(fontSize: 20),
                  widget.counter == null
                      ? parameters.maintainanceInfo
                      : 'The app will be closed after $counter seconds',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
