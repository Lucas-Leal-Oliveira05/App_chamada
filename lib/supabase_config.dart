import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://gjgcgitpyyjjdbrxbfbl.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdqZ2NnaXRweXlqamRicnhiZmJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzMzUxMTYsImV4cCI6MjA3OTkxMTExNn0.4ntbnXw8D8b3orGVbGhNKHiM_wGDG5IHZdBMrcmXnt4', //senha
    );
  }
}
