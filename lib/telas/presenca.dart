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
        title: const Text('Presença'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton.icon(
                  label: const Text(
                    'Registrar Presença',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                  ),
                  onPressed: () {
                    final chamada = widget.controller.chamadaAtual;
                    //verifica se tem chamada aberta
                    if (chamada == null || !chamada.aberta) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Nenhuma chamada em andamento no momento.'),
                        ),
                      );
                      return;
                    }

                    //verifica se ja tem presenca
                    if (chamada.presencas.contains(widget.usuarioLogado)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Você já registrou presença nesta chamada.'),
                        ),
                      );
                      return;
                    }

                    //faz o registro
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
