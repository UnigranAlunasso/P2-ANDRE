import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

import 'modules/auth/presentation/pages/login_page.dart';
import 'modules/auth/presentation/pages/cadastro_page.dart';

import 'home/pages/home_page.dart';

import 'modules/veiculos/presentation/pages/listar_veiculos_page.dart';
import 'modules/veiculos/presentation/pages/editar_veiculo_page.dart';

import 'modules/abastecimento/presentation/pages/registrar_abastecimento_page.dart';
import 'modules/abastecimento/presentation/pages/listar_abastecimentos_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Controle de Abastecimento',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.cadastro: (_) => const CadastroPage(),
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.veiculos: (_) => const ListarVeiculosPage(),
          AppRoutes.novoVeiculo: (_) => const EditarVeiculoPage(),
          AppRoutes.registrarAbastecimento: (_) =>
              const RegistrarAbastecimentoPage(),
          AppRoutes.historicoAbastecimentos: (_) =>
              const ListarAbastecimentosPage(),
        },
      ),
    );
  }
}
