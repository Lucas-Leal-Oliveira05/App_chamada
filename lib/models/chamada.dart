class Chamada {
  final DateTime horaInicio;
  final DateTime horaFim;
  bool aberta;
  final List<String> presencas;

  Chamada({
    required this.horaInicio,
    required this.horaFim,
    this.aberta = false,
    this.presencas = const [],
  });
}
