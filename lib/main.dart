import 'package:flutter/material.dart';
import 'controllers/controle_chamada.dart';
import 'telas/painel.dart';
import 'telas/presenca.dart';
import 'telas/historico.dart';
import 'telas/relatorio.dart';
import 'telas/login.dart';

void main() {
  runApp(const ChamadaApp());
}

class ChamadaApp extends StatelessWidget {
  const ChamadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Chamada',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const LoginPage(), // 🔹 inicia na tela de login
    );
  }
}

// 🔹 Essa é a "home" real do app, que antes ficava no main
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ChamadaController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      PainelStatusPage(controller: controller),
      PresencaPage(controller: controller),
      HistoricoPage(controller: controller),
      ExportPage(controller: controller),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('App de Chamada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 🔹 Sai do app e volta para o login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            tooltip: 'Sair',
          )
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Painel'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check), label: 'Presença'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(
              icon: Icon(Icons.download), label: 'Exportar'),
        ],
      ),
    );
  }
}
