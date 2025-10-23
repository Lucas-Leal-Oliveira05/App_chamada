import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';

import 'package:intl/intl.dart';
import 'dart:async';

class PainelStatusPage extends StatefulWidget {
  final ChamadaController controller;

  const PainelStatusPage({super.key, required this.controller});

  @override
  State<PainelStatusPage> createState() => _PainelStatusPageState();
}

class _PainelStatusPageState extends State<PainelStatusPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Atualiza a tela a cada 10s para refletir mudanças nos status
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final chamadas = controller.horarios;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Painel de Chamadas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: chamadas.length,
                itemBuilder: (context, index) {
                  final horario = chamadas[index];
                  final status = _obterStatusChamada(controller, horario);
                  final horaFormatada = DateFormat('HH:mm').format(horario);

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: _iconeStatus(status),
                      title: Text('Chamada das $horaFormatada'),
                      subtitle: Text(
                        status,
                        style: TextStyle(
                          color: _corStatus(status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Determina o status da chamada
  String _obterStatusChamada(ChamadaController controller, DateTime horario) {
    final agora = DateTime.now();

    // Se for a chamada atual e estiver aberta
    if (controller.chamadaAtual != null &&
        controller.chamadaAtual!.horaInicio.hour == horario.hour &&
        controller.chamadaAtual!.horaInicio.minute == horario.minute &&
        controller.chamadaAtual!.aberta) {
      return 'Em andamento';
    }

    // Se o horário ainda não chegou
    if (agora.isBefore(horario)) {
      return 'Não realizada';
    }

    // Se já passou do horário
    return 'Concluída';
  }

  /// Ícone visual do status
  Widget _iconeStatus(String status) {
    IconData icone;
    Color cor;

    switch (status) {
      case 'Em andamento':
        icone = Icons.play_circle_fill;
        cor = Colors.green;
        break;
      case 'Concluída':
        icone = Icons.check_circle;
        cor = Colors.grey;
        break;
      default:
        icone = Icons.schedule;
        cor = Colors.orange;
        break;
    }

    return Icon(icone, color: cor, size: 32);
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'Em andamento':
        return Colors.green;
      case 'Concluída':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }
}
