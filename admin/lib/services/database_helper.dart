import 'package:supabase_flutter/supabase_flutter.dart';

final serviceKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNueHJ6dWl1bGFqbWp4ZGp5eXZzIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NjQ0OTQ2MywiZXhwIjoyMDYyMDI1NDYzfQ.5BB0g9JdNIs1agSEBeFAtww_qRywjOH6L6ONLOoNaLQ';

class DatabaseHelper {
  static SupabaseClient supabase = SupabaseClient(
    'https://cnxrzuiulajmjxdjyyvs.supabase.co',
    serviceKey,
  );
}
