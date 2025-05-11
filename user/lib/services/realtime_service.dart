import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/image_version_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeService {
  final SupabaseClient db;
  final Ref ref;
  late final RealtimeChannel _channel;

  RealtimeService(this.db, this.ref) {
    _channel = db.channel('app-realtime');

    _channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'valkyries',
          callback: (payload) {
            Future(() async {
              await ref.read(valkyrieProvider).loadValkyries();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'abyssbosses',
          callback: (payload) {
            Future(() async {
              await ref.read(abyssBossProvider).loadBosses();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'arenabosses',
          callback: (payload) {
            Future(() async {
              await ref.read(arenabossProvider).loadBosses();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'elfs',
          callback: (payload) {
            Future(() async {
              await ref.read(elfProvider).loadElfs();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'weathers',
          callback: (payload) {
            Future(() async {
              await ref.read(weatherProvider).loadWeathers();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'elfs_image_version',
          callback: (payload) {
            Future(() async {
              await ref.read(imageVersionProvider).loadElfs();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'arenabosses_image_version',
          callback: (payload) {
            Future(() async {
              await ref.read(imageVersionProvider).loadArenaBosses();
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'abyssbosses_image_version',
          callback: (payload) {
            Future(() async {
              await ref.read(imageVersionProvider).loadAbyssBosses();
            });
          },
        )
        .subscribe();
  }

  void dispose() {
    db.removeChannel(_channel);
  }
}
