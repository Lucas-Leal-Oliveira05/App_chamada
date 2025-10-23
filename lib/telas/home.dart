import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';
import 'painel.dart';
import 'historico.dart';
import 'relatorio.dart';

class HomePage extends StatefulWidget {
  final String usuarioLogado;

  const HomePage({super.key, required this.usuarioLogado});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final controller = ChamadaController();

  @override
  Widget build(BuildContext context) {
    final paginas = [
      PainelStatusPage(
        controller: controller,
        usuarioLogado: widget.usuarioLogado,
      ),
      HistoricoPage(controller: controller),
      ExportPage(controller: controller),
    ];

    return Scaffold(
      body: paginas[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Painel'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(icon: Icon(Icons.file_download), label: 'Exportar'),
        ],
      ),
    );
  }
}
