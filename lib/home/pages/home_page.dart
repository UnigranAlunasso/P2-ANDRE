import 'package:flutter/material.dart';
import '../../core/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Início")),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                image: const DecorationImage(
                  image: AssetImage("assets/images/logo-oficina-mecanica.png"),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .10),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text(
              "Bem-vindo ao seu\nControle de Veículos",
              style: tema.textTheme.headlineLarge?.copyWith(
                fontSize: 28,
                letterSpacing: 0.8,
                color: tema.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Gerencie seus veículos, registre abastecimentos\n"
              "e acompanhe seus gastos com praticidade.",
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions_car),
                label: const Text("Meus veículos"),
                onPressed: () {
                  Navigator.pushNamed(context, '/veiculos');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
