import 'dart:async';
import '../models/chamada.dart';
import '../services/exporta.dart';

class ChamadaController {
  final List<DateTime> horarios = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 50),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 40),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21, 30),
  ];

  final Duration duracaoChamada = const Duration(minutes: 5);
  final List<Chamada> historico = [];

  Timer? _timer;
  Chamada? chamadaAtual;

  final _exportService = ExportService();

  ChamadaController() {
    _iniciarVerificacao();
  }

  void _iniciarVerificacao() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _verificarChamadas());
  }

  void _verificarChamadas() {
    final agora = DateTime.now();
    for (final h in horarios) {
      if (agora.hour == h.hour &&
          agora.minute >= h.minute &&
          agora.isBefore(h.add(duracaoChamada))) {
        if (chamadaAtual == null || !chamadaAtual!.aberta) {
          _abrirChamada(h);
        }
        return;
      }
    }
    if (chamadaAtual != null && chamadaAtual!.aberta) {
      final fim = chamadaAtual!.horaInicio.add(duracaoChamada);
      if (agora.isAfter(fim)) {
        _fecharChamada();
      }
    }
  }

  void _abrirChamada(DateTime horario) {
    chamadaAtual = Chamada(
      horaInicio: horario,
      horaFim: horario.add(duracaoChamada),
      aberta: true,
    );
    historico.add(chamadaAtual!);
  }

  void _fecharChamada() {
    chamadaAtual!.aberta = false;
  }

  void registrarPresenca(String aluno) {
    if (chamadaAtual != null && chamadaAtual!.aberta) {
      chamadaAtual!.presencas.add(aluno);
    }
  }

  Future<String> exportarCSV() async {
    return await _exportService.gerarCSV(historico);
  }
}
