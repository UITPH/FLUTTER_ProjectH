import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/main.dart';
import 'package:flutter_honkai/pages/maintainance_page.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/parameter_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

class RealtimeService {
  final SupabaseClient db;
  final Ref ref;
  late final RealtimeChannel _channel;

  final _eventQueue = Queue<Future<void> Function()>();
  bool _isProcessing = false;

  RealtimeService(this.db, this.ref) {
    _channel = db.channel('app-realtime');

    _channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'valkyries',
          callback: (payload) {
            _enqueue(() async {
              await ref.read(valkyrieProvider).loadValkyries();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'abyssbosses',
          callback: (payload) {
            _enqueue(() async {
              await ref.read(abyssBossProvider).loadBosses();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'arenabosses',
          callback: (payload) {
            _enqueue(() async {
              await ref.read(arenabossProvider).loadBosses();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'elfs',
          callback: (payload) {
            _enqueue(() async {
              await ref.read(elfProvider).loadElfs();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'parameters',
          callback: (payload) {
            _enqueue(() async {
              final provider = ref.read(parameterProvider);
              await provider.loadParameters();
              if (provider.parameters.isMaintainance == 1) {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => MaintainancePage(counter: 10),
                  ),
                );
                await Future.delayed(Duration(seconds: 10));
                await windowManager.close();
              }
            });
          },
        )
        .subscribe();
  }

  void _enqueue(Future<void> Function() task) {
    _eventQueue.add(task);
    _processQueue();
  }

  void _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_eventQueue.isNotEmpty) {
      final task = _eventQueue.removeFirst();
      await task();
    }

    _isProcessing = false;
  }

  void dispose() {
    db.removeChannel(_channel);
  }
}
