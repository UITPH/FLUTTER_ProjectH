import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/pages/advanced_page.dart';
import 'package:flutter_honkai/pages/preview_boss/arena_preview_page.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InsertArenaBossPage extends ConsumerStatefulWidget {
  const InsertArenaBossPage({super.key});

  @override
  ConsumerState<InsertArenaBossPage> createState() =>
      _InsertArenaBossPageState();
}

class _InsertArenaBossPageState extends ConsumerState<InsertArenaBossPage> {
  final _formKey = GlobalKey<FormState>();
  final labelcontroller = TextEditingController();
  final idcontroller = TextEditingController();
  final imageNamecontroller = TextEditingController();

  FilePickerResult? result;

  String curfirstValk = '';
  String cursecondValk = '';
  String curthirdValk = '';
  String curElf = '';

  String? id;
  String? name;
  int? rank;
  List teamrec = [];

  Future<void> uploadImage({
    required FilePickerResult result,
    required String fileName,
    required String folder,
  }) async {
    final db = DatabaseHelper.supabase;
    final image = File(result.files.single.path!);
    await db.storage.from('data').upload('images/$folder/$fileName', image);
  }

  Future<void> _submitPreview() async {
    if (_formKey.currentState!.validate()) {
      if (result == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please choose boss image")));
        return;
      }
      if (teamrec.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter at least 1 recommended team")),
        );
        return;
      }
      _formKey.currentState!.save();

      final ArenaBossModel previewBoss = ArenaBossModel(
        id: id!,
        name: name!,
        rank: rank!,
        teamrec: teamrec,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => ArenaPreviewPage(
                previewBoss: previewBoss,
                imagePath: result!.files.single.path!,
              ),
        ),
      );
    }
  }

  void showFullScreenLoading(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 128), // màu nền che phủ
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: false, // chặn nút back
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Colors.white,
                size: 70,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (result == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please choose boss image")));
        return;
      }
      if (teamrec.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter at least 1 recommended team")),
        );
        return;
      }
      _formKey.currentState!.save();

      final ArenaBossModel newBoss = ArenaBossModel(
        id: id!,
        name: name!,
        rank: rank!,
        teamrec: teamrec,
      );
      showFullScreenLoading(context);
      //upload image to database
      await uploadImage(
        result: result!,
        fileName: '${newBoss.id}.png',
        folder: 'arenabosses',
      );
      //add to database
      final db = DatabaseHelper.supabase;
      await db.from('arenabosses').insert(newBoss.toBossMap());
      await db.from('arenaboss_teamrec').insert(newBoss.toTeamrecListMap());
      ref.read(arenabossProvider).addBoss(newBoss);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(duration: Duration(seconds: 1), content: Text("Saved")),
        );
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    List<ArenaBossModel> bosses = ref.read(arenabossProvider).bosses;
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
                              Text('All bosses images are stored online'),
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
        title: Text('Insert Arena Boss Page'),
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButtonFormField<int>(
                        menuMaxHeight: 400,
                        value: rank,
                        decoration: InputDecoration(
                          labelText: 'Rank of boss',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(value: 2, child: Text('SS')),
                          DropdownMenuItem(value: 3, child: Text('SSS')),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select rank of boss';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            rank = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white, thickness: 3),
              Text(style: TextStyle(fontSize: 20), 'Recommended team of boss'),
              SizedBox(height: 20),
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
                        teamrec.add({
                          'id_arenaboss': id,
                          'first_valk': curfirstValk,
                          'second_valk': cursecondValk,
                          'third_valk': curthirdValk,
                          'elf': curElf,
                        });
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
                      if (teamrec.isNotEmpty) {
                        teamrec.removeLast();
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
