import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  String? label;
  String? id;
  String? imageName;
  int? astralop;
  int? dame0;
  int? dame1;
  List<int?> dame = [];
  int? type;

  void _submit() {
    if (label != '' &&
        id != '' &&
        imageName != '' &&
        astralop != null &&
        dame0 != null &&
        type != null) {
      dame.add(dame0!);
      if (dame1 != null) {
        dame.add(dame1);
      }
      List<ValkyrieModel> valkyries = ref.read(valkyrieProvider).valkyries;
      ValkyrieModel newvalk = ValkyrieModel(
        label: label!,
        id: id!,
        imageName: imageName!,
        astralop: astralop!,
        dame: dame,
        type: type!,
      );
      valkyries.add(newvalk);
      ref.read(valkyrieProvider).saveValkyriesListToJson(valkyries);
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
    String imagepath = ref.read(valkImagesPathPathProvider);
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
                                'Name of image file is the name of file that use to show valk\'s avatar',
                              ),
                              Text(
                                'You must add image to the this path: $imagepath',
                              ),
                              Text(
                                'The others field use number to represent the corresponding features of valk and these numbers have the same order as the filter cells. For example, in damage fields, 1 is fire, 2 is ice, 3 is lightning,... ',
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
                        decoration: InputDecoration(labelText: 'Name of valk'),
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
                          labelText: 'String id of valk',
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
                      child: DropdownButtonFormField<int>(
                        value: astralop,
                        decoration: InputDecoration(
                          labelText: 'AstralOP of valk',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            [1, 2, 3, 4, 5].map((e) {
                              return DropdownMenuItem<int>(
                                value: e,
                                child: Text('$e'),
                              );
                            }).toList(),
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
                            [1, 2, 3, 4, 5].map((e) {
                              return DropdownMenuItem<int>(
                                value: e,
                                child: Text('$e'),
                              );
                            }).toList(),
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
                      child: DropdownButtonFormField<int>(
                        value: dame1,
                        decoration: InputDecoration(
                          labelText: 'Second damage of valk',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            [null, 1, 2, 3, 4, 5].map((e) {
                              return DropdownMenuItem<int>(
                                value: e,
                                child: Text('$e'),
                              );
                            }).toList(),
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
                            [1, 2, 3, 4, 5, 6].map((e) {
                              return DropdownMenuItem<int>(
                                value: e,
                                child: Text('$e'),
                              );
                            }).toList(),
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
