import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/logo-oficina-mecanica.png',
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black.withValues(alpha: 0.40)),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Oficina Mecânica",
                      style: tema.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(
              Icons.directions_car,
              color: tema.colorScheme.primary,
            ),
            title: const Text("Meus veículos"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.veiculos),
          ),
          ListTile(
            leading: Icon(
              Icons.local_gas_station,
              color: tema.colorScheme.primary,
            ),
            title: const Text("Registrar abastecimento"),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.registrarAbastecimento),
          ),
          ListTile(
            leading: Icon(Icons.history, color: tema.colorScheme.primary),
            title: const Text("Histórico de abastecimentos"),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.historicoAbastecimentos),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sair"),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
