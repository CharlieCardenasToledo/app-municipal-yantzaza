import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Frecuencias de recolección diferenciada del GAD Municipal de Yantzaza
/// (PDOT 2024-2027, Ordenanza de gestión integral de residuos sólidos).
class _BinDay {
  final String bin;
  final String waste;
  final String days;
  final Set<int> weekdays;
  final Color color;

  const _BinDay({required this.bin, required this.waste, required this.days, required this.weekdays, required this.color});
}

const _binDays = [
  _BinDay(bin: 'Tacho verde', waste: 'Orgánicos: restos de comida, cáscaras y hojas', days: 'Lunes, miércoles y viernes', weekdays: {DateTime.monday, DateTime.wednesday, DateTime.friday}, color: Color(0xFF0C8E36)),
  _BinDay(bin: 'Tacho negro', waste: 'Inorgánicos no aprovechables: papel higiénico, pañales, envolturas sucias', days: 'Martes y domingo', weekdays: {DateTime.tuesday, DateTime.sunday}, color: Color(0xFF2A332D)),
  _BinDay(bin: 'Tacho azul', waste: 'Reciclables: plástico, papel, cartón, vidrio y metal limpios', days: 'Jueves', weekdays: {DateTime.thursday}, color: Color(0xFF1F5FAF)),
];

final class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().weekday;
    final todayBin = _binDays.where((bin) => bin.weekdays.contains(today)).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horarios y alertas'),
        actions: [
          IconButton(
            tooltip: 'Configurar alertas',
            onPressed: () => context.push('/alert-settings'),
            icon: const Icon(Icons.notifications_active_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text('Servicios de Yantzaza', style: AppTypography.headlineMd),
          const SizedBox(height: 8),
          Text('Separa en la fuente y saca el tacho que corresponde a cada día.', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 20),
          _TodayCard(bin: todayBin),
          const SizedBox(height: 20),
          Text('Calendario de recolección', style: AppTypography.headlineSm),
          const SizedBox(height: 12),
          for (final bin in _binDays) ...[
            _ScheduleCard(
              icon: Icons.delete_outline_rounded,
              color: bin.color,
              title: '${bin.bin} · ${bin.days}',
              next: bin.waste,
              detail: bin.weekdays.contains(today) ? 'Hoy pasa el recolector' : 'Saca el tacho la noche anterior',
            ),
            const SizedBox(height: 12),
          ],
          const _ScheduleCard(
            icon: Icons.medical_services_outlined,
            color: AppColors.tertiary,
            title: 'Desechos infecciosos',
            next: 'Martes en la zona urbana · viernes en la zona rural',
            detail: 'Entrégalos en funda roja y debidamente cerrados.',
          ),
          const SizedBox(height: 12),
          const _ScheduleCard(
            icon: Icons.water_drop_outlined,
            color: AppColors.primaryContainer,
            title: 'Agua potable y alcantarillado',
            next: 'Plantas La Delicia, Yantzaza y San Francisco',
            detail: 'Cortes y mantenimientos: 07 2300 158 ext. 31',
          ),
          const SizedBox(height: 24),
          Text('Atención municipal', style: AppTypography.headlineSm),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryFixed,
                child: Icon(Icons.account_balance_rounded, color: AppColors.primary),
              ),
              title: Text('GAD Municipal de Yantzaza'),
              subtitle: Text('Av. Iván Riofrío y Armando Arias\nLunes a viernes · 08:00–12:00 · 13:00–17:00\n07 2300 158 · alcaldia@yantzaza.gob.ec'),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: AppColors.errorContainer,
                child: Icon(Icons.flood_outlined, color: AppColors.error),
              ),
              title: Text('Lluvias y crecidas del río Zamora'),
              subtitle: Text('Emergencias: ECU 911. Albergue habitual: Coliseo de Yantzaza. Evita playas y riberas cuando el río esté crecido.'),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/maps'),
            icon: const Icon(Icons.map_outlined),
            label: const Text('Ver rutas en el mapa'),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final _BinDay? bin;

  const _TodayCard({required this.bin});

  @override
  Widget build(BuildContext context) {
    final color = bin?.color ?? AppColors.outline;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppBorderRadius.radiusXl,
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: color, borderRadius: AppBorderRadius.radiusFull),
            child: const Icon(Icons.delete_rounded, color: AppColors.onPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HOY TOCA', style: AppTypography.overline.copyWith(color: color)),
                const SizedBox(height: 4),
                Text(bin?.bin ?? 'Sin recolección', style: AppTypography.titleLg),
                const SizedBox(height: 2),
                Text(
                  bin?.waste ?? 'El calendario municipal no contempla recolección los sábados. Guarda tus residuos separados.',
                  style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String next;
  final String detail;

  const _ScheduleCard({required this.icon, required this.color, required this.title, required this.next, required this.detail});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, color: color)),
          title: Text(title, style: AppTypography.titleMd),
          subtitle: Text('$next\n$detail'),
          isThreeLine: true,
        ),
      );
}
