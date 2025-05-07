import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/advanced_pages/delete_arena_boss_page.dart';
import 'package:flutter_honkai/pages/advanced_pages/insert_abyss_boss_page.dart';
import 'package:flutter_honkai/pages/advanced_pages/insert_arena_boss_page.dart';
import 'package:flutter_honkai/pages/advanced_pages/insert_valkyrie_page.dart';
import 'package:flutter_honkai/pages/advanced_pages/delete_abyss_boss_page.dart';
import 'package:flutter_honkai/pages/advanced_pages/delete_valkyrie_page.dart';
import 'package:flutter_honkai/pages/delete_page.dart';
import 'package:flutter_honkai/providers/delete_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdvancedPage extends StatefulWidget {
  const AdvancedPage({super.key});

  @override
  State<AdvancedPage> createState() => _AdvancedPageState();
}

class _AdvancedPageState extends State<AdvancedPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (context) => AdvancedPageHome();
            break;
          case '/valkins':
            builder = (context) => InsertValkyriePage();
            break;
          case '/valkdel':
            builder = (context) => DeleteValkyriePage();
            break;
          case '/abyssbossins':
            builder = (context) => InsertAbyssBossPage();
            break;
          case '/abyssbossdel':
            builder = (context) => DeleteAbyssBossPage();
            break;
          case '/arenabossins':
            builder = (context) => InsertArenaBossPage();
            break;
          case '/arenabossdel':
            builder = (context) => DeleteArenaBossPage();
            break;
          case '/restore':
            builder = (context) => DeletePage();
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class AdvancedPageHome extends ConsumerWidget {
  const AdvancedPageHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(deleteProvider).init();
    return Center(
      child: Column(
        spacing: 50,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    'Insert Valkyrie',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/valkins'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    'Delete Valkyrie',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/valkdel'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    'Insert Abyss Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/abyssbossins'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    'Delete Abyss Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/abyssbossdel'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    'Insert Arena Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/arenabossins'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    'Delete Arena Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/arenabossdel'),
              ),
            ],
          ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                style: TextStyle(color: Colors.white, fontSize: 20),
                'Restore',
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, '/restore'),
          ),
        ],
      ),
    );
  }
}
