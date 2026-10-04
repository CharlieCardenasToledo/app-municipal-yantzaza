import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common_widgets/clay_icon.dart';
import '../../../common_widgets/tonal_card.dart';
import '../../../common_widgets/yantzaza_remote_image.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

final class TourismScreen extends StatefulWidget {
  const TourismScreen({super.key});

  @override
  State<TourismScreen> createState() => _TourismScreenState();
}

final class _TourismScreenState extends State<TourismScreen> {
  static const _allCategory = 'Todos';
  String _selectedCategory = _allCategory;

  static const _places = <_TourismPlace>[
    _TourismPlace(title: 'Mirador El Panecillo', category: 'Miradores y paisaje', description: 'Un mirador urbano con vista al valle del río Zamora y a las montañas que rodean la ciudad.', activity: 'Paisaje · fotografía · paseo urbano', assetPath: 'assets/images/tourism/mirador-panecillo.jpg', asset: ClayAssets.ubicacion),
    _TourismPlace(title: 'Yantzaza de noche', category: 'Miradores y paisaje', description: 'La ciudad iluminada entre montañas: la postal que explica el nombre del Valle de las Luciérnagas.', activity: 'Fotografía nocturna · mirador · paseo', assetPath: 'assets/images/tourism/panoramica-nocturna.jpg', asset: ClayAssets.destino),
    _TourismPlace(title: 'Parroquia Chicaña', category: 'Cascadas y naturaleza', description: 'Puerta al circuito Los Guayacanes, su cueva y las cascadas de El Salado, a unos 15 km del centro.', activity: 'Senderismo · cascadas · espeleología', assetPath: 'assets/images/tourism/chicana.jpg', asset: ClayAssets.toucan),
    _TourismPlace(title: 'Balneario Tres Quebradas', category: 'Agua y descanso', description: 'Pozas naturales de agua clara en Chicaña, sector San Vicente; uno de los productos turísticos del cantón.', activity: 'Baño recreativo · naturaleza · familia', assetPath: 'assets/images/tourism/tres-quebradas.jpg', asset: ClayAssets.rain),
    _TourismPlace(title: 'Balneario La Unión', category: 'Agua y descanso', description: 'Río, pozas naturales, ecuavóley y comida típica en la comunidad La Unión, parroquia Chicaña.', activity: 'Tubing · baño recreativo · gastronomía', assetPath: 'assets/images/tourism/la-union.jpg', asset: ClayAssets.rain),
    _TourismPlace(title: 'Kury Muyu', category: 'Agua y descanso', description: 'Piscinas naturales de agua cristalina en el barrio San Sebastián, rodeadas de vegetación.', activity: 'Baño recreativo · descanso · fotografía', assetPath: 'assets/images/tourism/kury-muyu.jpg', asset: ClayAssets.hummingbird),
    _TourismPlace(title: 'Balneario El Alzate', category: 'Agua y descanso', description: 'Una poza de río para refrescarse y pasar la tarde en contacto con el agua y el bosque.', activity: 'Baño recreativo · naturaleza', assetPath: 'assets/images/tourism/el-alzate.jpg', asset: ClayAssets.rain),
    _TourismPlace(title: 'Balneario El Encanto', category: 'Agua y descanso', description: 'Playa de río con piedras y corrientes suaves, ideal para compartir en familia durante el feriado.', activity: 'Playa de río · familia · picnic', assetPath: 'assets/images/tourism/el-encanto.jpg', asset: ClayAssets.rain),
    _TourismPlace(title: 'San Vicente de Caney', category: 'Cultura viva', description: 'Comunidad intercultural mestiza, shuar y saraguro, conocida por el festival Sisay Pacha de jardines y balcones floridos.', activity: 'Cultura · flores · turismo comunitario', assetPath: 'assets/images/tourism/balcones-floridos-caney.jpg', asset: ClayAssets.feria),
    _TourismPlace(title: 'Centro Cultural Nankais', category: 'Cultura viva', description: 'Centro de interpretación de la comunidad shuar de Nankais, en Los Encuentros. Prueba los ayampacos de tilapia y palmito.', activity: 'Cultura shuar · gastronomía · artesanía', assetPath: 'assets/images/tourism/nankais.jpg', asset: ClayAssets.artesania),
    _TourismPlace(title: 'Los Encuentros', category: 'Parroquia Los Encuentros', description: 'Cabecera parroquial junto al río Zamora, cerca de su confluencia con el Nangaritza y camino a la Cordillera del Cóndor.', activity: 'Paseo · río · cultura minera', assetPath: 'assets/images/tourism/los-encuentros-01.jpg', asset: ClayAssets.ubicacion),
    _TourismPlace(title: 'Iglesia Santa Ana', category: 'Parroquia Los Encuentros', description: 'El templo de Los Encuentros, punto de partida para recorrer la parroquia y su vida comunitaria.', activity: 'Patrimonio · fotografía · paseo', assetPath: 'assets/images/tourism/santa-ana-los-encuentros.jpg', asset: ClayAssets.events),
    _TourismPlace(title: 'Centro Turístico El Tesoro', category: 'Parroquia Los Encuentros', description: 'Piscina, sauna y turco para descansar después de recorrer Los Encuentros.', activity: 'Piscina · relax · familia', assetPath: 'assets/images/tourism/el-tesoro.jpg', asset: ClayAssets.rain),
    _TourismPlace(title: 'Hostería Playa Verde', category: 'Hospedaje y recreación', description: 'Área recreativa, hospedaje y restaurante en el sector Pitá, al norte de la ciudad.', activity: 'Hospedaje · gastronomía · hidromasaje', assetPath: 'assets/images/tourism/playa-verde.jpg', asset: ClayAssets.feria),
    _TourismPlace(title: 'Hostería Tierra Dorada', category: 'Hospedaje y recreación', description: 'Hospedaje con piscina, sauna y turco en el sector Vista Hermosa.', activity: 'Hospedaje · piscina · descanso', assetPath: 'assets/images/tourism/tierra-dorada.jpg', asset: ClayAssets.feria),
    _TourismPlace(title: 'Paraíso de Vita', category: 'Hospedaje y recreación', description: 'Piscina, alimentación y ecuavóley en la comunidad Wampash.', activity: 'Piscina · ecuavóley · gastronomía', assetPath: 'assets/images/tourism/paraiso-de-vita.jpg', asset: ClayAssets.feria),
    _TourismPlace(title: 'Estadio Municipal', category: 'Deporte', description: 'Escenario de campeonatos, jornadas deportivas y actividades de las fiestas de cantonización.', activity: 'Fútbol · atletismo · eventos', assetPath: 'assets/images/tourism/estadio-municipal.jpg', asset: ClayAssets.eventoPersona),
  ];

