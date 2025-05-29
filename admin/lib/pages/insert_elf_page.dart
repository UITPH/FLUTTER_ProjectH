import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/pages/advanced_page.dart';
import 'package:flutter_honkai/pages/preview_elf/elf_preview_page.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InsertElfPage extends ConsumerStatefulWidget {
  const InsertElfPage({super.key});

  @override
  ConsumerState<InsertElfPage> createState() => _InsertElfPageState();
}

class _InsertElfPageState extends ConsumerState<InsertElfPage> {
  final _formKey = GlobalKey<FormState>();

  FilePickerResult? result;

  String? id;
  String? name;
  String? overview;

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
        ).showSnackBar(SnackBar(content: Text("Please choose elf image")));
        return;
      }
      _formKey.currentState!.save();

      final ElfModel previewElf = ElfModel(
        id: id!,
        name: name!,
        overview: overview!,
        version: '',
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => ElfPreviewPage(
                previewElf: previewElf,
                image: Image.file(
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
        ).showSnackBar(SnackBar(content: Text("Please choose elf image")));
        return;
      }
      _formKey.currentState!.save();

      final ElfModel newElf = ElfModel(
        id: id!,
        name: name!,
        overview: overview!,
        version: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      if (mounted) showFullScreenLoading(context);
      //upload image to database
      await uploadImage(
        result: result!,
        fileName: '${newElf.id}.png',
        folder: 'elfs',
      );
      //add to database
      final db = DatabaseHelper.supabase;
      await db.from('elfs').insert(newElf.toMap());
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
  Widget build(BuildContext context) {
    List<ElfModel> elfs = ref.read(elfProvider).elfs;
    return Scaffold(
      appBar: AppBar(title: Text('Insert Elf Page')),
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
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'String id of elf',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (elfs.any((elf) => elf.id == value)) {
                            return 'This id is existed';
                          }
                          if (value == '') {
                            return 'Please enter id of elf';
                          }
                          if (value!.length > 15) {
                            return 'Elf\'s id character limit is 15';
                          }
                          if (value.contains(' ')) {
                            return 'Elf\'s id cannot contain any space';
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
                        decoration: InputDecoration(labelText: 'Name of elf'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter name of elf';
                          }
                          if (value!.length > 50) {
                            return 'Elf\'s name character limit is 50';
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
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
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
