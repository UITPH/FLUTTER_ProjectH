import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/boss_model.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/providers/boss_provider.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsertAbyssBossPage extends ConsumerStatefulWidget {
  const InsertAbyssBossPage({super.key});

  @override
  ConsumerState<InsertAbyssBossPage> createState() =>
      _InsertAbyssBossPageState();
}

class _InsertAbyssBossPageState extends ConsumerState<InsertAbyssBossPage> {
  final _formKey = GlobalKey<FormState>();
  final labelcontroller = TextEditingController();
  final idcontroller = TextEditingController();
  final imageNamecontroller = TextEditingController();

  String? label;
  String? id;
  String? imageName;
  String? weather;
  String? mechanics;
  String? resistance;
  String? teamrec;
  int? type;

  void _submit() {
    if (label != '' &&
        id != '' &&
        imageName != '' &&
        weather != null &&
        mechanics != '' &&
        teamrec != '') {
      List<BossModel> bosses = ref.read(bossProvider);
      List<dynamic> listteamrec = [];
      try {
        listteamrec = jsonDecode(teamrec!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text('Wrong format for "List of recommended team" field'),
          ),
        );
        return;
      }
      try {
        if (listteamrec.any((e) => e is! List || e.length != 5) ||
            listteamrec.isEmpty) {
          throw FormatException(
            "Each team must be a list of exactly 5 items (valk1, valk2, valk3, elf, note).",
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'Each team must be a list of exactly 5 items (valk1, valk2, valk3, elf, note).',
            ),
          ),
        );
        return;
      }
      BossModel newboss = BossModel(
        label: label!,
        id: id!,
        imageName: imageName!,
        weather: weather!,
        mechanics: mechanics!,
        resistance: resistance!,
        teamrec: listteamrec,
      );
      bosses.add(newboss);
      saveBossesListToJson(bosses);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 1), content: Text('Saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('One or some fields is not type!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagepath = ref.read(bossImagesPathProvider);
    List<WeatherModel> weathers = ref.read(weatherProvider);
    List<DropdownMenuItem<String>> dropdownMenuItem =
        weathers
            .skip(1)
            .map(
              (item) => DropdownMenuItem<String>(
                value: item.value,
                child: Text(item.label),
              ),
            )
            .toList();
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        'Information',
                      ),
                      content: SizedBox(
                        width: double.infinity,
                        child: IntrinsicHeight(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name of boss is the name that show on screen',
                              ),
                              Text('String id of each boss must be unique'),
                              Text(
                                'Name of image file is the name of file that use to show boss\'s avatar',
                              ),
                              Text(
                                'You must add image to the this path: $imagepath',
                              ),
                              Text(
                                'The information you put it Weather, Mechanics and Resistance field are used in corresponding boss specific page',
                              ),
                              Text(
                                '''List of recommended team:
- Template: [["valk1.png","valk2.png","valk3.png","elf.png","note about this team"],....other teams]
- Example:
  For one team:
  Herrscher of Corruption - bleed: [["PS.png","LP.png","FWS.png","teri.png",""]]

  For many teams:
  Husk Nihilus - bleed: [[["PS.png","LP.png","TFM.png","teri.png"],"Vita uses Top Susannah, MB Aladin"],[["PS.png","LP.png","TFM.png","teri.png"],"Vita uses signature gears"],[["PS.png","LP.png","FWS.png","teri.png"],"Vita uses Top Susannah, MB Aladin"],[["PS.png","LP.png","FWS.png","teri.png"],"Vita uses signature gears"]]''',
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
              );
            },
            icon: Icon(Icons.info_outline_rounded),
          ),
        ],
        title: Text('Insert Abyss Boss Page'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(labelText: 'Name of boss'),
                        onSaved: (value) {
                          label = value;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'String id of boss',
                        ),
                        onSaved: (value) {
                          id = value;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Name of image file',
                        ),
                        onSaved: (value) {
                          imageName = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButtonFormField<String>(
                        menuMaxHeight: 400,
                        value: weather,
                        decoration: InputDecoration(
                          labelText: 'Weather of boss',
                          border: OutlineInputBorder(),
                        ),
                        items: dropdownMenuItem,
                        onChanged: (value) {
                          setState(() {
                            weather = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Mechanics information',
                        ),
                        onSaved: (value) {
                          mechanics = value;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Resistance information',
                        ),
                        onSaved: (value) {
                          resistance = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  readOnly: false,
                  enabled: true,
                  decoration: InputDecoration(
                    labelText: 'List of recommend teams',
                  ),
                  onSaved: (value) {
                    teamrec = value;
                  },
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _formKey.currentState!.save();
                    _submit();
                  });
                },
                child: Text(
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