  List<String> get _categories => <String>[_allCategory, ..._places.map((place) => place.category).toSet()];

  List<_TourismPlace> get _filteredPlaces => _selectedCategory == _allCategory ? _places : _places.where((place) => place.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = _filteredPlaces;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildHero(context),
            const SizedBox(height: 28),
            Text('Explora por categoría', style: AppTypography.titleMd),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = category),
                    selectedColor: AppColors.primaryFixed,
                    checkmarkColor: AppColors.primary,
                    labelStyle: AppTypography.labelSm.copyWith(color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
                    side: BorderSide(color: isSelected ? AppColors.primaryFixed : AppColors.outlineVariant),
                    backgroundColor: AppColors.surfaceContainerLowest,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  );
                },
              ),
            ),
            const SizedBox(height: 26),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selectedCategory == _allCategory ? 'Lugares para descubrir' : _selectedCategory, style: AppTypography.headlineSm),
                      const SizedBox(height: 4),
                      Text('${filteredPlaces.length} destinos para planificar tu salida', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
                const ClayIcon(asset: ClayAssets.hummingbird, size: 46),
              ],
            ),
            const SizedBox(height: 14),
            ...filteredPlaces.map((place) => Padding(padding: const EdgeInsets.only(bottom: 16), child: _PlaceCard(place: place))),
            const SizedBox(height: 8),
            _buildGuideCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(tooltip: 'Volver al inicio', onPressed: () => context.go('/dashboard'), icon: const Icon(Icons.arrow_back_rounded), color: AppColors.primary),
        const SizedBox(width: 4),
        Expanded(child: Text('Turismo en Yantzaza', overflow: TextOverflow.ellipsis, style: AppTypography.titleLg.copyWith(color: AppColors.primary))),
        const ClayIcon(asset: ClayAssets.toucan, size: 42),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppBorderRadius.radiusXxl, boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.22), blurRadius: 24, offset: const Offset(0, 10))]),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: Opacity(opacity: 0.28, child: YantzazaRemoteImage(url: '', assetPath: 'assets/images/tourism/panoramica-nocturna.jpg', fit: BoxFit.cover))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Valle de las Luciérnagas', style: AppTypography.labelMd.copyWith(color: AppColors.primaryFixed)),
                const SizedBox(height: 8),
                Text('Yantzaza se vive en sus ríos', style: AppTypography.displaySm.copyWith(color: AppColors.onPrimary)),
                const SizedBox(height: 10),
                Text('Una guía para encontrar balnearios, cascadas, cultura shuar y lugares para compartir en Yantzaza, Chicaña y Los Encuentros.', style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary.withValues(alpha: 0.88))),
                const SizedBox(height: 18),
                Wrap(spacing: 8, runSpacing: 8, children: const [_HeroTag(label: '17 lugares'), _HeroTag(label: 'Balnearios'), _HeroTag(label: 'Cultura shuar')]),
                const SizedBox(height: 20),
                OutlinedButton.icon(onPressed: () => context.push('/tourism/guide'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.onPrimary, side: BorderSide(color: AppColors.onPrimary.withValues(alpha: 0.55))), icon: const Icon(Icons.menu_book_rounded, size: 18), label: const Text('Cómo usar Mi Yantzaza')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context) {
    return TonalCard(
      color: AppColors.secondaryContainer.withValues(alpha: 0.72),
      onTap: () => context.push('/tourism/guide'),
      child: Row(
        children: [
          const ClayIcon(asset: ClayAssets.toucan, size: 52),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Guía rápida para la ciudadanía', style: AppTypography.titleSm), const SizedBox(height: 4), Text('Encuentra un lugar, revisa el mapa y planifica una salida con información clara.', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant))])),
          const Icon(Icons.chevron_right_rounded, color: AppColors.secondary),
        ],
      ),
    );
  }
}

