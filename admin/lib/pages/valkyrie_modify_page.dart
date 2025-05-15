import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/pages/advanced_page.dart';
import 'package:flutter_honkai/pages/preview_valk/valkyrie_preview_page.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ValkyrieModifyPage extends ConsumerStatefulWidget {
  final ValkyrieModel valk;
  const ValkyrieModifyPage({super.key, required this.valk});

  @override
  ConsumerState<ValkyrieModifyPage> createState() => _ValkyrieModifyPageState();
}

class _ValkyrieModifyPageState extends ConsumerState<ValkyrieModifyPage> {
  final _formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final pullrecController = TextEditingController();
  final rankupController = TextEditingController();

  String? id;
  String? name;
  int? astralop;
  int? dame0;
  int? dame1;
  List damage = [];
  int? type;
  String? equipment;
  List lineup = [];
  String? role;
  String? pullrec;
  String? rankup;

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

  Widget getValkImage(BuildContext context, String id) {
    final version =
        ref
            .read(valkyrieProvider)
            .valkyries
            .firstWhere((valk) => valk.id == id)
            .version;
    final db = DatabaseHelper.supabase;
    final url =
        '${db.storage.from('data').getPublicUrl('images/valkyries/$id.png')}?v=$version';

    return CachedNetworkImage(
      fit: BoxFit.fill,
      placeholder:
          (context, url) => LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl: url,
    );
  }

  Widget getEquipmentImage(BuildContext context, String id, String type) {
    final version =
        ref
            .read(valkyrieProvider)
            .valkyries
            .firstWhere((valk) => valk.id == id)
            .version;
    final db = DatabaseHelper.supabase;
    final url =
        '${db.storage.from('data').getPublicUrl('images/equipments/$id$type.png')}?v=$version';

    return CachedNetworkImage(
      fit: BoxFit.fill,
      placeholder:
          (context, url) => LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl: url,
    );
  }

