import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/advanced_page.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  bool isConnected = true;

  Future<void> _loadData() async {
    ref.read(deleteProvider).init();
    await ref.read(valkyrieProvider).loadValkyries();
    await ref.read(abyssBossProvider).loadBosses();
    await ref.read(arenabossProvider).loadBosses();
    await ref.read(elfProvider).loadElfs();
    await ref.read(weatherProvider).loadWeathers();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder:
              (context, animation, secondaryAnimation) => AdvancedPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  Future<void> _checkAndload() async {
    final connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus.contains(ConnectivityResult.wifi) ||
        connectionStatus.contains(ConnectivityResult.ethernet)) {
      setState(() {
        isConnected = true;
      });
      _loadData();
    } else if (connectionStatus.contains(ConnectivityResult.none)) {
      Connectivity().onConnectivityChanged.listen((result) {
        if (result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.ethernet)) {
          setState(() {
            DatabaseHelper.supabase = SupabaseClient(
              'https://cnxrzuiulajmjxdjyyvs.supabase.co',
              serviceKey,
            );
            isConnected = true;
          });
          _loadData();
        } else if (result.contains(ConnectivityResult.none)) {
          setState(() {
            isConnected = false;
          });
          _loadData();
        }
      });
    }
  }

  @override
  void initState() {
    _checkAndload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/taixuanbridge.jpg'),
              opacity: AlwaysStoppedAnimation(0.2),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isConnected
                    ? LoadingAnimationWidget.halfTriangleDot(
                      color: Colors.white,
                      size: 70,
                    )
                    : Icon(size: 70, Icons.wifi_off),
                isConnected
                    ? Text(style: TextStyle(fontSize: 50), 'Initializing')
                    : Text(
                      style: TextStyle(fontSize: 50),
                      'No internet connection',
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
