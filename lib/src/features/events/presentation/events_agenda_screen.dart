import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../common_widgets/search_bar_widget.dart';
import '../../../common_widgets/yantzaza_remote_image.dart';
import '../../../common_widgets/clay_icon.dart';

final class EventsAgendaScreen extends ConsumerWidget {
  const EventsAgendaScreen({super.key});

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
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: AppTypography.displayMd,
                  children: [
                    const TextSpan(text: 'Yantzaza '),
                    TextSpan(
                      text: 'Vive',
                      style: TextStyle(color: AppColors.primaryContainer),
                    ),
                    const TextSpan(text: ' & participa'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SearchBarWidget(hintText: 'Buscar eventos, talleres o festivales...'),
              const SizedBox(height: 20),
              _buildFilters(context),
              const SizedBox(height: 28),
              _buildFeaturedEvent(context),
              const SizedBox(height: 28),
              _buildEventGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.push('/my-events'),
          icon: const Icon(Icons.menu_rounded),
          color: AppColors.onSurface,
        ),
        const SizedBox(width: 8),
         Text('Agenda de Yantzaza', style: AppTypography.titleLg),
        const Spacer(),
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            borderRadius: AppBorderRadius.radiusFull,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: ClipRRect(
            borderRadius: AppBorderRadius.radiusFull,
            child: Container(
              color: AppColors.surfaceContainerHigh,
              child: const ClayIcon(asset: ClayAssets.eventoPersona, size: 34),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final filters = ['Todos', 'Cultura', 'Deporte', 'Ambiente', 'Comercio'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final selected = f == 'Todos';
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
                borderRadius: AppBorderRadius.radiusFull,
              ),
              child: Text(
                f,
                style: AppTypography.labelMd.copyWith(
                  color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedEvent(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.radiusXxl,
        color: AppColors.inverseSurface,
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          const YantzazaRemoteImage(
            url: '',
            assetPath: 'assets/images/tourism/panoramica-nocturna.jpg',
            width: double.infinity,
            height: 400,
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(28)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryContainer.withValues(alpha: 0.8),
                    borderRadius: AppBorderRadius.radiusFull,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.onTertiaryContainer),
                      const SizedBox(width: 4),
                       Text('46 AÑOS DE CANTONIZACIÓN', style: AppTypography.overline.copyWith(color: AppColors.onTertiaryContainer)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                   'Lúcete en\nFebrero',
                  style: AppTypography.displaySm.copyWith(color: AppColors.surfaceContainerLowest),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primaryFixed),
                    const SizedBox(width: 6),
                     Text('Semana del 26 feb', style: AppTypography.bodySm.copyWith(color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9))),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primaryFixed),
                    const SizedBox(width: 6),
                     Text('Parque Central', style: AppTypography.bodySm.copyWith(color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9))),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push('/events/festival'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusFull),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text('Ver detalle'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventGrid(BuildContext context) {
    const events = [
      ('Carnaval Chicaña Caliente', 'Cultura', 'FEB', 'Carnaval', 'Parroquia Chicaña', 'assets/images/tourism/chicana.jpg', 'carnaval'),
      ('Sisay Pacha · Balcones Floridos', 'Cultura', 'JUN', 'Por confirmar', 'San Vicente de Caney', 'assets/images/tourism/balcones-floridos-caney.jpg', 'sisay-pacha'),
      ('Minga de limpieza de riberas', 'Ambiente', '—', 'Por confirmar', 'Río Zamora', 'assets/images/news/minga-riberas.jpg', 'planting'),
      ('Atletismo para la niñez', 'Deporte', 'HOY', 'Inscripciones', 'Coliseo y Estadio Municipal', 'assets/images/news/atletismo.jpg', 'run'),
      ('Feria agroproductiva y ganadera', 'Comercio', 'FEB', 'Cantonización', 'Recinto Ferial Ganadero', 'assets/images/news/recinto-ferial.jpg', 'gallery'),
    ];
    return Column(
      children: [
        for (final (title, category, date, month, place, asset, id) in events) ...[
          _EventCard(
            title: title,
            category: category,
            date: date,
            month: month,
            place: place,
            imageAsset: asset,
            onTap: () => context.push('/events/$id'),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
class _EventCard extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final String month;
  final String place;
  final String imageAsset;
  final VoidCallback onTap;

  const _EventCard({
    required this.title,
    required this.category,
    required this.date,
    required this.month,
    required this.place,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppBorderRadius.radiusXl,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.04),
            blurRadius: 32,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppBorderRadius.radiusXl,
        child: InkWell(
          borderRadius: AppBorderRadius.radiusXl,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Stack(
                  children: [
                    YantzazaRemoteImage(
                      url: '',
                      assetPath: imageAsset,
                      width: double.infinity,
                      height: 180,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    Positioned(
                      top: 12, right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                          borderRadius: AppBorderRadius.radiusLg,
                        ),
                        child: Column(
                          children: [
                          Text(date, style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
                            if (month.isNotEmpty)
                              Text(month.toUpperCase(), style: AppTypography.overline.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: AppBorderRadius.radiusSm,
                          ),
                          child: Text(category.toUpperCase(), style: AppTypography.overline.copyWith(color: AppColors.onSecondaryContainer)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(title, style: AppTypography.titleMd),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.place_rounded, size: 14, color: AppColors.outline),
                        const SizedBox(width: 4),
                        Expanded(child: Text(place, overflow: TextOverflow.ellipsis, style: AppTypography.bodySm.copyWith(color: AppColors.outline))),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.outlineVariant),
                            borderRadius: AppBorderRadius.radiusFull,
                          ),
                          child: Text('Me interesa', style: AppTypography.labelSm.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
