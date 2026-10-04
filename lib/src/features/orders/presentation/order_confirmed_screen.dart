import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

final class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedido confirmado')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.secondaryContainer, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 56, color: AppColors.onSecondaryContainer),
              ),
              const SizedBox(height: 24),
              Text('¡Todo listo!', style: AppTypography.displaySm, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text('Tu pedido del Mercado Reina del Cisne fue recibido.', style: AppTypography.bodyLg, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Código de pedido #ZM-2048 · Entrega programada', style: AppTypography.bodyMd, textAlign: TextAlign.center),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => context.go('/dashboard'),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Volver al inicio'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/marketplace'),
                child: const Text('Explorar comercio local'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
