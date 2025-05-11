import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:path_provider/path_provider.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Future<void> load() async {
    final db = DatabaseHelper.supabase;
    final data = await db.from('valkyries').select('''
    *, 
    lineup:lineup!id_owner_valk(
      name, leader, 
      lineup_first_valk_list(id_valk), 
      lineup_second_valk_list(id_valk)
    )
    ''');

    final data2 =
        data
            .map(
              (e) => <String, dynamic>{
                'id': e['id'],
                'name': e['name'],
                'astralop': e['astralop'],
                'damage': e['damage'],
                'type': e['type'],
                'equipment': e['equipment'],
                'role': e['role'],
                'pullrec': e['pullrec'],
                'rankup': e['rankup'],
                'lineup':
                    e['lineup']
                        .map(
                          (x) => <String, dynamic>{
                            'note': x['name'],
                            'leader': x['leader'],
                            'first_valk_list':
                                x['lineup_first_valk_list']
                                    .map((y) => y['id_valk'])
                                    .toList(),
                            'second_valk_list':
                                x['lineup_second_valk_list']
                                    .map((y) => y['id_valk'])
                                    .toList(),
                          },
                        )
                        .toList(),
              },
            )
            .toList();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/test.txt');
    file.writeAsString(JsonEncoder.withIndent('    ').convert(data2));
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
