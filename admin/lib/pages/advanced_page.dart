import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
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
import 'package:flutter_honkai/pages/modify_valkyrie_page.dart';
import 'package:flutter_honkai/providers/parameter_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
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
          case '/valkmod':
            builder = (context) => ModifyValkyriePage();
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

class AdvancedPageHome extends ConsumerStatefulWidget {
  const AdvancedPageHome({super.key});

  @override
  ConsumerState<AdvancedPageHome> createState() => _AdvancedPageHomeState();
}

class _AdvancedPageHomeState extends ConsumerState<AdvancedPageHome> {
  bool isSwitch = false;
  bool isSwitchEnable = true;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    final parameters = ref.read(parameterProvider).parameters;
    isSwitch = parameters.isMaintainance == 1;
    controller.text = parameters.maintainanceInfo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.read(parameterProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: SwitchListTile(
                title: Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSwitch ? Colors.blueAccent : Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  'Maintainance mode',
                ),
                activeTrackColor: Colors.white,
                activeColor: Colors.blueAccent,
                value: isSwitch,
                onChanged:
                    isSwitchEnable
                        ? (value) async {
                          final connectionStatus =
                              await Connectivity().checkConnectivity();
                          if (connectionStatus.contains(
                                ConnectivityResult.none,
                              ) &&
                              context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text(
                                  "The internet connection is lost",
                                ),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            isSwitchEnable = false;
                          });
                          setState(() {
                            isSwitch = value;
                            provider.changeParameters(
                              isMaintainance: value ? 1 : 0,
                              maintainanceInfo: controller.text,
                            );
                          });
                          final db = DatabaseHelper.supabase;
                          await db
                              .from('parameters')
                              .upsert(provider.parameters.toListMap());
                          setState(() {
                            isSwitchEnable = true;
                          });
                        }
                        : null,
              ),
            ),
            SizedBox(
              width: 500,
              child: TextField(
                enabled: !isSwitch,
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Maintainance information',
                ),
              ),
            ),
            SizedBox(height: 50),
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
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 20,
                      ),
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
            SizedBox(height: 50),
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
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 20,
                      ),
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
            SizedBox(height: 50),
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
                  onPressed:
                      () => Navigator.pushNamed(context, '/abyssbossins'),
                ),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 20,
                      ),
                      'Modify Abyss Boss',
                    ),
                  ),
                  onPressed:
                      () => Navigator.pushNamed(context, '/abyssbossmod'),
                ),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      style: TextStyle(color: Colors.redAccent, fontSize: 20),
                      'Delete Abyss Boss',
                    ),
                  ),
                  onPressed:
                      () => Navigator.pushNamed(context, '/abyssbossdel'),
                ),
              ],
            ),
            SizedBox(height: 50),
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
                  onPressed:
                      () => Navigator.pushNamed(context, '/arenabossins'),
                ),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 20,
                      ),
                      'Modify Arena Boss',
                    ),
                  ),
                  onPressed:
                      () => Navigator.pushNamed(context, '/arenabossmod'),
                ),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      style: TextStyle(color: Colors.redAccent, fontSize: 20),
                      'Delete Arena Boss',
                    ),
                  ),
                  onPressed:
                      () => Navigator.pushNamed(context, '/arenabossdel'),
                ),
              ],
            ),
            SizedBox(height: 50),
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
                  'Recently deleted',
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/restore'),
            ),
          ],
        ),
      ),
    );
  }
}
