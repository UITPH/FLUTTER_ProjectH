import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddValkyriePage extends ConsumerStatefulWidget {
  const AddValkyriePage({super.key});

  @override
  ConsumerState<AddValkyriePage> createState() => _AddValkyriePageState();
}

class _AddValkyriePageState extends ConsumerState<AddValkyriePage> {
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

  bool isCheckButtonPressed = false;

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
      List<ValkyrieModel> valkyries = ref.read(valkyrieProvider);
      ValkyrieModel newvalk = ValkyrieModel(
        label: label!,
        id: id!,
        imageName: imageName!,
        astralop: astralop!,
        dame: dame,
        type: type!,
      );
      valkyries.add(newvalk);
      saveValkyriesListToJson(valkyries);
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
    return Scaffold(
      appBar: AppBar(title: Text('Add Valkyrie Page')),
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
              Visibility(
                visible: isCheckButtonPressed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style: TextStyle(fontSize: 15),
                      'Name of valk: $label',
                    ),
                    Text(
                      style: TextStyle(fontSize: 15),
                      'String id of valk: $id',
                    ),
                    Text(
                      style: TextStyle(fontSize: 15),
                      'Name of image file: $imageName',
                    ),
                    Text(
                      style: TextStyle(fontSize: 15),
                      'AstralOP of valk: $astralop',
                    ),
                    Text(
                      style: TextStyle(fontSize: 15),
                      'Dame of valk: [$dame0, $dame1]',
                    ),
                    Text(style: TextStyle(fontSize: 15), 'Type of Valk: $type'),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
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
                        isCheckButtonPressed = true;
                      });
                    },
                    child: Text(
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      'Check',
                    ),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
