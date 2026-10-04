import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

final class ProximityAlertScreen extends StatefulWidget {
  const ProximityAlertScreen({super.key});

  @override
  State<ProximityAlertScreen> createState() => _ProximityAlertScreenState();
}

class _ProximityAlertScreenState extends State<ProximityAlertScreen> {
  bool routeAlerts = true;
  bool serviceAlerts = true;
  bool communityAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar alertas')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text('Recibe avisos a tiempo', style: AppTypography.headlineMd),
          const SizedBox(height: 8),
          Text('Ajusta qué sucede cerca de ti.', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: routeAlerts,
                  onChanged: (value) => setState(() => routeAlerts = value),
                  title: const Text('Rutas próximas'),
                  subtitle: const Text('Cuando el camión esté cerca de tu calle'),
                  secondary: const Icon(Icons.directions_bus_outlined),
                ),
                const Divider(indent: 72, endIndent: 16),
                SwitchListTile(
                  value: serviceAlerts,
                  onChanged: (value) => setState(() => serviceAlerts = value),
                  title: const Text('Servicios municipales'),
                  subtitle: const Text('Mantenimientos e interrupciones'),
                  secondary: const Icon(Icons.info_outline_rounded),
                ),
                const Divider(indent: 72, endIndent: 16),
                SwitchListTile(
                  value: communityAlerts,
                  onChanged: (value) => setState(() => communityAlerts = value),
                  title: const Text('Actividades de comunidad'),
                  subtitle: const Text('Eventos y actividades del barrio'),
                  secondary: const Icon(Icons.groups_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preferencias actualizadas')));
            },
            child: const Text('Guardar preferencias'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/dashboard'),
            child: const Text('Volver al inicio'),
          ),
        ],
      ),
    );
  }
}
