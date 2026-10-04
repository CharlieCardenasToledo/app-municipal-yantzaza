import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../common_widgets/glass_chip.dart';
import '../../../common_widgets/tonal_card.dart';
import '../../../common_widgets/yantzaza_remote_image.dart';
import '../../../common_widgets/amazonian_backdrop.dart';
import '../../../common_widgets/clay_icon.dart';

final class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const SizedBox(height: 32),
              _buildWelcomeSection(context),
              const SizedBox(height: 20),
              _buildTourismHero(context),
              const SizedBox(height: 20),
              _buildEmergencyAlert(context),
              const SizedBox(height: 28),
              _buildQuickAccessGrid(context),
              const SizedBox(height: 20),
              _buildMunicipalServicesCard(context),
              const SizedBox(height: 32),
              _buildNewsSection(context),
              const SizedBox(height: 32),
              _buildWeatherCard(context),
              const SizedBox(height: 18),
              _buildAboutLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTourismHero(BuildContext context) {
    return TonalCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push('/tourism'),
      color: AppColors.primaryFixed.withValues(alpha: 0.78),
      child: ClipRRect(
        borderRadius: AppBorderRadius.radiusXl,
        child: Stack(
          children: [
            Positioned(
              right: -6,
              bottom: -12,
              child: Opacity(opacity: 0.95, child: Image.asset(ClayAssets.toucan, width: 112, height: 112, fit: BoxFit.contain)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 104, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descubre Yantzaza', style: AppTypography.titleLg.copyWith(color: AppColors.onPrimaryFixed)),
                  const SizedBox(height: 4),
                  Text('Balnearios, cascadas de Chicaña y cultura shuar para vivir el cantón.', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 12),
                  Row(children: [Flexible(child: Text('Explorar turismo', overflow: TextOverflow.ellipsis, style: AppTypography.labelLg.copyWith(color: AppColors.primary))), const SizedBox(width: 6), const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.primary)]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMunicipalServicesCard(BuildContext context) {
    return TonalCard(
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryFixed.withValues(alpha: 0.34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Servicios municipales', style: AppTypography.titleMd),
          const SizedBox(height: 4),
          Text(
            'Gestiona tus obligaciones y tu estacionamiento desde un mismo lugar.',
            style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 520;
              final actions = [
                _serviceAction(
                  context,
                  icon: Icons.account_balance_wallet_rounded,
                  asset: 'assets/images/amazonia-pagos-clay.png',
                  title: 'Pagos municipales',
                  subtitle: 'Obligaciones y comprobantes',
                  color: AppColors.primary,
                  onTap: () => context.push('/payments'),
                ),
                _serviceAction(
                  context,
                  icon: Icons.local_parking_rounded,
                  asset: 'assets/images/amazonia-estacionamiento-clay.png',
                  title: 'Estacionamiento',
                  subtitle: 'Activa y consulta tu tiempo',
                  color: AppColors.secondary,
                  onTap: () => context.push('/parking'),
                ),
              ];
              return compact
                  ? Column(children: [actions[0], const SizedBox(height: 10), actions[1]])
                  : Row(children: [Expanded(child: actions[0]), const SizedBox(width: 10), Expanded(child: actions[1])]);
            },
          ),
        ],
      ),
    );
  }

  Widget _serviceAction(
    BuildContext context, {
    required IconData icon,
    String? asset,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.72),
      borderRadius: AppBorderRadius.radiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorderRadius.radiusLg,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: color, borderRadius: AppBorderRadius.radiusMd),
                child: asset == null
                    ? Icon(icon, color: color == AppColors.primary ? AppColors.onPrimary : AppColors.onSecondary, size: 21)
                    : Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(asset, fit: BoxFit.contain),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.labelLg),
                    const SizedBox(height: 3),
                    Text(subtitle, style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: color, size: 19),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Top App Bar ──────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push('/about'),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppBorderRadius.radiusFull,
              border: Border.all(color: AppColors.primaryFixedDim, width: 2),
            ),
            child: const ClayIcon(asset: ClayAssets.avatar, size: 32),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mi Yantzaza', overflow: TextOverflow.ellipsis, style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
              Text('Valle de las Luciérnagas', overflow: TextOverflow.ellipsis, style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.push('/schedules'),
          icon: const ClayIcon(asset: ClayAssets.alerts, size: 26),
          color: AppColors.primary,
        ),
      ],
    );
  }

  // ─── Welcome Section ──────────────────────────────────────
  Widget _buildWelcomeSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showBird = constraints.maxWidth > 420;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VALLE DE LAS LUCIÉRNAGAS', style: AppTypography.labelSm.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text('Hola, vecina/o', style: AppTypography.displayMd),
                  const SizedBox(height: 4),
                  Text('Servicios, naturaleza y comunidad en un mismo lugar.', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            if (showBird) ...[
              const SizedBox(width: 8),
              const AmazonianBird(
                asset: 'assets/images/amazonia-tucan-clay.png',
                width: 142,
              ),
            ],
          ],
        );
      },
    );
  }

  // ─── Emergency Alert ──────────────────────────────────────
  Widget _buildEmergencyAlert(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.4),
        borderRadius: AppBorderRadius.radiusXl,
        border: const Border(
          left: BorderSide(color: AppColors.error, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: AppBorderRadius.radiusFull,
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: AppColors.onError,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aviso municipal',
                  style: AppTypography.titleSm.copyWith(
                    color: AppColors.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Revisa qué tacho sacar hoy y las alertas del GAD Municipal de Yantzaza.',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onErrorContainer.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick Access Bento Grid ─────────────────────────────
  Widget _buildQuickAccessGrid(BuildContext context) {
    final items = [
      ('Reportar\nIncidente', Icons.campaign_rounded, AppColors.primary, '/incidents', ClayAssets.report),
      ('Marketplace', Icons.storefront_rounded, AppColors.secondary, '/marketplace', ClayAssets.commerce),
      ('Rutas de\nresiduos', Icons.delete_rounded, AppColors.tertiary, '/maps', ClayAssets.routes),
      ('Eventos', Icons.calendar_today_rounded, AppColors.primaryContainer, '/events', ClayAssets.events),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final (label, icon, color, path, asset) = items[index];
        return _QuickAccessTile(
          label: label,
          icon: icon,
          color: color,
          asset: asset,
          onTap: () => context.go(path),
        );
      },
    );
  }

  // ─── News Section ──────────────────────────────────────────
  Widget _buildNewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Novedades de Yantzaza',
                style: AppTypography.headlineSm,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/events'),
              child: Text(
                'Ver todas',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.tertiary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _NewsCard(
          title: 'Más cámaras, más seguridad',
          description:
              'Ocho nuevas cámaras en el barrio Norte, Vista Hermosa, el muelle del río Zamora, el malecón y el Mirador El Panecillo se suman a una red de cerca de 90 dispositivos.',
          chipLabel: 'Seguridad',
          chipColor: AppColors.tertiaryContainer,
          chipTextColor: AppColors.onTertiaryContainer,
          timeAgo: '2026 · Boletín GAD Yantzaza',
          assetPath: 'assets/images/news/camaras-seguridad.jpg',
          source: 'GAD Municipal de Yantzaza',
        ),
        const SizedBox(height: 16),
        _NewsCard(
          title: 'Avanza el Recinto Ferial Ganadero',
          description:
              'La obra supera la mitad de su ejecución y fortalecerá la comercialización ganadera del cantón.',
          chipLabel: 'Obras',
          chipColor: AppColors.secondaryContainer,
          chipTextColor: AppColors.onSecondaryContainer,
          timeAgo: '2026 · Boletín GAD Yantzaza',
          assetPath: 'assets/images/news/recinto-ferial.jpg',
          source: 'GAD Municipal de Yantzaza',
        ),
        const SizedBox(height: 16),
        _NewsCard(
          title: 'Asfaltado de la Av. Yaguarzongo',
          description:
              'El Municipio socializó el proyecto con las familias del barrio El Recreo, incluido el ajuste de retiros de 5 a 2 metros.',
          chipLabel: 'Vialidad',
          chipColor: AppColors.primaryContainer,
          chipTextColor: AppColors.onPrimaryContainer,
          timeAgo: '2026 · Boletín GAD Yantzaza',
          assetPath: 'assets/images/news/av-yaguarzongo.jpg',
          source: 'GAD Municipal de Yantzaza',
        ),
      ],
    );
  }

  // ─── Weather Card ──────────────────────────────────────────
  Widget _buildWeatherCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.radiusXl,
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YANTZAZA · 887 M S. N. M.',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cálido y lluvioso',
                  style: AppTypography.displaySm.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Entre 14 °C y 24 °C. Con lluvias fuertes, evita las riberas del río Zamora.',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const ClayIcon(asset: ClayAssets.rain, size: 72),
              const SizedBox(height: 8),
              Material(
                color: Colors.transparent,
                borderRadius: AppBorderRadius.radiusFull,
                child: InkWell(
                  onTap: () => _showWeatherServices(context),
                  borderRadius: AppBorderRadius.radiusFull,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.radiusFull,
                      border: Border.all(
                        color: AppColors.onPrimary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Ver servicios',
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutLink(BuildContext context) {
    return TonalCard(
      onTap: () => context.push('/about'),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.78),
      child: Row(
        children: [
          const ClayIcon(asset: ClayAssets.avatar, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Acerca de Mi Yantzaza', style: AppTypography.labelLg),
                const SizedBox(height: 3),
                Text('Conoce a Nekatek Lab', style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
        ],
      ),
    );
  }

  void _showWeatherServices(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: AppBorderRadius.radiusFull,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const ClayIcon(asset: ClayAssets.rain, size: 56),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Servicios para un día de lluvia', style: AppTypography.titleLg),
                          const SizedBox(height: 4),
                          Text(
                            'Planifica tus recorridos y gestiones en Yantzaza con más tranquilidad.',
                            style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _WeatherServiceTile(
                  asset: ClayAssets.routes,
                  title: 'Revisa tus rutas',
                  subtitle: 'Consulta el recorrido y la llegada del recolector.',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/maps');
                  },
                ),
                const SizedBox(height: 10),
                _WeatherServiceTile(
                  asset: ClayAssets.alerts,
                  title: 'Horarios y alertas',
                  subtitle: 'Mira los avisos municipales antes de salir.',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/schedules');
                  },
                ),
                const SizedBox(height: 10),
                _WeatherServiceTile(
                  asset: ClayAssets.report,
                  title: 'Reporta una incidencia',
                  subtitle: 'Comunica novedades en vías, alumbrado o residuos.',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/incidents');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WeatherServiceTile extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _WeatherServiceTile({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: AppBorderRadius.radiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorderRadius.radiusLg,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClayIcon(asset: asset, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.labelLg),
                    const SizedBox(height: 3),
                    Text(subtitle, style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Quick Access Tile ──────────────────────────────────────
class _QuickAccessTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String? asset;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.label,
    required this.icon,
    required this.color,
    this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TonalCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: AppBorderRadius.radiusFull,
            ),
            child: asset == null
                ? Icon(icon, color: color, size: 28)
                : Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(asset!, fit: BoxFit.contain),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.titleSm.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── News Card ──────────────────────────────────────────────
class _NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String chipLabel;
  final Color chipColor;
  final Color chipTextColor;
  final String timeAgo;
  final String assetPath;
  final String source;

  const _NewsCard({
    required this.title,
    required this.description,
    required this.chipLabel,
    required this.chipColor,
    required this.chipTextColor,
    required this.timeAgo,
    required this.assetPath,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return TonalCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YantzazaRemoteImage(
            url: '',
            assetPath: assetPath,
            height: 156,
            width: double.infinity,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassChip(
                  label: chipLabel,
                  backgroundColor: chipColor,
                  textColor: chipTextColor,
                ),
                const SizedBox(height: 12),
                Text(title, style: AppTypography.titleLg),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, size: 14, color: AppColors.outline),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(timeAgo, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Fuente: $source', style: AppTypography.labelSm.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
