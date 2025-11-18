import 'package:flutter/material.dart';
import '../../core/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text(
          'Bem-vindo ao Controle de Abastecimento',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