  void _submitPreview() {
    if (_formKey.currentState!.validate()) {
      if (lineup.isEmpty) {
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
        lineup: lineup,
        role: role!,
        pullrec: pullrec!,
        rankup: rankup!,
        version: '',
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => ValkyriePreviewPage(
                previewValkyrie: previewValkyrie,
                valkImage:
                    resultvalk != null
                        ? Image.file(
                          fit: BoxFit.fill,
                          File(resultvalk!.files.single.path!),
                        )
                        : getValkImage(context, previewValkyrie.id),
                weapImage:
                    resultweap != null
                        ? Image.file(
                          fit: BoxFit.fill,
                          File(resultweap!.files.single.path!),
                        )
                        : getEquipmentImage(
                          context,
                          previewValkyrie.id,
                          'weap',
                        ),
                topImage:
                    resulttop != null
                        ? Image.file(
                          fit: BoxFit.fill,
                          File(resulttop!.files.single.path!),
                        )
                        : getEquipmentImage(context, previewValkyrie.id, 'top'),
                midImage:
                    resultmid != null
                        ? Image.file(
                          fit: BoxFit.fill,
                          File(resultmid!.files.single.path!),
                        )
                        : getEquipmentImage(context, previewValkyrie.id, 'mid'),
                botImage:
                    resultbot != null
                        ? Image.file(
                          fit: BoxFit.fill,
                          File(resultbot!.files.single.path!),
                        )
                        : getEquipmentImage(context, previewValkyrie.id, 'bot'),
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (lineup.isEmpty) {
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
        lineup: lineup,
        role: role!,
        pullrec: pullrec!,
        rankup: rankup!,
        version: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      showFullScreenLoading(context);
      //upload image to database
      if (resultvalk != null) {
        await uploadImage(
          result: resultvalk!,
          fileName: '${newValkyrie.id}.png',
          folder: 'valkyries',
        );
      }
      if (resultweap != null) {
        await uploadImage(
          result: resultweap!,
          fileName: '${newValkyrie.id}weap.png',
          folder: 'equipments',
        );
      }
      if (resulttop != null) {
        await uploadImage(
          result: resulttop!,
          fileName: '${newValkyrie.id}top.png',
          folder: 'equipments',
        );
      }
      if (resultmid != null) {
        await uploadImage(
          result: resultmid!,
          fileName: '${newValkyrie.id}mid.png',
          folder: 'equipments',
        );
      }
      if (resultbot != null) {
        await uploadImage(
          result: resultbot!,
          fileName: '${newValkyrie.id}bot.png',
          folder: 'equipments',
        );
      }
      //add to database
      final db = DatabaseHelper.supabase;
      await db.from('lineup').delete().eq('id_owner_valk', newValkyrie.id);
      final ids = await db
          .from('lineup')
          .insert(newValkyrie.toLineupListMap())
          .select('id');
      newValkyrie.addIdToLineup(ids);
      await db
          .from('lineup_first_valk_list')
          .insert(newValkyrie.toLineupFirstValkListMap());
      await db
          .from('lineup_second_valk_list')
          .insert(newValkyrie.toLineupSecondValkListMap());
      await db.from('lineup_elf_list').insert(newValkyrie.toLineupElfListMap());
      await db.from('valkyries').upsert(newValkyrie.toValkMap());
      ref.read(valkyrieProvider).removeValkyrie(newValkyrie.id);
      ref.read(valkyrieProvider).addValkyrie(newValkyrie);
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
    id = idController.text = widget.valk.id;
    name = nameController.text = widget.valk.name;
    astralop = widget.valk.astralop;
    dame0 = widget.valk.damage[0];
    if (damage.length == 2) dame1 = widget.valk.damage[1];
    type = widget.valk.type;
    role = roleController.text = widget.valk.role;
    pullrec = pullrecController.text = widget.valk.pullrec;
    rankup = rankupController.text = widget.valk.rankup;
    lineup = widget.valk.lineup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final valkyries = ref.watch(valkyrieProvider).valkyries;
    final elfs = ref.watch(elfProvider).elfs;
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),
        title: Text('Modify Valkyrie Page'),
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
                                        fit: BoxFit.fill,
                                        width: 70,
                                        height: 70,
                                        File(resultvalk!.files.single.path!),
                                      )
                                      : SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: getValkImage(context, id!),
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
                          controller: idController,
                          readOnly: false,
                          enabled: true,
                          decoration: InputDecoration(
                            labelText: 'String id of valk',
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
                                        fit: BoxFit.fill,
                                        width: 70,
                                        height: 70,
                                        File(resultweap!.files.single.path!),
                                      )
                                      : SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: getEquipmentImage(
                                          context,
                                          id!,
                                          'weap',
                                        ),
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
                                        fit: BoxFit.fill,
                                        width: 70,
                                        height: 70,
                                        File(resulttop!.files.single.path!),
                                      )
                                      : SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: getEquipmentImage(
                                          context,
                                          id!,
                                          'top',
                                        ),
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
                                        fit: BoxFit.fill,
                                        width: 70,
                                        height: 70,
                                        File(resultmid!.files.single.path!),
                                      )
                                      : SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: getEquipmentImage(
                                          context,
                                          id!,
                                          'mid',
                                        ),
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
                                        fit: BoxFit.fill,
                                        width: 70,
                                        height: 70,
                                        File(resultbot!.files.single.path!),
                                      )
                                      : SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: getEquipmentImage(
                                          context,
                                          id!,
                                          'bot',
                                        ),
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
                                                  lineup: [],
                                                  role: '',
                                                  pullrec: '',
                                                  rankup: '',
                                                  version: '',
                                                ),
                                                ...valkyries.where(
                                                  (valk) => valk.id != id!,
                                                ),
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
                                                  lineup: [],
                                                  role: '',
                                                  pullrec: '',
                                                  rankup: '',
                                                  version: '',
                                                ),
                                                ...valkyries.where(
                                                  (valk) => valk.id != id!,
                                                ),
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
                                                  lineup: [],
                                                  role: '',
                                                  pullrec: '',
                                                  rankup: '',
                                                  version: '',
                                                ),
                                                ...valkyries.where(
                                                  (valk) => valk.id != id!,
                                                ),
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
                          lineup.add({
                            'note': curnote,
                            'leader': curleader[0],
                            'first_valk_list': curfirstValkList,
                            'second_valk_list': cursecondValkList,
                            'elf_list': curelfList,
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
                        if (lineup.isNotEmpty) {
                          lineup.removeLast();
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
                    controller: roleController,
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
                    controller: pullrecController,
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
                      pullrec = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: rankupController,
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
