import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';
import '../services/medidasSeguranca.dart';

class PresencaPage extends StatefulWidget {
  final ChamadaController controller;
  final String usuarioLogado;

  const PresencaPage({
    super.key,
    required this.controller,
    required this.usuarioLogado,
  });

  @override
  State<PresencaPage> createState() => _PresencaPageState();
}

class _PresencaPageState extends State<PresencaPage> {
  final SegurancaService seg = SegurancaService();
  bool carregando = false;

  Future<bool> verificarTudo() async {
    // 🔹 Checagem de GPS
    bool posicaoOk = await seg.verificarLocalizacao();
    if (!posicaoOk) {
      _msg("Você não está dentro do campus.");
      return false;
    }

    // 🔹 Checagem de sensores
    bool sensoresOk = await seg.verificarSensores();
    if (!sensoresOk) {
      _msg("Falha nos sensores — possível dispositivo emulado.");
      return false;
    }

    // 🔹 Checagem de tempo desde o boot
    bool horarioOk = await seg.verificarHorario();
    if (!horarioOk) {
      _msg("Horário do sistema suspeito — reinício recente detectado.");
      return false;
    }

    return true;
  }

  void _msg(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Future<void> registrar() async {
    final chamada = widget.controller.chamadaAtual;

    if (chamada == null || !chamada.aberta) {
      _msg("Nenhuma chamada em andamento.");
      return;
    }

    if (chamada.presencas.contains(widget.usuarioLogado)) {
      _msg("Você já registrou presença.");
      return;
    }

    setState(() => carregando = true);

    bool ok = await verificarTudo();

    setState(() => carregando = false);

    if (ok) {
      widget.controller.registrarPresenca(widget.usuarioLogado);
      _msg("Presença registrada!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Presença'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: carregando
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check, size: 28),
                    label: const Text(
                      'Registrar Presença',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    onPressed: registrar,
                  ),
                ),
        ),
      ),
    );
  }
}
