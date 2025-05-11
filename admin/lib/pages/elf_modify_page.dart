import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/pages/advanced_page.dart';
import 'package:flutter_honkai/pages/preview_elf/elf_preview_page.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ElfModifyPage extends ConsumerStatefulWidget {
  final ElfModel elf;
  const ElfModifyPage({super.key, required this.elf});

  @override
  ConsumerState<ElfModifyPage> createState() => _ElfModifyPageState();
}

class _ElfModifyPageState extends ConsumerState<ElfModifyPage> {
  final _formKey = GlobalKey<FormState>();

  FilePickerResult? result;

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController overviewController = TextEditingController();

  String? id;
  String? name;
  String? overview;

  Widget getElfImage(BuildContext context, String id) {
    final version =
        ref
            .read(imageVersionProvider)
            .elfs
            .firstWhere((elf) => elf['id'] == id)['version'];
    final db = DatabaseHelper.supabase;
    final url =
        '${db.storage.from('data').getPublicUrl('images/elfs/$id.png')}?v=$version';

    return CachedNetworkImage(
      width: 120,
      height: 120,
      fit: BoxFit.fill,
      placeholder:
          (context, url) => LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl: url,
    );
  }

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

  Future<void> _submitPreview() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final ElfModel previewElf = ElfModel(
        id: id!,
        name: name!,
        overview: overview!,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => ElfPreviewPage(
                previewElf: previewElf,
                image:
                    result == null
                        ? getElfImage(context, id!)
                        : Image.file(
                          fit: BoxFit.fill,
                          width: 120,
                          height: 120,
                          File(result!.files.single.path!),
                        ),
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
      _formKey.currentState!.save();

      final ElfModel newElf = ElfModel(
        id: id!,
        name: name!,
        overview: overview!,
      );
      showFullScreenLoading(context);
      //upload image to database
      if (result != null) {
        await uploadImage(
          result: result!,
          fileName: '${newElf.id}.png',
          folder: 'elfs',
        );
      }
      final db = DatabaseHelper.supabase;
      final version = DateTime.now().millisecondsSinceEpoch.toString();
      await db.from('elfs_image_version').upsert({
        'id': newElf.id,
        'version': version,
      });
      ref.read(imageVersionProvider).modifyElf(newElf.id, version);
      //add to database
      await db.from('elfs').upsert(newElf.toMap());
      ref.read(elfProvider).removeElf(newElf.id);
      ref.read(elfProvider).addElf(newElf);
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
    id = idController.text = widget.elf.id;
    name = nameController.text = widget.elf.name;
    overview = overviewController.text = widget.elf.overview;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Modify Elf Page'),
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
                                      fit: BoxFit.fill,
                                      width: 120,
                                      height: 120,
                                      File(result!.files.single.path!),
                                    )
                                    : getElfImage(context, id!),
                          ),
                          Text('Select an image of elf'),
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
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'String id of elf',
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
                        decoration: InputDecoration(labelText: 'Name of elf'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter name of elf';
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
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: overviewController,
                  readOnly: false,
                  enabled: true,
                  decoration: InputDecoration(
                    labelText: 'Overview information',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter this field';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    overview = value;
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
            ],
          ),
        ),
      ),
    );
  }
}
