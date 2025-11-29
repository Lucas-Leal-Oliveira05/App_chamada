import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../models/chamada.dart';
import '../services/chamada_service.dart';
import '../services/exporta.dart';

class ChamadaController extends ChangeNotifier {
  final _service = ChamadaService();

  static final ChamadaController _instancia = ChamadaController._interno();
  factory ChamadaController() => _instancia;

  ChamadaController._interno() {
    _iniciarVerificacao();
    _carregarChamadas();
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

  Future<void> _carregarChamadas() async {
    historico.clear();
    historico.addAll(await _service.listarChamadas());

    chamadaAtual = historico.where((c) => c.aberta).cast<Chamada?>().firstOrNull;
    
    notifyListeners();
  }

  void _iniciarVerificacao() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _verificarChamadas(),
    );
  }

void _verificarChamadas() {
  final agora = DateTime.now();

  for (final h in horarios) {
    final inicio = h;
    final fim = h.add(duracaoChamada);

    if ((agora.isAtSameMomentAs(inicio) || agora.isAfter(inicio)) &&
        agora.isBefore(fim)) {
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


  Future<void> _abrirChamada(DateTime horario) async {
    final nova = Chamada(
      horaInicio: horario,
      horaFim: horario.add(duracaoChamada),
      data: DateTime.now(),
      aberta: true,
      presencas: [],
    );

    final criada = await _service.criarChamada(nova);

    chamadaAtual = criada;
    historico.add(criada);

    notifyListeners();
  }

  Future<void> _fecharChamada() async {
    chamadaAtual!.aberta = false;
    await _service.atualizarChamada(chamadaAtual!);
    notifyListeners();
  }

  Future<void> registrarPresenca(String aluno) async {
    if (chamadaAtual != null && chamadaAtual!.aberta) {
      chamadaAtual!.presencas.add(aluno);
      await _service.atualizarChamada(chamadaAtual!);
      notifyListeners();
    }
  }

  Future<String> exportarCSV() async {
    return await _exportService.gerarCSV(historico);
  }
}
