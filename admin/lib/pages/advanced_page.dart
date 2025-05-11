import 'package:flutter/material.dart';
import 'package:flutter_honkai/pages/delete_arena_boss_page.dart';
import 'package:flutter_honkai/pages/delete_elf_page.dart';
import 'package:flutter_honkai/pages/insert_abyss_boss_page.dart';
import 'package:flutter_honkai/pages/insert_arena_boss_page.dart';
import 'package:flutter_honkai/pages/insert_elf_page.dart';
import 'package:flutter_honkai/pages/insert_valkyrie_page.dart';
import 'package:flutter_honkai/pages/delete_abyss_boss_page.dart';
import 'package:flutter_honkai/pages/delete_valkyrie_page.dart';
import 'package:flutter_honkai/pages/delete_page.dart';
import 'package:flutter_honkai/pages/modify_abyssboss_page.dart';
import 'package:flutter_honkai/pages/modify_arenaboss_page.dart';
import 'package:flutter_honkai/pages/modify_elf_page.dart';
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
          case '/elfins':
            builder = (context) => InsertElfPage();
            break;
          case '/elfmod':
            builder = (context) => ModifyElfPage();
            break;
          case '/elfdel':
            builder = (context) => DeleteElfPage();
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
          case '/abyssbossmod':
            builder = (context) => ModifyAbyssbossPage();
            break;
          case '/abyssbossdel':
            builder = (context) => DeleteAbyssBossPage();
            break;
          case '/arenabossins':
            builder = (context) => InsertArenaBossPage();
            break;
          case '/arenabossmod':
            builder = (context) => ModifyArenabossPage();
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
                    style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                    'Insert Elf',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/elfins'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 20),
                    'Modify Elf',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/elfmod'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.redAccent, fontSize: 20),
                    'Delete Elf',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/elfdel'),
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
                    style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                    'Insert Valkyrie',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/valkins'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 20),
                    'Modify Valkyrie',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/valkmod'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.redAccent, fontSize: 20),
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
                    style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                    'Insert Abyss Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/abyssbossins'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 20),
                    'Modify Abyss Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/abyssbossmod'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.redAccent, fontSize: 20),
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
                    style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                    'Insert Arena Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/arenabossins'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 20),
                    'Modify Arena Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/arenabossmod'),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    style: TextStyle(color: Colors.redAccent, fontSize: 20),
                    'Delete Arena Boss',
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/arenabossdel'),
              ),
            ],
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              fixedSize: Size.fromWidth(500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(width: 1, color: Colors.white),
              ),
            ),
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
