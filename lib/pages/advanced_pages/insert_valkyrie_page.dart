import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/pages/advanced_page.dart';
import 'package:flutter_honkai/pages/advanced_pages/preview_valk/valkyrie_preview_page.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class InsertValkyriePage extends ConsumerStatefulWidget {
  const InsertValkyriePage({super.key});

  @override
  ConsumerState<InsertValkyriePage> createState() => _InsertValkyriePageState();
}

class _InsertValkyriePageState extends ConsumerState<InsertValkyriePage> {
  final _formKey = GlobalKey<FormState>();

  final labelcontroller = TextEditingController();
  final idcontroller = TextEditingController();
  final imageNamecontroller = TextEditingController();

  String? id;
  String? name;
  int? astralop;
  int? dame0;
  int? dame1;
  List<int> damage = [];
  int? type;
  String? equipment;
  List note = [];
  List leader = [];
  List firstValkList = [];
  List secondValkList = [];
  List elfList = [];

  List curleader = [];
  List curfirstValkList = [];
  List cursecondValkList = [];
  List curelfList = [];
  String? curnote;

  FilePickerResult? resultvalk;
  FilePickerResult? resultweap;
  FilePickerResult? resulttop;
  FilePickerResult? resultmid;
  FilePickerResult? resultbot;
  String? role;
  String? pulllrec;
  String? rankup;

  void _submitPreview() {
    if (_formKey.currentState!.validate()) {
      if (resultvalk == null ||
          resultweap == null ||
          resulttop == null ||
          resultmid == null ||
          resultbot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please choose all required images")),
        );
        return;
      }
      if (note.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter at least 1 lineup")),
        );
        return;
      }
      _formKey.currentState!.save();

