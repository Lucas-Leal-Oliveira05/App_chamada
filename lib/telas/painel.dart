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
    // Atualiza a tela automaticamente
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getStatus(DateTime horario) {
    final agora = DateTime.now();
    final inicio = horario;
    final fim = horario.add(widget.controller.duracaoChamada);

    if (agora.isBefore(inicio)) return 'Não iniciada';
    if (agora.isAfter(fim)) return 'Encerrada';
    return 'Em andamento';
  }

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
      backgroundColor: const Color(0xFFF7F7F7),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: horarios.length,
        itemBuilder: (context, index) {
          final horario = horarios[index];
          final status = _getStatus(horario);
          final cor = _getCorStatus(status);
          final horaFormatada = DateFormat('HH:mm').format(horario);
          final emAndamento = status == 'Em andamento';

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho sempre visível
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
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: cor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                // Expansão suave só durante a chamada
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 400),
                  crossFadeState: emAndamento
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        const Text(
                          'A chamada está aberta! Os alunos podem registrar presença agora.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Ir para Presença'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
