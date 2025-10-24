class Chamada {
  DateTime horaInicio;
  DateTime horaFim;
  bool aberta;
  List<String> presencas;

  Chamada({
    required this.horaInicio,
    required this.horaFim,
    this.aberta = false,
    List<String>? presencas,
  }) : presencas = presencas ?? [];
}
