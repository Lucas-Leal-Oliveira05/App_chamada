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
      aberta: map['aberta'],
      presencas: List<String>.from(map['presencas'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "hora_inicio": horaInicio.toIso8601String(),
      "hora_fim": horaFim.toIso8601String(),
      "data": data.toIso8601String(),
      "aberta": aberta,
      "presencas": presencas,
    };
  }
}