      List<int> previewdame = [];
      previewdame.add(dame0!);
      if (dame1 != null) {
        previewdame.add(dame1!);
      }
      final ValkyrieModel previewValkyrie = ValkyrieModel(
        id: id!,
        name: name!,
        astralop: astralop!,
        damage: previewdame,
        type: type!,
        //not need for preview
        equipment: List.empty(),
        note: note,
        leader: leader,
        firstvalkList: firstValkList,
        secondvalkList: secondValkList,
        elfList: elfList,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => ValkyriePreviewPage(
                previewValkyrie: previewValkyrie,
                valkImagePath: resultvalk!.files.single.path!,
                weapImagePath: resultweap!.files.single.path!,
                topImagePath: resulttop!.files.single.path!,
                midImagePath: resultmid!.files.single.path!,
                botImagePath: resultbot!.files.single.path!,
                role: role!,
                pullrec: pulllrec!,
                rankup: rankup!,
              ),
        ),
      );
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (resultvalk == null ||
          resultweap == null ||
          resulttop == null ||
          resultmid == null ||
          resultbot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please choose all required images")),
        );
        return;
      }
      if (note.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter at least 1 lineup")),
        );
        return;
      }
      _formKey.currentState!.save();

      damage.add(dame0!);
      if (dame1 != null) {
        damage.add(dame1!);
      }
      final ValkyrieModel newValkyrie = ValkyrieModel(
        id: id!,
        name: name!,
        astralop: astralop!,
        damage: damage,
        type: type!,
        equipment: ['${id}weap', '${id}top', '${id}mid', '${id}bot'],
        note: note,
        leader: leader,
        firstvalkList: firstValkList,
        secondvalkList: secondValkList,
        elfList: elfList,
      );
      //create txtfile
      final documentdir = await getApplicationDocumentsDirectory();
      final dir = Directory(
        '${documentdir.path}/Honkai Station/text/${newValkyrie.id}',
      );
      await dir.create(recursive: true);
      final roleFile = File('${dir.path}/role.txt');
      final pullrecFile = File('${dir.path}/pullrec.txt');
      final rankupFile = File('${dir.path}/rankup.txt');
      roleFile.writeAsString(role!);
      pullrecFile.writeAsString(pulllrec!);
      rankupFile.writeAsString(rankup!);
      //copy image to right path
      final valkImagePath = ref.read(valkImagesPathPathProvider);
      final equipImagePath = ref.read(equipmentImagesPathProvider);
      await File(
        resultvalk!.files.single.path!,
      ).copy('$valkImagePath/${newValkyrie.id}.png');
      await File(
        resultweap!.files.single.path!,
      ).copy('$equipImagePath/${newValkyrie.id}weap.png');
      await File(
        resulttop!.files.single.path!,
      ).copy('$equipImagePath/${newValkyrie.id}top.png');
      await File(
        resultmid!.files.single.path!,
      ).copy('$equipImagePath/${newValkyrie.id}mid.png');
      await File(
        resultbot!.files.single.path!,
      ).copy('$equipImagePath/${newValkyrie.id}bot.png');
      //add to database
      final db = await DatabaseHelper.getDatabase();
      try {
        await db.insert('valkyries', newValkyrie.toMainMap());
      } catch (e) {
        if (mounted &&
            e is DatabaseException &&
            e.toString().contains('UNIQUE')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text("This valk id is existed"),
            ),
          );
        }
      }
      final lineup = newValkyrie.toLineUpListMap();
      for (var line in lineup) {
        await db.insert('valk_lineup', line);
      }
      ref.read(valkyrieProvider).addValkyrie(newValkyrie);
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
    String imagepath = ref.read(valkImagesPathPathProvider);
    final valkyries = ref.watch(valkyrieProvider).valkyries;
    final elfs = ref.watch(elfProvider).elfs;
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
                                'Name of valk is the name that show on screen',
                              ),
                              Text('String id of each valk must be unique'),
                              Text(
                                'File image of valk is the file that use to show valk\'s avatar',
                              ),
                              Text(
                                'All valkyries images are stored in $imagepath',
                              ),
                              Text(
                                'You can refer the existed valkyries to know the template',
                              ),
                              Text(
                                'You can use preview button to preview all information of valkyrie that you are adding',
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
        title: Text('Insert Valkyrie Page'),
      ),
      body: SingleChildScrollView(
        child: Form(
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
                                resultvalk = await FilePicker.platform
                                    .pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['png'],
                                    );
                                setState(() {});
                              },
                              icon:
                                  resultvalk != null
                                      ? Image.file(
                                        width: 70,
                                        height: 70,
                                        File(resultvalk!.files.single.path!),
                                      )
                                      : Icon(
                                        color: Colors.white,
                                        size: 70,
                                        Icons.image,
                                      ),
                            ),
                            Text('Select an image of valk'),
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
                          decoration: InputDecoration(
                            labelText: 'Name of valk',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == '') {
                              return 'Please enter name of valk';
                            }
                            return null;
                          },
                          onChanged: (value) {
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
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          readOnly: false,
                          enabled: true,
                          decoration: InputDecoration(
                            labelText: 'String id of valk',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (valkyries.any((valk) => valk.id == value)) {
                              return 'This id is existed';
                            }
                            if (value == '') {
                              return 'Please enter id of valk';
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
                SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: DropdownButtonFormField<int>(
                          value: astralop,
                          decoration: InputDecoration(
                            labelText: 'AstralOP of valk',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              [
                                {'value': 1, 'name': 'Law of Ascension'},
                                {'value': 2, 'name': 'Wheel of Destiny'},
                                {'value': 3, 'name': 'Rite of Oblivion'},
                                {'value': 4, 'name': 'World Star'},
                                {'value': 5, 'name': 'Part 1'},
                              ].map((item) {
                                return DropdownMenuItem<int>(
                                  value: item['value'] as int,
                                  child: Text(item['name'] as String),
                                );
                              }).toList(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null) {
                              return 'Please choose astralop of valk';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              astralop = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: DropdownButtonFormField<int>(
                          value: dame0,
                          decoration: InputDecoration(
                            labelText: 'First damage of valk',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              [
                                {'value': 1, 'name': 'Fire'},
                                {'value': 2, 'name': 'Ice'},
                                {'value': 3, 'name': 'Lightning'},
                                {'value': 4, 'name': 'Physic'},
                                {'value': 5, 'name': 'Bleed'},
                              ].where((item) => item['value'] != dame1).map((
                                item,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: item['value'] as int,
                                  child: Text(item['name'] as String),
                                );
                              }).toList(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null) {
                              return 'Please choose first damage of valk';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              dame0 = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: DropdownButtonFormField<int?>(
                          value: dame1,
                          decoration: InputDecoration(
                            labelText: 'Second damage of valk',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              [
                                    {'value': null, 'name': 'None'},
                                    {'value': 1, 'name': 'Fire'},
                                    {'value': 2, 'name': 'Ice'},
                                    {'value': 3, 'name': 'Lightning'},
                                    {'value': 4, 'name': 'Physic'},
                                    {'value': 5, 'name': 'Bleed'},
                                  ]
                                  .where(
                                    (item) =>
                                        item['value'] == null ||
                                        item['value'] != dame0,
                                  )
                                  .map((item) {
                                    return DropdownMenuItem<int?>(
                                      value: item['value'] as int?,
                                      child: Text(item['name'] as String),
                                    );
                                  })
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              dame1 = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: DropdownButtonFormField<int>(
                          value: type,
                          decoration: InputDecoration(
                            labelText: 'Type of valk',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              [
                                {'value': 1, 'name': 'Mech'},
                                {'value': 2, 'name': 'Bio'},
                                {'value': 3, 'name': 'Psy'},
                                {'value': 4, 'name': 'Quantum'},
                                {'value': 5, 'name': 'Img'},
                                {'value': 6, 'name': 'Stardust'},
                              ].map((item) {
                                return DropdownMenuItem<int>(
                                  value: item['value'] as int,
                                  child: Text(item['name'] as String),
                                );
                              }).toList(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null) {
                              return 'Please choose type of valk';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              type = value;
                            });
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
                        padding: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                resultweap = await FilePicker.platform
                                    .pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['png'],
                                    );
                                setState(() {});
                              },
                              icon:
                                  resultweap != null
                                      ? Image.file(
                                        width: 70,
                                        height: 70,
                                        File(resultweap!.files.single.path!),
                                      )
                                      : Icon(
                                        color: Colors.white,
                                        size: 70,
                                        Icons.image,
                                      ),
                            ),
                            Text('Select an image of weapon'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                resulttop = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['png'],
                                );
                                setState(() {});
                              },
                              icon:
                                  resulttop != null
                                      ? Image.file(
                                        width: 70,
                                        height: 70,
                                        File(resulttop!.files.single.path!),
                                      )
                                      : Icon(
                                        color: Colors.white,
                                        size: 70,
                                        Icons.image,
                                      ),
                            ),
                            Text('Select an image of top stigmata'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                resultmid = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['png'],
                                );
                                setState(() {});
                              },
                              icon:
                                  resultmid != null
                                      ? Image.file(
                                        width: 70,
                                        height: 70,
                                        File(resultmid!.files.single.path!),
                                      )
                                      : Icon(
                                        color: Colors.white,
                                        size: 70,
                                        Icons.image,
                                      ),
                            ),
                            Text('Select an image of mid stigmata'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                resultbot = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['png'],
                                );
                                setState(() {});
                              },
                              icon:
                                  resultbot != null
                                      ? Image.file(
                                        width: 70,
                                        height: 70,
                                        File(resultbot!.files.single.path!),
                                      )
                                      : Icon(
                                        color: Colors.white,
                                        size: 70,
                                        Icons.image,
                                      ),
                            ),
                            Text('Select an image of bot stigmata'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: Colors.white, thickness: 3),
                Text(style: TextStyle(fontSize: 20), 'Lineup of valk'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    readOnly: false,
                    enabled: true,
                    decoration: InputDecoration(labelText: 'Lineup name'),
                    onChanged: (value) {
                      curnote = value;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () async {
                                  if (name == null ||
                                      name == '' ||
                                      id == null ||
                                      id == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Enter name and id first",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return MultiSelectDialog(
                                        selectedColor: Colors.blue,
                                        itemsTextStyle: TextStyle(
                                          color: Colors.white54,
                                        ),
                                        selectedItemsTextStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        cancelText: Text(
                                          style: TextStyle(color: Colors.white),
                                          'Cancel',
                                        ),
                                        confirmText: Text(
                                          style: TextStyle(color: Colors.white),
                                          'Confirm',
                                        ),
                                        backgroundColor: Colors.black,
                                        separateSelectedItems: true,
                                        searchable: true,
                                        items: [
                                          ...[
                                                ValkyrieModel(
                                                  id: id!,
                                                  name: name!,
                                                  astralop: 0,
                                                  damage: damage,
                                                  type: 0,
                                                  equipment: [],
                                                  note: note,
                                                  leader: leader,
                                                  firstvalkList: [],
                                                  secondvalkList: [],
                                                  elfList: [],
                                                ),
                                                ...valkyries,
                                              ]
                                              .where(
                                                (valk) =>
                                                    !curfirstValkList.contains(
                                                      valk.id,
                                                    ) &&
                                                    !cursecondValkList.contains(
                                                      valk.id,
                                                    ),
                                              )
                                              .map(
                                                (valk) => MultiSelectItem(
                                                  valk.id,
                                                  valk.name,
                                                ),
                                              ),
                                        ],
                                        initialValue: curleader,
                                        onConfirm: (values) {
                                          if (values.length > 1) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Choose only 1 valkyrie!",
                                                ),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              curleader.clear();
                                              curleader.addAll(values);
                                            });
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  'Select leader',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MultiSelectChipDisplay(
                              textStyle: TextStyle(color: Colors.white),
                              items:
                                  curleader
                                      .map((e) => MultiSelectItem(e, e))
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () async {
                                  if (name == null ||
                                      name == '' ||
                                      id == null ||
                                      id == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Enter name and id first",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return MultiSelectDialog(
                                        selectedColor: Colors.blue,
                                        itemsTextStyle: TextStyle(
                                          color: Colors.white54,
                                        ),
                                        selectedItemsTextStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        cancelText: Text(
                                          style: TextStyle(color: Colors.white),
                                          'Cancel',
                                        ),
                                        confirmText: Text(
                                          style: TextStyle(color: Colors.white),
                                          'Confirm',
                                        ),
                                        backgroundColor: Colors.black,
                                        separateSelectedItems: true,
                                        searchable: true,
                                        items: [
                                          ...[
                                                ValkyrieModel(
                                                  id: id!,
                                                  name: name!,
                                                  astralop: 0,
                                                  damage: damage,
                                                  type: 0,
                                                  equipment: [],
                                                  note: note,
                                                  leader: leader,
                                                  firstvalkList: [],
                                                  secondvalkList: [],
                                                  elfList: [],
                                                ),
                                                ...valkyries,
                                              ]
                                              .where(
                                                (valk) =>
                                                    !curleader.contains(
                                                      valk.id,
                                                    ) &&
                                                    !cursecondValkList.contains(
                                                      valk.id,
                                                    ),
                                              )
                                              .map(
                                                (valk) => MultiSelectItem(
                                                  valk.id,
                                                  valk.name,
                                                ),
                                              ),
                                        ],
                                        initialValue: curfirstValkList,
                                        onConfirm: (values) {
                                          setState(() {
                                            curfirstValkList.clear();
                                            curfirstValkList.addAll(values);
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  'Select valkyries for first slot',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MultiSelectChipDisplay(
                              textStyle: TextStyle(color: Colors.white),
                              items:
                                  curfirstValkList
                                      .map((e) => MultiSelectItem(e, e))
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () async {
                                  if (name == null ||
                                      name == '' ||
                                      id == null ||
                                      id == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Enter name and id first",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return MultiSelectDialog(
                                        selectedColor: Colors.blue,
                                        itemsTextStyle: TextStyle(
                                          color: Colors.white54,
                                        ),
                                        selectedItemsTextStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        cancelText: Text(
                                          style: TextStyle(color: Colors.white),
                                          'Cancel',
                                        ),
                                        confirmText: Text(
                                          style: TextStyle(color: Colors.white),
                                          'Confirm',
                                        ),
                                        backgroundColor: Colors.black,
                                        separateSelectedItems: true,
                                        searchable: true,
                                        items: [
                                          ...[
                                                ValkyrieModel(
                                                  id: id!,
                                                  name: name!,
                                                  astralop: 0,
                                                  damage: damage,
                                                  type: 0,
                                                  equipment: [],
                                                  note: note,
                                                  leader: leader,
                                                  firstvalkList: [],
                                                  secondvalkList: [],
                                                  elfList: [],
                                                ),
                                                ...valkyries,
                                              ]
                                              .where(
                                                (valk) =>
                                                    !curfirstValkList.contains(
                                                      valk.id,
                                                    ) &&
                                                    !curleader.contains(
                                                      valk.id,
                                                    ),
                                              )
                                              .map(
                                                (valk) => MultiSelectItem(
                                                  valk.id,
                                                  valk.name,
                                                ),
                                              ),
                                        ],
                                        initialValue: cursecondValkList,
                                        onConfirm: (values) {
                                          setState(() {
                                            cursecondValkList.clear();
                                            cursecondValkList.addAll(values);
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  'Select valkyries for second slot',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MultiSelectChipDisplay(
                              textStyle: TextStyle(color: Colors.white),
                              items:
                                  cursecondValkList
                                      .map((e) => MultiSelectItem(e, e))
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return MultiSelectDialog(
                                        selectedColor: Colors.blue,
                                        itemsTextStyle: TextStyle(
                                          color: Colors.white54,
                                        ),
                                        selectedItemsTextStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        cancelText: Text(
                                          style: TextStyle(color: Colors.white),
                                          'Cancel',
                                        ),
                                        confirmText: Text(
                                          style: TextStyle(color: Colors.white),
                                          'Confirm',
                                        ),
                                        backgroundColor: Colors.black,
                                        separateSelectedItems: true,
                                        searchable: true,
                                        items:
                                            elfs
                                                .map(
                                                  (elf) => MultiSelectItem(
                                                    elf.id,
                                                    elf.name,
                                                  ),
                                                )
                                                .toList(),

                                        initialValue: curelfList,
                                        onConfirm: (values) {
                                          setState(() {
                                            curelfList.clear();
                                            curelfList.addAll(values);
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  'Select elfs',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MultiSelectChipDisplay(
                              textStyle: TextStyle(color: Colors.white),
                              items:
                                  curelfList
                                      .map((e) => MultiSelectItem(e, e))
                                      .toList(),
                            ),
                          ),
                        ],
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
                        if (curnote == '' ||
                            curnote == null ||
                            curleader.isEmpty ||
                            curfirstValkList.isEmpty ||
                            curelfList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Only valkyries for second slot' option can be blank",
                              ),
                            ),
                          );
                        } else {
                          note.add(curnote);
                          leader.add(curleader[0]);
                          firstValkList.add(List.from(curfirstValkList));
                          secondValkList.add(List.from(cursecondValkList));
                          elfList.add(List.from(curelfList));
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
                          leader.removeLast();
                          firstValkList.removeLast();
                          secondValkList.removeLast();
                          elfList.removeLast();
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
                        'Delete most recent lineup',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: Colors.white, thickness: 3),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    readOnly: false,
                    enabled: true,
                    decoration: InputDecoration(labelText: 'Role infomation'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter this field';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      role = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    readOnly: false,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: 'Recommended pull information',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter this field';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      pulllrec = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    readOnly: false,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: 'Rankup information',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter this field';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      rankup = value;
                    },
                  ),
                ),
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
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
