import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../common_widgets/clay_icon.dart';

// Parque Central de Yantzaza (OpenStreetMap).
const _yantzazaCenter = LatLng(-3.83301, -78.76125);
const _collectorPosition = LatLng(-3.83700, -78.76130);

const _mapLocations = <_MapLocation>[
  _MapLocation(
    id: 'centro',
    name: 'PARQUE CENTRAL',
    title: 'Recolección municipal',
    detail: 'Separa en la fuente: verde, negro y azul',
    status: 'En seguimiento',
    layer: 'Residuos',
    point: LatLng(-3.83301, -78.76125),
    icon: Icons.delete_rounded,
    color: AppColors.secondary,
  ),
  _MapLocation(
    id: 'malecon',
    name: 'MALECÓN',
    title: 'Ruta de residuos',
    detail: 'Malecón de la quebrada Yantzaza',
    status: 'Programada',
    layer: 'Residuos',
    point: LatLng(-3.830504, -78.761161),
    icon: Icons.recycling_rounded,
    color: AppColors.secondary,
  ),
  _MapLocation(
    id: 'terminal',
    name: 'TERMINAL',
    title: 'Terminal Terrestre',
    detail: 'Buses interprovinciales y parroquiales',
    status: 'Disponible',
    layer: 'Buses',
    point: LatLng(-3.820911, -78.758809),
    icon: Icons.directions_bus_rounded,
    color: AppColors.primary,
  ),
  _MapLocation(
    id: 'mercado',
    name: 'MERCADO',
    title: 'Mercado municipal',
    detail: 'Av. Iván Riofrío y 12 de Febrero',
    status: 'Abierto',
    layer: 'Entregas',
    point: LatLng(-3.834634, -78.761449),
    icon: Icons.storefront_rounded,
    color: AppColors.tertiary,
  ),
];

