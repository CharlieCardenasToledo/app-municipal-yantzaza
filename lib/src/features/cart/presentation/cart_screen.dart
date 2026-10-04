import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

final class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de compras')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text('Tu pedido', style: AppTypography.headlineMd),
          const SizedBox(height: 8),
          Text('Mercado Reina del Cisne · comercio local', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.secondaryContainer,
                child: const Icon(Icons.bakery_dining_rounded, color: AppColors.onSecondaryContainer),
              ),
              title: Text('Canasta de productos locales', style: AppTypography.titleMd),
              subtitle: const Text('1 unidad · entrega a domicilio'),
              trailing: Text('\$12.00', style: AppTypography.titleMd.copyWith(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 24),
          _SummaryRow(label: 'Subtotal', value: '\$12.00'),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Entrega', value: 'Gratis'),
          const Divider(height: 28),
          _SummaryRow(label: 'Total', value: '\$12.00', emphasized: true),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () => context.push('/checkout'),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Continuar al pago'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/marketplace'),
            child: const Text('Seguir comprando'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;

  const _SummaryRow({required this.label, required this.value, this.emphasized = false});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: emphasized ? AppTypography.titleMd : AppTypography.bodyMd),
          Text(value, style: (emphasized ? AppTypography.headlineSm : AppTypography.titleSm).copyWith(color: AppColors.primary)),
        ],
      );
}
