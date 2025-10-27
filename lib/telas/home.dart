import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';
import 'painel.dart';
import 'historico.dart';
import 'relatorio.dart';
import 'login.dart'; // importa a tela de login

class HomePage extends StatefulWidget {
  final String usuarioLogado;
  final String tipo; // 'aluno' ou 'professor'

  const HomePage({
    super.key,
    required this.usuarioLogado,
    required this.tipo,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final controller = ChamadaController();

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Verifica se é professor
    final bool isProfessor = widget.tipo == 'professor';

    // 🔹 Define páginas conforme o tipo
    final paginas = isProfessor
        ? [
            HistoricoPage(controller: controller),
            ExportPage(controller: controller),
          ]
        : [
            PainelStatusPage(
              controller: controller,
              usuarioLogado: widget.usuarioLogado,
              professor: false, // aluno
            ),
            HistoricoPage(controller: controller),
            ExportPage(controller: controller),
          ];

    // 🔹 Define títulos e itens do menu
    final titulos = isProfessor
        ? ['Histórico', 'Exportar']
        : ['Painel', 'Histórico', 'Exportar'];

    final itens = isProfessor
        ? const [
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Histórico'),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_download), label: 'Exportar'),
          ]
        : const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Painel'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Histórico'),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_download), label: 'Exportar'),
          ];

    // 🔹 Garante que o índice não ultrapasse o número de páginas
    if (_selectedIndex >= paginas.length) _selectedIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair da conta',
            onPressed: _logout,
          ),
        ],
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: paginas[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: itens,
      ),
    );
  }
}
