import 'package:supabase_flutter/supabase_flutter.dart';

class PresencaService {
  final supabase = Supabase.instance.client;

  Future<void> registrarPresenca(String idChamada, String aluno) async {
    await supabase.from('presencas').insert({
      'id_chamada': idChamada,
      'aluno': aluno,
    });
  }

  Future<List<String>> listarPresencas(String idChamada) async {
    final res = await supabase
        .from('presencas')
        .select('aluno')
        .eq('id_chamada', idChamada);

    return res.map<String>((e) => e['aluno'] as String).toList();
  }
}