import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/chamada.dart';
import '../services/exporta.dart';

class ChamadaController extends ChangeNotifier {
  static final ChamadaController _instancia = ChamadaController._interno();
  factory ChamadaController() => _instancia;
  ChamadaController._interno() {
    _iniciarVerificacao();
    _carregarChamadasSalvas();
  }

  final Duration duracaoChamada = const Duration(minutes: 5);
  final List<DateTime> horarios = [
    DateTime.now().add(const Duration(seconds: 10)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 50),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 40),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21, 30),
  ];

  final List<Chamada> historico = [];
  Chamada? chamadaAtual;
  Timer? _timer;
  final _exportService = ExportService();

  Future<void> _carregarChamadasSalvas() async {
    final box = Hive.box<Chamada>('chamadas');
    historico.clear();
    historico.addAll(box.values);
    notifyListeners();
  }

  Future<void> _salvarChamadas() async {
    final box = Hive.box<Chamada>('chamadas');
    await box.clear();
    await box.addAll(historico);
  }

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
    _salvarChamadas();
    notifyListeners();
  }

  void _fecharChamada() {
    chamadaAtual!.aberta = false;
    _salvarChamadas();
    notifyListeners();
  }

  void registrarPresenca(String aluno) {
    if (chamadaAtual != null && chamadaAtual!.aberta) {
      chamadaAtual!.presencas.add(aluno);
      _salvarChamadas();
      notifyListeners();
    }
  }

  Future<String> exportarCSV() async {
    return await _exportService.gerarCSV(historico);
  }
}
