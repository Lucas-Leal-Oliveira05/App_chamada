import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chamada.dart';

class ChamadaService {
  final supabase = Supabase.instance.client;

  Future<List<Chamada>> listarChamadas() async {
    // 1. Buscar todas as chamadas
    final res = await supabase
        .from('chamadas')
        .select()
        .order('hora_inicio');

    final chamadas = (res as List).map((e) => Chamada.fromJson(e)).toList();

    // 2. Buscar as presenças para cada chamada
    for (final chamada in chamadas) {
      final presencasRes = await supabase
          .from('presencas')
          .select()
          .eq('id_chamada', chamada.id!);

      chamada.presencas = presencasRes
          .map<String>((p) => p['aluno'].toString())
          .toList();
    }

    return chamadas;
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
    await supabase
        .from('chamadas')
        .update(c.toJson())
        .eq('id', c.id!);
  }
}