final class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  final _searchController = TextEditingController();
  final _routingClient = Dio();
  String activeLayer = 'Residuos';
  _MapLocation? selectedLocation = _mapLocations.first;
  LatLng destinationPoint = _mapLocations.first.point;
  String destinationLabel = 'Parque Central';
  List<LatLng> _collectorRoute = const [_collectorPosition];
  List<double> _routeDistances = const [0];
  LatLng _collectorPoint = _collectorPosition;
  double _routeProgress = 0;
  int _routeDurationMinutes = 4;
  bool _routeLoading = false;
  bool _isFollowing = false;
  String _routeSource = 'Ruta local de respaldo';
  Timer? _followTimer;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCollectorRoute());
  }

  @override
  void dispose() {
    _followTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<_MapLocation> get _visibleLocations =>
      _mapLocations.where((location) => location.layer == activeLayer).toList();

  List<LatLng> get _routePoints {
    switch (activeLayer) {
      case 'Buses':
        return const [
          LatLng(-3.820911, -78.758809),
          LatLng(-3.826621, -78.759617),
          LatLng(-3.830504, -78.761161),
          LatLng(-3.83301, -78.76125),
        ];
      case 'Entregas':
        return const [
          LatLng(-3.83301, -78.76125),
          LatLng(-3.834634, -78.761449),
        ];
      default:
        return _collectorRoute.length > 1 ? _collectorRoute : _fallbackRoute;
    }
  }

  List<LatLng> get _fallbackRoute => [
        _collectorPoint,
        const LatLng(-3.835877, -78.761276),
        const LatLng(-3.83301, -78.76125),
        const LatLng(-3.830504, -78.761161),
        destinationPoint,
      ];

  int get _etaMinutes {
    if (_isFollowing) {
      final remaining = ((_routeDurationMinutes * (1 - _routeProgress)).ceil());
      return remaining < 1 ? 1 : remaining;
    }
    final meters = const Distance().as(LengthUnit.Meter, _collectorPosition, destinationPoint);
    final minutes = (meters / 1000 / 18 * 60).ceil();
    return minutes < 4 ? 4 : minutes;
  }

  Future<void> _loadCollectorRoute() async {
    if (!mounted || activeLayer != 'Residuos') return;
    setState(() {
      _routeLoading = true;
      _isFollowing = false;
      _routeProgress = 0;
    });
    _followTimer?.cancel();

    final start = _collectorPoint;
    final endpoint = 'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${destinationPoint.longitude},${destinationPoint.latitude}'
        '?overview=full&geometries=geojson&steps=false';

    try {
      final response = await _routingClient.get(endpoint);
      final routes = response.data['routes'] as List<dynamic>?;
      final geometry = routes?.firstOrNull?['geometry'] as Map<String, dynamic>?;
      final coordinates = geometry?['coordinates'] as List<dynamic>?;
      final durationSeconds = routes?.firstOrNull?['duration'] as num?;

      if (coordinates == null || coordinates.length < 2) {
        throw const FormatException('OSRM no devolvió geometría');
      }

      final route = coordinates.map((coordinate) {
        final values = coordinate as List<dynamic>;
        return LatLng((values[1] as num).toDouble(), (values[0] as num).toDouble());
      }).toList();

      if (!mounted) return;
      setState(() {
        _collectorRoute = route;
        _rebuildRouteDistances();
        _collectorPoint = route.first;
        _routeDurationMinutes = ((durationSeconds ?? 240) / 60).ceil().clamp(1, 90);
        _routeSource = 'Ruta vial OSRM · OpenStreetMap';
        _routeLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      final fallback = _fallbackRoute;
      setState(() {
        _collectorRoute = fallback;
        _rebuildRouteDistances();
        _collectorPoint = fallback.first;
        _routeDurationMinutes = _etaMinutes;
        _routeSource = 'Ruta local de respaldo';
        _routeLoading = false;
      });
    }
  }

  void _rebuildRouteDistances() {
    final distances = <double>[0];
    for (var index = 1; index < _collectorRoute.length; index++) {
      final previous = _collectorRoute[index - 1];
      final current = _collectorRoute[index];
      distances.add(distances.last + const Distance().as(LengthUnit.Meter, previous, current));
    }
    _routeDistances = distances;
  }

  LatLng _pointAtProgress(double progress) {
    if (_collectorRoute.length < 2 || _routeDistances.last == 0) return _collectorRoute.first;
    final target = _routeDistances.last * progress.clamp(0, 1);
    for (var index = 1; index < _routeDistances.length; index++) {
      if (_routeDistances[index] >= target) {
        final segmentStart = _routeDistances[index - 1];
        final segmentLength = _routeDistances[index] - segmentStart;
        final fraction = segmentLength == 0 ? 0 : (target - segmentStart) / segmentLength;
        final from = _collectorRoute[index - 1];
        final to = _collectorRoute[index];
        return LatLng(
          from.latitude + (to.latitude - from.latitude) * fraction,
          from.longitude + (to.longitude - from.longitude) * fraction,
        );
      }
    }
    return _collectorRoute.last;
  }

  void _toggleFollow() {
    if (_routeLoading || _collectorRoute.length < 2) return;
    if (_isFollowing) {
      _followTimer?.cancel();
      setState(() => _isFollowing = false);
      return;
    }

    if (_routeProgress >= 1) {
      setState(() {
        _routeProgress = 0;
        _collectorPoint = _collectorRoute.first;
      });
    }

    setState(() => _isFollowing = true);
    _followTimer?.cancel();
    _followTimer = Timer.periodic(const Duration(milliseconds: 180), (_) {
      if (!mounted) return;
      final nextProgress = (_routeProgress + 0.018).clamp(0.0, 1.0);
      setState(() {
        _routeProgress = nextProgress;
        _collectorPoint = _pointAtProgress(nextProgress);
        if (nextProgress >= 1) _isFollowing = false;
      });
      _moveTo(_collectorPoint, _mapController.camera.zoom);
      if (nextProgress >= 1) _followTimer?.cancel();
    });
  }

  void _selectLayer(String layer) {
    final next = _mapLocations.firstWhere((location) => location.layer == layer);
    setState(() {
      activeLayer = layer;
      selectedLocation = next;
      if (layer == 'Residuos') {
        destinationPoint = _mapLocations.first.point;
        destinationLabel = 'Parque Central';
      }
    });
    if (layer == 'Residuos') _loadCollectorRoute();
    _moveTo(next.point, 15.2);
  }

  void _moveTo(LatLng point, double zoom) {
    if (_mapReady) {
      _mapController.move(point, zoom);
    }
  }

  void _searchLocation(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return;

    final match = _mapLocations.where((location) {
      return '${location.name} ${location.title} ${location.detail}'
          .toLowerCase()
          .contains(query);
    }).firstOrNull;

    if (match == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No encontramos ese lugar en el mapa de Yantzaza.')),
      );
      return;
    }

    setState(() {
      activeLayer = match.layer;
      selectedLocation = match;
      if (match.layer == 'Residuos') {
        destinationPoint = match.point;
        destinationLabel = match.name.toLowerCase();
      }
    });
    if (match.layer == 'Residuos') _loadCollectorRoute();
    _moveTo(match.point, 16);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _centerOnYantzaza() {
    setState(() {
      selectedLocation = _mapLocations.first;
      activeLayer = 'Residuos';
      destinationPoint = _mapLocations.first.point;
      destinationLabel = 'Parque Central';
    });
    _moveTo(_yantzazaCenter, 14.5);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mapa centrado en Yantzaza, Ecuador')),
    );
  }

  void _setDestination(LatLng point) {
    if (activeLayer != 'Residuos') return;
    setState(() {
      destinationPoint = point;
      destinationLabel = 'Destino seleccionado';
      selectedLocation = _mapLocations.first;
    });
    _loadCollectorRoute();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Destino fijado. Llegada estimada en $_etaMinutes min.')),
    );
  }

  void _followCollector() {
    setState(() {
      activeLayer = 'Residuos';
      selectedLocation = _mapLocations.first;
    });
    _moveTo(_collectorPosition, 16);
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedLocation;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _yantzazaCenter,
                initialZoom: 14.5,
                minZoom: 11,
                maxZoom: 19,
                onMapReady: () => setState(() => _mapReady = true),
                onTap: (_, point) => _setDestination(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'ec.gob.yantzaza.mi_yantzaza',
                  maxZoom: 19,
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: _layerColor.withValues(alpha: 0.82),
                      strokeWidth: 5,
                      borderColor: Colors.white.withValues(alpha: 0.75),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    ..._visibleLocations.map((location) {
                    final isSelected = selected?.id == location.id;
                    return Marker(
                      point: location.point,
                      width: 150,
                      height: 82,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => selectedLocation = location);
                          _moveTo(location.point, 16);
                        },
                        child: _MapPin(location: location, selected: isSelected),
                      ),
                    );
                  }),
                  if (activeLayer == 'Residuos') ...[
                    Marker(
                      point: _collectorPoint,
                      width: 150,
                      height: 82,
                      child: GestureDetector(
                        onTap: _followCollector,
                        child: const _CollectorPin(),
                      ),
                    ),
                    Marker(
                      point: destinationPoint,
                      width: 150,
                      height: 68,
                      child: const _DestinationPin(),
                    ),
                  ],
                ],
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 100,
              child: _MapSearchField(
                controller: _searchController,
                onSubmitted: _searchLocation,
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: _MapControlButton(
                icon: Icons.my_location_rounded,
                tooltip: 'Centrar en Yantzaza',
                onTap: _centerOnYantzaza,
              ),
            ),
            Positioned(
              top: 76,
              right: 16,
              child: Column(
                children: [
                  _MapControlButton(
                    icon: Icons.add_rounded,
                    tooltip: 'Acercar',
                    onTap: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1),
                  ),
                  const SizedBox(height: 8),
                  _MapControlButton(
                    icon: Icons.remove_rounded,
                    tooltip: 'Alejar',
                    onTap: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 154,
              right: 16,
              child: Column(
                children: [
                  _LayerButton(
                    icon: Icons.delete_rounded,
                    label: 'Residuos',
                    active: activeLayer == 'Residuos',
                    onTap: () => _selectLayer('Residuos'),
                  ),
                  const SizedBox(height: 8),
                  _LayerButton(
                    icon: Icons.directions_bus_rounded,
                    label: 'Buses',
                    active: activeLayer == 'Buses',
                    onTap: () => _selectLayer('Buses'),
                  ),
                  const SizedBox(height: 8),
                  _LayerButton(
                    icon: Icons.local_shipping_rounded,
                    label: 'Entregas',
                    active: activeLayer == 'Entregas',
                    onTap: () => _selectLayer('Entregas'),
                  ),
                ],
              ),
            ),
            if (selected != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _MapInfoPanel(
                  location: selected,
                  showArrival: activeLayer == 'Residuos',
                  destinationLabel: destinationLabel,
                  etaMinutes: _etaMinutes,
                  onClose: () => setState(() => selectedLocation = null),
                  isFollowing: _isFollowing,
                  routeLoading: _routeLoading,
                  routeSource: _routeSource,
                  onRoute: _toggleFollow,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color get _layerColor {
    switch (activeLayer) {
      case 'Buses':
        return AppColors.primary;
      case 'Entregas':
        return AppColors.tertiary;
      default:
        return AppColors.secondary;
    }
  }
}

class _MapSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const _MapSearchField({required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) => Material(
        elevation: 5,
        borderRadius: AppBorderRadius.radiusLg,
        color: AppColors.surfaceContainerLowest,
        child: TextField(
          controller: controller,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Buscar lugares o servicios en Yantzaza...',
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.outline),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      );
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _MapControlButton({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        elevation: 5,
        color: AppColors.surfaceContainerLowest,
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: tooltip,
          onPressed: onTap,
          icon: Icon(icon, color: AppColors.onSurfaceVariant),
        ),
      );
}

class _MapPin extends StatelessWidget {
  final _MapLocation location;
  final bool selected;

  const _MapPin({required this.location, required this.selected});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: selected ? 48 : 40,
            height: selected ? 48 : 40,
            decoration: BoxDecoration(
              color: location.color,
              borderRadius: AppBorderRadius.radiusFull,
              border: Border.all(color: AppColors.surfaceContainerLowest, width: 2),
              boxShadow: [
                BoxShadow(color: location.color.withValues(alpha: 0.35), blurRadius: selected ? 16 : 8),
              ],
            ),
            child: Icon(location.icon, color: AppColors.onPrimary, size: selected ? 24 : 20),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: AppBorderRadius.radiusFull,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Text(location.name, style: AppTypography.overline.copyWith(color: location.color)),
          ),
        ],
      );
}

