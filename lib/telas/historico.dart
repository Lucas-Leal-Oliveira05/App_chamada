import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/controle_chamada.dart';

class HistoricoPage extends StatelessWidget {
  final ChamadaController controller;
  const HistoricoPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final dateFormatter = DateFormat('dd/MM/yyyy');
        final timeFormatter = DateFormat('HH:mm');

        if (controller.historico.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma chamada registrada ainda.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.historico.length,
          itemBuilder: (context, i) {
            final chamada = controller.historico[i];

            final dia = dateFormatter.format(chamada.horaInicio);
            final inicio = timeFormatter.format(chamada.horaInicio);
            final fim = timeFormatter.format(chamada.horaFim);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                title: Text('Chamada do dia $dia',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Horário: $inicio - $fim'),
                leading: Icon(
                  chamada.aberta ? Icons.circle : Icons.check_circle,
                  color: chamada.aberta ? Colors.green : Colors.grey,
                ),
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Presenças registradas:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (chamada.presencas.isEmpty)
                    const Text('Nenhum aluno presente ainda.')
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: chamada.presencas
                          .map(
                            (aluno) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: Colors.indigo, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    aluno,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
