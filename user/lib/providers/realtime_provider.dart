import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_honkai/services/realtime_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final realtimeServiceProvider = Provider((ref) {
  return RealtimeService(DatabaseHelper.supabase, ref);
});