final class _PlaceCard extends StatelessWidget {
  final _TourismPlace place;

  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return TonalCard(
      padding: EdgeInsets.zero,
      onTap: () => _showPlaceDetails(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 156,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                YantzazaRemoteImage(url: '', assetPath: place.assetPath, borderRadius: const BorderRadius.vertical(top: Radius.circular(AppBorderRadius.xl))),
                Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.surfaceContainerLowest.withValues(alpha: 0.88), borderRadius: AppBorderRadius.radiusFull), child: Text(place.category, style: AppTypography.labelSm.copyWith(color: AppColors.primary)))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClayIcon(asset: place.asset, size: 46),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(place.title, style: AppTypography.titleMd), const SizedBox(height: 4), Text(place.description, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)), const SizedBox(height: 8), Text(place.activity, style: AppTypography.labelSm.copyWith(color: AppColors.primary))])),
                const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaceDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [ClayIcon(asset: place.asset, size: 56), const SizedBox(width: 12), Expanded(child: Text(place.title, style: AppTypography.headlineSm))]),
            const SizedBox(height: 10),
            Text(place.category, style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
            const SizedBox(height: 10),
            Text(place.description, style: AppTypography.bodyLg),
            const SizedBox(height: 8),
            Text(place.activity, style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () { Navigator.of(context).pop(); context.push('/maps'); }, icon: const Icon(Icons.map_outlined), label: const Text('Abrir mapa de Yantzaza'))),
          ],
        ),
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  final String label;

  const _HeroTag({required this.label});

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.onPrimary.withValues(alpha: 0.14), borderRadius: AppBorderRadius.radiusFull), child: Text(label, style: AppTypography.labelSm.copyWith(color: AppColors.onPrimary)));
}

class _TourismPlace {
  final String title;
  final String category;
  final String description;
  final String activity;
  final String assetPath;
  final String asset;

  const _TourismPlace({required this.title, required this.category, required this.description, required this.activity, required this.assetPath, required this.asset});
}
