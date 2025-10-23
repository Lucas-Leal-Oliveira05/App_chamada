import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/controle_chamada.dart';
import 'presenca.dart';

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

    // Atualiza o painel periodicamente para refletir o estado das chamadas
    _timer = Timer.periodic(const Duration(seconds: 20), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Retorna o status atual da chamada
  String _getStatus(DateTime horario) {
    final agora = DateTime.now();
    final inicio = horario;
    final fim = horario.add(widget.controller.duracaoChamada);

    if (agora.isBefore(inicio)) return 'Não iniciada';
    if (agora.isAfter(fim)) return 'Encerrada';
    return 'Em andamento';
  }

  // Cores de status
  Color _getCorStatus(String status) {
    switch (status) {
      case 'Em andamento':
        return Colors.orange;
      case 'Encerrada':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final horarios = widget.controller.horarios;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: ListView.builder(
        itemCount: horarios.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final horario = horarios[index];
          final status = _getStatus(horario);
          final cor = _getCorStatus(status);
          final horaFormatada = DateFormat('HH:mm').format(horario);
          final emAndamento = status == 'Em andamento';

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linha principal (horário + status)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chamada das $horaFormatada',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: cor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: cor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // 🔹 Parte expandida (aparece somente durante a chamada)
                if (emAndamento) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'A chamada está aberta! Os alunos podem registrar presença agora.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'Ir para Presença',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PresencaPage(controller: widget.controller),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
