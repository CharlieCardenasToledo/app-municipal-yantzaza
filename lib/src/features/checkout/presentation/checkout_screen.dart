import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_typography.dart';

final class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar compra')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text('Datos de entrega', style: AppTypography.headlineMd),
          const SizedBox(height: 18),
          const TextField(decoration: InputDecoration(labelText: 'Nombre completo', prefixIcon: Icon(Icons.person_outline_rounded))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.location_on_outlined))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Referencia (opcional)', prefixIcon: Icon(Icons.signpost_outlined))),
          const SizedBox(height: 28),
          Text('Método de pago', style: AppTypography.headlineSm),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Pago contra entrega'),
              subtitle: const Text('Efectivo o transferencia al recibir'),
              leading: const Icon(Icons.payments_outlined),
              trailing: const Icon(Icons.check_circle_rounded),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () => context.go('/order-confirmed'),
            icon: const Icon(Icons.check_rounded),
            label: const Text('Confirmar pedido · \$12.00'),
          ),
        ],
      ),
    );
  }
}
