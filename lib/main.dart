import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/chamada.dart';
import 'telas/login.dart'; // importa a tela de login

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChamadaAdapter());
  await Hive.openBox<Chamada>('chamadas');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Chamada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const LoginPage(), // ✅ App começa na tela de login
    );
  }
}
