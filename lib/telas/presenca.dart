import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';

class PresencaPage extends StatefulWidget {
  final ChamadaController controller;
  final String usuarioLogado;

  const PresencaPage({super.key, required this.controller,
                      required this.usuarioLogado,});

  @override
  State<PresencaPage> createState() => _PresencaPageState();
}

class _PresencaPageState extends State<PresencaPage> {
  final nomeController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Presença'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Seu nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              onPressed: () {
                final nome = nomeController.text.trim();

                if (nome.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite seu nome antes de registrar.')),
                  );
                  return;
                }

                widget.controller.registrarPresenca(nome);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Presença registrada para $nome!')),
                );

                nomeController.clear();
              },
              label: const Text('Registrar Presença'),
            ),
          ],
        ),
      ),
    );
  }
}
