import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';

class ExportPage extends StatelessWidget {
  final ChamadaController controller;
  const ExportPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.download),
        label: const Text('Exportar CSV'),
        onPressed: () async {
          final path = await controller.exportarCSV();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Arquivo em: $path')));
        },
      ),
    );
  }
}
