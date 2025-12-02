import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chamada.dart';

class ChamadaService {
  final supabase = Supabase.instance.client;

  Future<List<Chamada>> listarChamadas() async {
    final res = await supabase
        .from('chamadas')
        .select('''
          id,
          hora_inicio,
          hora_fim,
          aberta,
          data,
          presencas:presencas(id, aluno)
        ''')
        .order('hora_inicio');

    // Converte chamadas + presenças do banco
    return (res as List).map((map) {
      final chamada = Chamada.fromJson(map);

      // Ajusta lista de presenças (tabela separada)
      if (map['presencas'] != null) {
        chamada.presencas =
            (map['presencas'] as List).map((p) => p['aluno'].toString()).toList();
      } else {
        chamada.presencas = [];
      }

      return chamada;
    }).toList();
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