class _CollectorPin extends StatelessWidget {
  const _CollectorPin();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppBorderRadius.radiusFull,
              border: Border.all(color: AppColors.surfaceContainerLowest, width: 3),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: const ClayIcon(asset: ClayAssets.recolector, size: 38),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppBorderRadius.radiusFull,
            ),
            child: Text(
              'RECOLECTOR',
              style: AppTypography.overline.copyWith(color: AppColors.onPrimary),
            ),
          ),
        ],
      );
}

class _DestinationPin extends StatelessWidget {
  const _DestinationPin();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: AppBorderRadius.radiusFull,
              border: Border.all(color: AppColors.surfaceContainerLowest, width: 2),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: const ClayIcon(asset: ClayAssets.destino, size: 28),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: AppBorderRadius.radiusFull,
            ),
            child: Text('DESTINO', style: AppTypography.overline.copyWith(color: AppColors.error)),
          ),
        ],
      );
}

class _LayerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _LayerButton({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        elevation: 5,
        borderRadius: AppBorderRadius.radiusLg,
        color: active ? AppColors.secondaryContainer : AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorderRadius.radiusLg,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: active ? AppColors.onSecondaryContainer : AppColors.outline, size: 20),
                Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: active ? AppColors.onSecondaryContainer : AppColors.outline)),
              ],
            ),
          ),
        ),
      );
}

