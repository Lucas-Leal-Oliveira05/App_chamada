import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';

class PresencaPage extends StatefulWidget {
  final ChamadaController controller;
  const PresencaPage({super.key, required this.controller});

  @override
  State<PresencaPage> createState() => _PresencaPageState();
}

class _PresencaPageState extends State<PresencaPage> {
  final nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Seu nome'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.controller.registrarPresenca(nomeController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Presença registrada!')),
                );
              },
              child: const Text('Registrar Presença'),
            ),
          ],
        ),
      ),
    );
  }
}
