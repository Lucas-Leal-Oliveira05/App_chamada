import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chamada.dart';

class ChamadaService {
  final supabase = Supabase.instance.client;

  Future<List<Chamada>> listarChamadas() async {
    final res = await supabase.from('chamadas').select().order('hora_inicio');
    return (res as List).map((e) => Chamada.fromJson(e)).toList();
  }

  Future<Chamada> criarChamada(Chamada c) async {
    final res = await supabase
        .from('chamadas')
        .insert(c.toJson())
        .select()
        .single();
    return Chamada.fromJson(res);
  }

  Future<void> atualizarChamada(Chamada c) async {
    await supabase.from('chamadas').update(c.toJson()).eq('id', c.id!.toInt());
  }
}
