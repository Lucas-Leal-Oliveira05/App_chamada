import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chamada.dart';
import '../services/exporta.dart';

class ChamadaController extends ChangeNotifier { // ✅ agora é um ChangeNotifier
  // 🔹 Singleton
  static final ChamadaController _instancia = ChamadaController._interno();
  factory ChamadaController() => _instancia;

  ChamadaController._interno() {
    _iniciarVerificacao();
  }

  final List<DateTime> horarios = [
    DateTime.now().add(const Duration(seconds: 10)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 50),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 40),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21, 30),
  ];

  final Duration duracaoChamada = const Duration(minutes: 5);
  final List<Chamada> historico = [];

  Timer? _timer;
  Chamada? chamadaAtual;
  final _exportService = ExportService();

  void _iniciarVerificacao() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _verificarChamadas());
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
    notifyListeners(); // ✅ avisa a interface
  }

  void _fecharChamada() {
    chamadaAtual!.aberta = false;
    notifyListeners(); // ✅ atualiza interface
  }

  void registrarPresenca(String aluno) {
    if (chamadaAtual != null && chamadaAtual!.aberta) {
      chamadaAtual!.presencas.add(aluno);
      notifyListeners(); // ✅ notifica quando alguém marca presença
    }
  }

  Future<String> exportarCSV() async {
    return await _exportService.gerarCSV(historico);
  }
}
