import 'dart:convert';
import 'package:intl/intl.dart';

class Chamada {
  String? id;
  DateTime horaInicio;
  DateTime horaFim;
  DateTime data;
  bool aberta;
  List<String> presencas;

  Chamada({
    this.id,
    required this.horaInicio,
    required this.horaFim,
    required this.data,
    required this.aberta,
    List<String>? presencas,
  }) : presencas = presencas ?? [];

  factory Chamada.fromJson(Map<String, dynamic> map) {
    return Chamada(
      id: map['id'],
      horaInicio: DateTime.parse(map['hora_inicio']),
      horaFim: DateTime.parse(map['hora_fim']),
      data: DateTime.parse(map['data']),
      aberta: map['aberta'] ?? false,
      presencas: _extrairPresencas(map['presencas']),
    );
  }

Map<String, dynamic> toJson() {
  return {
    "hora_inicio": horaInicio.toIso8601String(),
    "hora_fim": horaFim.toIso8601String(),
    "data": DateFormat('yyyy-MM-dd').format(data), // <- SE A COLUNA FOR DATE
    "aberta": aberta,
  };
}


  /// trata todos os formatos
  static List<String> _extrairPresencas(dynamic valor) {
    if (valor == null) return [];

    //lista de strings
    if (valor is List<String>) return valor;

    //lista dinâmica
    if (valor is List) {
      return valor.map((e) => e.toString()).toList();
    }

    //JSON string
    if (valor is String) {
      try {
        final decoded = List<String>.from(jsonDecode(valor));
        return decoded;
      } catch (_) {}
    }

    return [];
  }
}
