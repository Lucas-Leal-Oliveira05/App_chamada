import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/controle_chamada.dart';

class HistoricoPage extends StatelessWidget {
  final ChamadaController controller;
  const HistoricoPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.historico.length,
      itemBuilder: (context, i) {
        final c = controller.historico[i];
        return ListTile(
          title: Text(
              'Chamada ${DateFormat('HH:mm').format(c.horaInicio)} - ${DateFormat('HH:mm').format(c.horaFim)}'),
          subtitle: Text('Presenças: ${c.presencas.join(', ')}'),
          trailing: Icon(
            c.aberta ? Icons.circle : Icons.circle_outlined,
            color: c.aberta ? Colors.green : Colors.grey,
          ),
        );
      },
    );
  }
}
