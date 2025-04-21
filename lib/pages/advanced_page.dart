import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/add_valkyrie_page.dart';
import 'package:flutter_honkai/pages/bosses_database_page.dart';
import 'package:flutter_honkai/pages/elfs_database_page.dart';
import 'package:flutter_honkai/pages/remove_valkyrie_page.dart';

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
          case '/valkadd':
            builder = (context) => AddValkyriePage();
            break;
          case '/valkrm':
            builder = (context) => RemoveValkyriePage();
            break;
          case '/bossdb':
            builder = (context) => BossesDatabasePage();
            break;
          case '/elfdb':
            builder = (context) => ElfsDatabasePage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class AdvancedPageHome extends StatelessWidget {
  const AdvancedPageHome({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Add Valkyrie',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/valkadd'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    'Delete Valkyrie',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/valkrm'),
              ),
            ],
          ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                style: TextStyle(color: Colors.white, fontSize: 20),
                'Bosses Database',
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, '/bossdb'),
          ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                style: TextStyle(color: Colors.white, fontSize: 20),
                'Elfs Database',
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, '/elfdb'),
          ),
        ],
      ),
    );
  }
}