class _MapInfoPanel extends StatelessWidget {
  final _MapLocation location;
  final bool showArrival;
  final String destinationLabel;
  final int etaMinutes;
  final bool isFollowing;
  final bool routeLoading;
  final String routeSource;
  final VoidCallback onClose;
  final VoidCallback onRoute;

  const _MapInfoPanel({
    required this.location,
    required this.showArrival,
    required this.destinationLabel,
    required this.etaMinutes,
    required this.isFollowing,
    required this.routeLoading,
    required this.routeSource,
    required this.onClose,
    required this.onRoute,
  });

  @override
  Widget build(BuildContext context) => Material(
        elevation: 14,
        borderRadius: AppBorderRadius.radiusXxl,
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.97),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: location.color.withValues(alpha: 0.12), borderRadius: AppBorderRadius.radiusLg),
                    child: Icon(location.icon, color: location.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(location.title, style: AppTypography.titleMd),
                        Text(location.detail, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  IconButton(tooltip: 'Cerrar detalle', onPressed: onClose, icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const SizedBox(height: 12),
              if (showArrival) ...[
                Row(
                  children: [
                    Expanded(
                      child: _EtaMetric(
                        label: 'LLEGADA ESTIMADA',
                        value: '$etaMinutes min',
                        icon: Icons.schedule_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _EtaMetric(
                        label: 'DESTINO',
                        value: destinationLabel,
                        icon: Icons.home_rounded,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: AppBorderRadius.radiusLg),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, size: 18, color: location.color),
                          const SizedBox(width: 8),
                          Expanded(child: Text(location.status, style: AppTypography.labelMd)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: routeLoading ? null : onRoute,
                    icon: routeLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(isFollowing ? Icons.pause_rounded : Icons.navigation_rounded, size: 18),
                    label: Text(routeLoading ? 'Calculando' : isFollowing ? 'Pausar' : 'Seguir'),
                  ),
                ],
              ),
              if (showArrival) ...[
                const SizedBox(height: 10),
                Text(
                  '$routeSource · Toca el mapa para cambiar tu destino.',
                  style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      );
}

class _EtaMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _EtaMetric({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppBorderRadius.radiusLg,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.overline.copyWith(color: color)),
                  const SizedBox(height: 2),
                  Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSm),
                ],
              ),
            ),
          ],
        ),
      );

}

class _MapLocation {
  final String id;
  final String name;
  final String title;
  final String detail;
  final String status;
  final String layer;
  final LatLng point;
  final IconData icon;
  final Color color;

  const _MapLocation({
    required this.id,
    required this.name,
    required this.title,
    required this.detail,
    required this.status,
    required this.layer,
    required this.point,
    required this.icon,
    required this.color,
  });
}
