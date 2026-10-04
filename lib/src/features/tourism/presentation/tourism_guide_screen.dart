import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common_widgets/clay_icon.dart';
import '../../../common_widgets/tonal_card.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

final class TourismGuideScreen extends StatelessWidget {
  const TourismGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guía rápida'),
        leading: IconButton(
          tooltip: 'Volver a turismo',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: AppBorderRadius.radiusXxl),
            child: Row(
              children: [
                const ClayIcon(asset: ClayAssets.toucan, size: 70),
                const SizedBox(width: 14),
                Expanded(child: Text('Mi Yantzaza conecta a la ciudadanía con los lugares, actividades y servicios que hacen especial al Valle de las Luciérnagas.', style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimaryFixed))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Así se usa', style: AppTypography.headlineMd),
          const SizedBox(height: 12),
          const _GuideStep(number: '1', title: 'Explora', description: 'Entra en Turismo en Yantzaza y conoce balnearios, cascadas, cultura shuar y gastronomía.'),
          const _GuideStep(number: '2', title: 'Planifica', description: 'Abre el mapa para ubicar el destino y consulta las actividades sugeridas para cada lugar.'),
          const _GuideStep(number: '3', title: 'Participa', description: 'Comparte un reporte, revisa alertas y ayuda a mantener los espacios turísticos cuidados.'),
          const SizedBox(height: 20),
          TonalCard(
            color: AppColors.secondaryContainer.withValues(alpha: 0.72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Una visita responsable', style: AppTypography.titleMd),
                const SizedBox(height: 8),
                Text('Respeta senderos y señalización, no dejes residuos en ríos y balnearios, y evita bañarte cuando el río Zamora esté crecido.', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.go('/tourism'),
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Volver a explorar Yantzaza'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _GuideStep({required this.number, required this.title, required this.description});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: Text(number, style: AppTypography.titleSm.copyWith(color: AppColors.onPrimary)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTypography.titleMd), const SizedBox(height: 3), Text(description, style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant))])),
          ],
        ),
      );
}
