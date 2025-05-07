import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/pages/advanced_page.dart';
import 'package:flutter_honkai/pages/advanced_pages/preview_boss/abyss_preview_page.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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

  FilePickerResult? result;

  String curnote = '';
  String curfirstValk = '';
  String cursecondValk = '';
  String curthirdValk = '';
  String curElf = '';

  String? id;
  String? name;
  String? idWeather;
  String? mechanic;
  String? resistance;
  List note = [];
  List firstValk = [];
  List secondValk = [];
  List thirdValk = [];
  List elf = [];

  Future<void> _submitPreview() async {
    if (_formKey.currentState!.validate()) {
      if (result == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please choose boss image")));
        return;
      }
      if (note.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter at least 1 recommended team")),
        );
        return;
      }
      _formKey.currentState!.save();

      final AbyssBossModel previewBoss = AbyssBossModel(
        id: id!,
        name: name!,
        idWeather: idWeather!,
        mechanic: mechanic!,
        resistance: resistance!,
        firstValk: firstValk,
        secondValk: secondValk,
        thirdValk: thirdValk,
        elf: elf,
        note: note,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => AbyssPreviewPage(
                previewBoss: previewBoss,
                imagePath: result!.files.single.path!,
              ),
        ),
      );
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (result == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please choose boss image")));
        return;
      }
      if (note.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter at least 1 recommended team")),
        );
        return;
      }
      _formKey.currentState!.save();

      final AbyssBossModel newBoss = AbyssBossModel(
        id: id!,
        name: name!,
        idWeather: idWeather!,
        mechanic: mechanic!,
        resistance: resistance!,
        firstValk: firstValk,
        secondValk: secondValk,
        thirdValk: thirdValk,
        elf: elf,
        note: note,
      );
      //copy image to right path
      final bossImagePath = ref.read(abyssbossImagesPathProvider);
      await File(
        result!.files.single.path!,
      ).copy('$bossImagePath/${newBoss.id}.png');
      //add to database
      final db = await DatabaseHelper.getDatabase();
      try {
        await db.insert('abyssbosses', newBoss.toMainMap());
      } catch (e) {
        if (mounted &&
            e is DatabaseException &&
            e.toString().contains('UNIQUE')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text("This boss id is existed"),
            ),
          );
        }
        return;
      }
      final teamrec = newBoss.toTeamrecListMap();
      for (var team in teamrec) {
        await db.insert('abyssboss_teamrec', team);
      }
      ref.read(abyssBossProvider).addBoss(newBoss);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(duration: Duration(seconds: 1), content: Text("Saved")),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AdvancedPage();
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagepath = ref.read(abyssbossImagesPathProvider);
    List<WeatherModel> weathers = ref.read(weatherProvider).weathers;
    List<AbyssBossModel> bosses = ref.read(abyssBossProvider).bosses;
    List<ValkyrieModel> valkyries = ref.read(valkyrieProvider).valkyries;
    List<ElfModel> elfs = ref.read(elfProvider).elfs;
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
                        width: 300,
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
                                'File image of boss is the file that use to show boss\'s avatar',
                              ),
                              Text(
                                'All bosses images are stored in $imagepath',
                              ),
                              Text(
                                'You can refer the existed bosses to know the template',
                              ),
                              Text(
                                'You can use preview button to preview all information of boss that you are adding',
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
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['png'],
                              );
                              setState(() {});
                            },
                            icon:
                                result != null
                                    ? Image.file(
                                      width: 70,
                                      height: 70,
                                      File(result!.files.single.path!),
                                    )
                                    : Icon(
                                      color: Colors.white,
                                      size: 70,
                                      Icons.image,
                                    ),
                          ),
                          Text('Select an image of boss'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(labelText: 'Name of boss'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter name of boss';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'String id of boss',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (bosses.any((boss) => boss.id == value)) {
                            return 'This id is existed';
                          }
                          if (value == '') {
                            return 'Please enter id of boss';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          id = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButtonFormField<String>(
                        menuMaxHeight: 400,
                        value: idWeather,
                        decoration: InputDecoration(
                          labelText: 'Weather of boss',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            weathers
                                .skip(1)
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item.id,
                                    child: Text(item.name),
                                  ),
                                )
                                .toList(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select weather of boss';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            idWeather = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Mechanics information',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter mechanics of boss';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          mechanic = value;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Resistance information',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter resistance of boss';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          resistance = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white, thickness: 3),
              Text(style: TextStyle(fontSize: 20), 'Recommended team of boss'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  readOnly: false,
                  enabled: true,
                  decoration: InputDecoration(labelText: 'Team note'),
                  onChanged: (value) {
                    curnote = value;
                  },
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownMenu<String>(
                        enableFilter: true,
                        menuHeight: 300,
                        label: Text('First valkyrie'),
                        dropdownMenuEntries:
                            valkyries
                                .where(
                                  (valk) =>
                                      valk.id != cursecondValk &&
                                      valk.id != curthirdValk,
                                )
                                .map(
                                  (item) => DropdownMenuEntry<String>(
                                    value: item.id,
                                    label: item.name,
                                  ),
                                )
                                .toList(),
                        onSelected: (value) {
                          setState(() {
                            curfirstValk = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownMenu<String>(
                        enableFilter: true,
                        menuHeight: 300,
                        label: Text('Second valkyrie'),
                        dropdownMenuEntries:
                            valkyries
                                .where(
                                  (valk) =>
                                      valk.id != curfirstValk &&
                                      valk.id != curthirdValk,
                                )
                                .map(
                                  (item) => DropdownMenuEntry<String>(
                                    value: item.id,
                                    label: item.name,
                                  ),
                                )
                                .toList(),
                        onSelected: (value) {
                          setState(() {
                            cursecondValk = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownMenu<String>(
                        enableFilter: true,
                        menuHeight: 300,
                        label: Text('Third valkyrie'),
                        dropdownMenuEntries:
                            valkyries
                                .where(
                                  (valk) =>
                                      valk.id != cursecondValk &&
                                      valk.id != curfirstValk,
                                )
                                .map(
                                  (item) => DropdownMenuEntry<String>(
                                    value: item.id,
                                    label: item.name,
                                  ),
                                )
                                .toList(),
                        onSelected: (value) {
                          setState(() {
                            curthirdValk = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DropdownMenu<String>(
                      enableFilter: true,
                      menuHeight: 300,
                      label: Text('Elf'),
                      dropdownMenuEntries:
                          elfs
                              .map(
                                (item) => DropdownMenuEntry<String>(
                                  value: item.id,
                                  label: item.name,
                                ),
                              )
                              .toList(),
                      onSelected: (value) {
                        setState(() {
                          curElf = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      if (curfirstValk == '' ||
                          cursecondValk == '' ||
                          curthirdValk == '' ||
                          curElf == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Only note can be blank")),
                        );
                      } else {
                        note.add(curnote);
                        firstValk.add(curfirstValk);
                        secondValk.add(cursecondValk);
                        thirdValk.add(curthirdValk);
                        elf.add(curElf);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text("Added"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      'Add',
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      if (note.isNotEmpty) {
                        note.removeLast();
                        firstValk.removeLast();
                        secondValk.removeLast();
                        thirdValk.removeLast();
                        elf.removeLast();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text("Deleted"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      'Delete most recent team',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white, thickness: 3),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 500,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        _submit();
                      },
                      child: Text(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        'SAVE',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _submitPreview();
                    },
                    child: Text(
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      'Preview',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
