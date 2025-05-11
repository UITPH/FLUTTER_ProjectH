import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AbyssbossModifyPage extends ConsumerStatefulWidget {
  final AbyssBossModel boss;
  const AbyssbossModifyPage({super.key, required this.boss});

  @override
  ConsumerState<AbyssbossModifyPage> createState() =>
      _AbyssbossModifyPageState();
}

class _AbyssbossModifyPageState extends ConsumerState<AbyssbossModifyPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final mechanicController = TextEditingController();
  final resistanceController = TextEditingController();

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
  List teamrec = [];

  Future<void> uploadImage({
    required FilePickerResult result,
    required String fileName,
    required String folder,
  }) async {
    final db = DatabaseHelper.supabase;
    final image = File(result.files.single.path!);
    await db.storage
        .from('data')
        .upload(
          'images/$folder/$fileName',
          image,
          fileOptions: FileOptions(upsert: true),
        );
  }

  Widget getAbyssBossImage(BuildContext context, String id) {
    final version =
        ref
            .read(imageVersionProvider)
            .abyssbosses
            .firstWhere((boss) => boss['id'] == id)['version'];
    final db = DatabaseHelper.supabase;
    final url =
        '${db.storage.from('data').getPublicUrl('images/abyssbosses/$id.png')}?v=$version';

    return CachedNetworkImage(
      fit: BoxFit.contain,
      placeholder:
          (context, url) => LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl: url,
    );
  }

  Future<void> _submitPreview() async {
    if (_formKey.currentState!.validate()) {
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
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => AbyssPreviewPage(
                previewBoss: previewBoss,
                image:
                    result != null
                        ? Image.file(File(result!.files.single.path!))
                        : getAbyssBossImage(context, previewBoss.id),
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
      if (teamrec.isEmpty) {
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
      );
      showFullScreenLoading(context);
      //upload image to database
      if (result != null) {
        await uploadImage(
          result: result!,
          fileName: '${newBoss.id}.png',
          folder: 'abyssbosses',
        );
      }
      final db = DatabaseHelper.supabase;
      final version = DateTime.now().millisecondsSinceEpoch.toString();
      await db.from('abyssbosses_image_version').upsert({
        'id': newBoss.id,
        'version': version,
      });
      ref.read(imageVersionProvider).modifyAbyssBoss(newBoss.id, version);
      //add to database
      await db.from('abyssbosses').upsert(newBoss.toBossMap());
      await db
          .from('abyssboss_teamrec')
          .delete()
          .eq('id_abyssboss', newBoss.id);
      await db.from('abyssboss_teamrec').insert(newBoss.toTeamrecListMap());
      ref.read(abyssBossProvider).removeBoss(newBoss.id);
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
  void initState() {
    id = idController.text = widget.boss.id;
    name = nameController.text = widget.boss.name;
    idWeather = widget.boss.idWeather;
    mechanic = mechanicController.text = widget.boss.mechanic;
    resistance = resistanceController.text = widget.boss.resistance;
    teamrec = widget.boss.teamrec;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<WeatherModel> weathers = ref.read(weatherProvider).weathers;
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
        title: Text('Modify Abyss Boss Page'),
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
                                    : SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: getAbyssBossImage(context, id!),
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
                        controller: idController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'String id of boss',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: nameController,
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
                        controller: mechanicController,
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
                        controller: resistanceController,
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
