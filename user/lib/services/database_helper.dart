import 'package:supabase_flutter/supabase_flutter.dart';

final anonkey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNueHJ6dWl1bGFqbWp4ZGp5eXZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY0NDk0NjMsImV4cCI6MjA2MjAyNTQ2M30.srQo667P_Ld8StfqclplAySt6Mw3eO859Dk0QR1mHqQ';

class DatabaseHelper {
  static SupabaseClient supabase = SupabaseClient(
    'https://cnxrzuiulajmjxdjyyvs.supabase.co',
    anonkey,
  );
}
