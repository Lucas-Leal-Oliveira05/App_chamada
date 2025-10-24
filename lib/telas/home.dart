import 'package:flutter/material.dart';
import '../controllers/controle_chamada.dart';
import 'painel.dart';
import 'historico.dart';
import 'relatorio.dart';
import 'login.dart'; // importa a tela de login

class HomePage extends StatefulWidget {
  final String usuarioLogado;

  const HomePage({super.key, required this.usuarioLogado});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final controller = ChamadaController();

  void _logout() {
    // Mostra um diálogo de confirmação
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // fecha o diálogo
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // fecha o diálogo
              // Substitui toda a pilha de navegação e volta para o login
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
    final paginas = [
      PainelStatusPage(
        controller: controller,
        usuarioLogado: widget.usuarioLogado,
      ),
      HistoricoPage(controller: controller),
      ExportPage(controller: controller),
    ];

    final titulos = ['Painel', 'Histórico', 'Exportar'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${titulos[_selectedIndex]} - ${widget.usuarioLogado}'),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Painel'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(icon: Icon(Icons.file_download), label: 'Exportar'),
        ],
      ),
    );
  }
}
