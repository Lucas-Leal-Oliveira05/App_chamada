import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';

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
            Text(
              'Usuário logado: ${widget.usuarioLogado}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Registrar Presença'),
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
                final chamada = widget.controller.chamadaAtual;

                // ✅ Verifica se há chamada aberta
                if (chamada == null || !chamada.aberta) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nenhuma chamada em andamento no momento.'),
                    ),
                  );
                  return;
                }

                // ✅ Verifica se o aluno já registrou presença
                if (chamada.presencas.contains(widget.usuarioLogado)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Você já registrou presença nesta chamada.'),
                    ),
                  );
                  return;
                }

                // ✅ Registra presença do usuário logado
                widget.controller.registrarPresenca(widget.usuarioLogado);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Presença registrada para ${widget.usuarioLogado}!',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
