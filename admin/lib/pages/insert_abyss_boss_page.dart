import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/pages/advanced_page.dart';
import 'package:flutter_honkai/pages/preview_boss/abyss_preview_page.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  final curnoteController = TextEditingController();
  String curfirstValk = '';
  final curfirstValkController = TextEditingController();
  String cursecondValk = '';
  final cursecondValkController = TextEditingController();
  String curthirdValk = '';
  final curthirdValkController = TextEditingController();
  String curElf = '';
  final curElfController = TextEditingController();

  String? id;
  String? name;
  String? idWeather;
  String? mechanic;
  String? resistance;
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

      final AbyssBossModel previewBoss = AbyssBossModel(
        id: id!,
        name: name!,
        idWeather: idWeather!,
        mechanic: mechanic!,
        resistance: resistance!,
        teamrec: teamrec,
        version: '',
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => AbyssPreviewPage(
                previewBoss: previewBoss,
                image: Image.file(File(result!.files.single.path!)),
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
    final connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus.contains(ConnectivityResult.none) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text("The internet connection is lost"),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      if (result == null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please choose boss image")));
        return;
      }
      if (teamrec.isEmpty && mounted) {
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
        teamrec: teamrec,
        version: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      if (mounted) showFullScreenLoading(context);
      //upload image to database
      await uploadImage(
        result: result!,
        fileName: '${newBoss.id}.png',
        folder: 'abyssbosses',
      );
      //add to database
      final db = DatabaseHelper.supabase;
      await db.from('abyssbosses').insert(newBoss.toBossMap());
      await db.from('abyssboss_teamrec').insert(newBoss.toTeamrecListMap());
      ref.read(abyssBossProvider).addBoss(newBoss);
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
    List<WeatherModel> weathers = ref.read(weatherProvider).weathers;
    List<AbyssBossModel> bosses = ref.read(abyssBossProvider).bosses;
    List<ValkyrieModel> valkyries = ref.read(valkyrieProvider).valkyries;
    List<ElfModel> elfs = ref.read(elfProvider).elfs;
    return Scaffold(
      appBar: AppBar(title: Text('Insert Abyss Boss Page')),
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
                                result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['png'],
                                );
                                setState(() {});
                              },
                              icon:
                                  result != null
                                      ? Image.file(
                                        width: 250,
                                        height: 80,
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
                            if (value!.length > 15) {
                              return 'Boss\'s id character limit is 15';
                            }
                            if (value.contains(' ')) {
                              return 'Boss\'s id cannot contain any space';
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
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          readOnly: false,
                          enabled: true,
                          decoration: InputDecoration(
                            labelText: 'Name of boss',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == '') {
                              return 'Please enter name of boss';
                            }
                            if (value!.length > 50) {
                              return 'Boss\'s name character limit is 50';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value;
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
                Text(
                  style: TextStyle(fontSize: 20),
                  'Recommended team of boss',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: curnoteController,
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
                          controller: curfirstValkController,
                          enableFilter: true,
                          menuHeight: 300,
                          label: Text('First valkyrie'),
                          initialSelection: curfirstValk,
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
                          controller: cursecondValkController,
                          enableFilter: true,
                          menuHeight: 300,
                          label: Text('Second valkyrie'),
                          initialSelection: cursecondValk,
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
                          controller: curthirdValkController,
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
                        controller: curElfController,
                        enableFilter: true,
                        menuHeight: 300,
                        label: Text('Elf'),
                        initialSelection: null,
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
                            'id_abyssboss': id,
                            'first_valk': curfirstValk,
                            'second_valk': cursecondValk,
                            'third_valk': curthirdValk,
                            'elf': curElf,
                            'note': curnote,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Added"),
                            ),
                          );
                          setState(() {
                            curfirstValk =
                                cursecondValk =
                                    curthirdValk =
                                        curElf =
                                            curnote =
                                                curfirstValkController.text =
                                                    cursecondValkController
                                                            .text =
                                                        curthirdValkController
                                                                .text =
                                                            curElfController
                                                                    .text =
                                                                curnoteController
                                                                    .text = '';
                          });
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
      ),
    );
  }
}
