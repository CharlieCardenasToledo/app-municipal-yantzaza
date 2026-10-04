import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../common_widgets/yantzaza_remote_image.dart';

final class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final event = _events[eventId] ?? _events['festival']!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del evento'),
        actions: [
          IconButton(
            tooltip: 'Mis eventos',
            onPressed: () => context.push('/my-events'),
            icon: const Icon(Icons.bookmark_outline_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          YantzazaRemoteImage(
            url: '',
            assetPath: event.imageAsset,
            height: 230,
            width: double.infinity,
            borderRadius: AppBorderRadius.radiusXxl,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: AppBorderRadius.radiusFull,
            ),
            child: Text(event.category, style: AppTypography.labelMd.copyWith(color: AppColors.onSecondaryContainer)),
          ),
          const SizedBox(height: 12),
          Text(event.title, style: AppTypography.headlineMd),
          const SizedBox(height: 18),
          _InfoRow(icon: Icons.calendar_today_rounded, text: event.date),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.location_on_rounded, text: event.location),
          const SizedBox(height: 20),
          Text(event.description, style: AppTypography.bodyLg),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Evento guardado en Mis eventos')),
              );
            },
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Guardar en mis eventos'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => context.push('/my-events'),
            child: const Text('Ver mis eventos'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTypography.bodyMd)),
        ],
      );
}

class _EventData {
  final String title;
  final String category;
  final String date;
  final String location;
  final String description;
  final String imageAsset;
  final IconData icon;

  const _EventData({
    required this.title,
    required this.category,
    required this.date,
    required this.location,
    required this.description,
    required this.imageAsset,
    required this.icon,
  });
}

const _events = <String, _EventData>{
  'festival': _EventData(
    title: 'Fiestas de cantonización · Lúcete en Febrero',
    category: 'Cultura',
    date: 'Semana del 26 de febrero de 2027',
    location: 'Parque Central de Yantzaza',
    description: 'Yantzaza celebra su cantonización del 26 de febrero de 1981. En 2026 la agenda Lúcete en Febrero incluyó serenata, desfile cívico, feria agroproductiva, concurso de danza, rodeo, downhill amazónico, sesión solemne y concierto.',
    imageAsset: 'assets/images/tourism/panoramica-nocturna.jpg',
    icon: Icons.celebration_rounded,
  ),
  'carnaval': _EventData(
    title: 'Carnaval Chicaña Caliente',
    category: 'Cultura',
    date: 'Feriado de Carnaval',
    location: 'Parroquia Chicaña',
    description: 'Rally cross, competencias 4x4, conciertos y espuma en el carnaval más concurrido del cantón.',
    imageAsset: 'assets/images/tourism/chicana.jpg',
    icon: Icons.music_note_rounded,
  ),
  'sisay-pacha': _EventData(
    title: 'Sisay Pacha · Festival de Balcones Floridos',
    category: 'Cultura',
    date: 'Junio (fecha por confirmar)',
    location: 'San Vicente de Caney, Chicaña',
    description: 'El "tiempo del florecimiento": concurso de jardines y balcones floridos en una comunidad intercultural mestiza, shuar y saraguro.',
    imageAsset: 'assets/images/tourism/balcones-floridos-caney.jpg',
    icon: Icons.local_florist_rounded,
  ),
  'planting': _EventData(
    title: 'Minga de limpieza de riberas',
    category: 'Ambiente',
    date: 'Fecha por confirmar',
    location: 'Riberas del río Zamora y quebrada Yantzaza',
    description: 'Jornada comunitaria para retirar residuos de riberas y playas de río. Lleva guantes y separa lo recolectado en tacho verde, negro y azul.',
    imageAsset: 'assets/images/news/minga-riberas.jpg',
    icon: Icons.eco_rounded,
  ),
  'run': _EventData(
    title: 'Atletismo para la niñez yantzacense',
    category: 'Deporte',
    date: 'Inscripciones abiertas',
    location: 'Coliseo y Estadio Municipal',
    description: 'Escuela de atletismo impulsada por el GAD para niñas y niños del cantón, con miras a la 5K de cantonización.',
    imageAsset: 'assets/images/news/atletismo.jpg',
    icon: Icons.directions_run_rounded,
  ),
  'gallery': _EventData(
    title: 'Feria agroproductiva y ganadera',
    category: 'Comercio',
    date: 'Febrero · cantonización',
    location: 'Nuevo Recinto Ferial Ganadero',
    description: 'Café, cacao, pitahaya, plátano, quesillo y ganado de productores del cantón. El nuevo recinto ferial está en construcción.',
    imageAsset: 'assets/images/news/recinto-ferial.jpg',
    icon: Icons.storefront_rounded,
  ),
};