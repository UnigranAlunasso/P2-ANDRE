import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final bool carregando;

  const PrimaryButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: carregando ? null : onPressed,
        child: carregando
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(texto),
      ),
    );
  }
}
