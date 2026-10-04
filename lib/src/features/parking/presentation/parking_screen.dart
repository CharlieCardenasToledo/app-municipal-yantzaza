import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common_widgets/gradient_button.dart';
import '../../../common_widgets/glass_chip.dart';
import '../../../common_widgets/tonal_card.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

enum _ParkingStep { setup, plans, active }

class _ParkingPlan {
  final String title;
  final String duration;
  final String detail;
  final double price;
  final IconData icon;
  final Color color;

  const _ParkingPlan({
    required this.title,
    required this.duration,
    required this.detail,
    required this.price,
    required this.icon,
    required this.color,
  });
}

const _parkingPlans = [
  _ParkingPlan(
    title: 'Media hora',
    duration: '30 min',
    detail: 'Uso puntual',
    price: 0.125,
    icon: Icons.timelapse_rounded,
    color: AppColors.primary,
  ),
  _ParkingPlan(
    title: 'Una hora',
    duration: '60 min',
    detail: 'La opción más usada',
    price: 0.25,
    icon: Icons.schedule_rounded,
    color: AppColors.secondary,
  ),
  _ParkingPlan(
    title: 'Tarjeta A digital',
    duration: '6 h acumuladas',
    detail: 'Vigencia 90 días',
    price: 1.50,
    icon: Icons.confirmation_number_outlined,
    color: AppColors.tertiary,
  ),
  _ParkingPlan(
    title: 'Tarjeta B digital',
    duration: '12 h acumuladas',
    detail: 'Vigencia 90 días',
    price: 3.00,
    icon: Icons.local_activity_outlined,
    color: AppColors.primaryContainer,
  ),
];

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final _plateController = TextEditingController(text: 'ZMA-2048');
  Timer? _timer;
  _ParkingStep _step = _ParkingStep.setup;
  _ParkingPlan _selectedPlan = _parkingPlans[1];
  String _zone = 'Zona A';
  int _remainingSeconds = 0;
  bool _showZones = false;

  @override
  void dispose() {
    _timer?.cancel();
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: _buildPage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildServiceNotice(),
        const SizedBox(height: 24),
        if (_step == _ParkingStep.setup) _buildSetup(),
        if (_step == _ParkingStep.plans) _buildPlans(),
        if (_step == _ParkingStep.active) _buildActiveParking(),
        const SizedBox(height: 24),
        _buildZonesCard(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PROPUESTA · MOVILIDAD',
                style: AppTypography.labelSm.copyWith(color: AppColors.secondary),
              ),
              const SizedBox(height: 6),
              Text('Estacionamiento tarifado', style: AppTypography.displaySm),
              const SizedBox(height: 6),
              Text(
                'Propuesta de estacionamiento rotativo para ordenar el centro de Yantzaza desde el celular.',
                style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Cerrar',
        ),
      ],
    );
  }

  Widget _buildServiceNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withValues(alpha: 0.5),
        borderRadius: AppBorderRadius.radiusLg,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Gestiona tu estacionamiento por placa, consulta la zona y recibe avisos antes de que termine tu tiempo.',
              style: AppTypography.bodySm.copyWith(color: AppColors.onPrimaryFixed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetup() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 760;
        final form = TonalCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. Identifica tu vehículo', style: AppTypography.headlineSm),
              const SizedBox(height: 6),
              Text(
                'La placa será tu identificador para que el controlador pueda validar la activación.',
                style: AppTypography.bodySm.copyWith(color: AppColors.outline),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _plateController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.directions_car_outlined),
                  labelText: 'Placa del vehículo',
                  hintText: 'Ej. ZMA-2048',
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.radiusMd,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _zone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  labelText: 'Zona de estacionamiento',
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.radiusMd,
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Zona A', child: Text('Zona A · Centro de Yantzaza')),
                  DropdownMenuItem(value: 'Zona B', child: Text('Zona B · Mercado municipal')),
                ],
                onChanged: (value) => setState(() => _zone = value ?? _zone),
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Ver opciones de tiempo',
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                onPressed: _goToPlans,
              ),
            ],
          ),
        );
        final intelligence = TonalCard(
          padding: const EdgeInsets.all(24),
          color: AppColors.secondaryContainer.withValues(alpha: 0.34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: AppBorderRadius.radiusMd,
                ),
                child: const Icon(Icons.psychology_rounded, color: AppColors.onSecondary),
              ),
              const SizedBox(height: 20),
              Text('Asistencia inteligente', style: AppTypography.headlineSm),
              const SizedBox(height: 8),
              Text(
                'Según la zona, la app te muestra la tarifa válida y te avisa antes de que se termine el tiempo.',
                style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _infoLine(Icons.timer_outlined, 'Aviso 10 min antes'),
              const SizedBox(height: 12),
              _infoLine(Icons.verified_outlined, 'Validación por placa'),
              const SizedBox(height: 12),
              _infoLine(Icons.map_outlined, 'Zonas propuestas'),
            ],
          ),
        );
        return wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: form),
                  const SizedBox(width: 20),
                  Expanded(child: intelligence),
                ],
              )
            : Column(children: [form, const SizedBox(height: 16), intelligence]);
      },
    );
  }

  Widget _buildPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _step = _ParkingStep.setup),
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('Cambiar vehículo o zona'),
        ),
        const SizedBox(height: 12),
        TonalCard(
          padding: const EdgeInsets.all(20),
          color: AppColors.surfaceContainerLow,
          child: Row(
            children: [
              const Icon(Icons.directions_car_filled_rounded, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_plateController.text.toUpperCase()} · $_zone',
                  style: AppTypography.titleMd,
                ),
              ),
              const GlassChip(
                label: 'Zona habilitada',
                backgroundColor: AppColors.secondaryContainer,
                textColor: AppColors.onSecondaryContainer,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('2. Elige cuánto tiempo necesitas', style: AppTypography.headlineSm),
        const SizedBox(height: 6),
        Text(
          'Tarifas referenciales para la propuesta, a definir por ordenanza municipal.',
          style: AppTypography.bodySm.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 520 ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _parkingPlans.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: columns == 1 ? 3.0 : 0.95,
              ),
              itemBuilder: (context, index) => _buildPlanCard(_parkingPlans[index]),
            );
          },
        ),
        const SizedBox(height: 24),
        GradientButton(
          label: 'Activar ${_selectedPlan.title.toLowerCase()} · ${_money(_selectedPlan.price)}',
          icon: const Icon(Icons.lock_open_rounded, size: 18),
          onPressed: _activateParking,
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Confirmación inmediata y comprobante digital',
            style: AppTypography.labelSm.copyWith(color: AppColors.outline),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(_ParkingPlan plan) {
    final selected = plan == _selectedPlan;
    return TonalCard(
      padding: const EdgeInsets.all(18),
      color: selected ? plan.color.withValues(alpha: 0.1) : null,
      onTap: () => setState(() => _selectedPlan = plan),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: plan.color.withValues(alpha: 0.12),
                  borderRadius: AppBorderRadius.radiusMd,
                ),
                child: Icon(plan.icon, color: plan.color),
              ),
              const Spacer(),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? plan.color : AppColors.outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(plan.title, style: AppTypography.titleMd),
          const SizedBox(height: 4),
          Text(plan.duration, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
          const Spacer(),
          Text(_money(plan.price), style: AppTypography.headlineSm.copyWith(color: plan.color)),
          const SizedBox(height: 2),
          Text(plan.detail, style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
        ],
      ),
    );
  }

  Widget _buildActiveParking() {
    final minutes = (_remainingSeconds / 60).ceil();
    final hours = minutes ~/ 60;
    final restMinutes = minutes % 60;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: AppBorderRadius.radiusXl,
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.2),
                blurRadius: 26,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_parking_rounded, color: AppColors.onSecondary, size: 28),
                  const SizedBox(width: 10),
                  Text('Estacionamiento activo', style: AppTypography.titleLg.copyWith(color: AppColors.onSecondary)),
                  const Spacer(),
                  const GlassChip(
                    label: 'Vigente',
                    backgroundColor: AppColors.secondaryFixed,
                    textColor: AppColors.onSecondaryFixed,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                hours > 0 ? '$hours h $restMinutes min' : '$minutes min',
                style: AppTypography.displayMd.copyWith(color: AppColors.onSecondary),
              ),
              const SizedBox(height: 4),
              Text('tiempo restante', style: AppTypography.bodyMd.copyWith(color: AppColors.secondaryFixed)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: [
                  _activeMeta(Icons.directions_car_rounded, _plateController.text.toUpperCase()),
                  _activeMeta(Icons.location_on_rounded, _zone),
                  _activeMeta(Icons.confirmation_number_outlined, 'ZM-SMET-2048'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _extendParking,
                icon: const Icon(Icons.add_alarm_rounded),
                label: const Text('Extender 30 min'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _finishParking,
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('Finalizar'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: AppColors.tertiary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TonalCard(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Te avisaremos cuando queden 10 minutos para que puedas extender el tiempo.',
                  style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZonesCard() {
    return TonalCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _showZones = !_showZones),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: AppBorderRadius.radiusMd,
                  ),
                  child: const Icon(Icons.map_outlined, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¿Dónde aplicaría?', style: AppTypography.titleMd),
                      const SizedBox(height: 3),
                      Text('Yantzaza aún no tiene estacionamiento tarifado: estas zonas son una propuesta.', style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                    ],
                  ),
                ),
                Icon(_showZones ? Icons.expand_less_rounded : Icons.expand_more_rounded),
              ],
            ),
          ),
          if (_showZones) ...[
            const Divider(height: 28),
            _zoneRow('Zona A', 'Av. Iván Riofrío entre Armando Arias y 12 de Febrero, alrededor del Parque Central.'),
            const SizedBox(height: 14),
            _zoneRow('Zona B', 'Calles adyacentes al Mercado Municipal en el barrio Sur.'),
            const SizedBox(height: 14),
            Text(
              'Horario sugerido: lunes a viernes, 08:00–17:00, coordinado con la Unidad Técnica de Movilidad (UTM).',
              style: AppTypography.bodySm.copyWith(color: AppColors.outline),
            ),
          ],
        ],
      ),
    );
  }

  Widget _zoneRow(String name, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassChip(
          label: name,
          backgroundColor: AppColors.secondaryContainer,
          textColor: AppColors.onSecondaryContainer,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(description, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant))),
      ],
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 18),
        const SizedBox(width: 10),
        Text(text, style: AppTypography.labelLg),
      ],
    );
  }

  Widget _activeMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.secondaryFixed),
        const SizedBox(width: 6),
        Text(text, style: AppTypography.labelMd.copyWith(color: AppColors.onSecondary)),
      ],
    );
  }

  void _goToPlans() {
    final plate = _plateController.text.trim();
    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa una placa para continuar.')));
      return;
    }
    setState(() => _step = _ParkingStep.plans);
  }

  void _activateParking() {
    final minutes = _selectedPlan.duration.startsWith('30')
        ? 30
        : _selectedPlan.duration.startsWith('60')
            ? 60
            : _selectedPlan.duration.startsWith('6')
                ? 360
                : 720;
    setState(() {
      _remainingSeconds = minutes * 60;
      _step = _ParkingStep.active;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        _timer?.cancel();
        setState(() => _remainingSeconds = 0);
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _extendParking() {
    setState(() => _remainingSeconds += 30 * 60);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Se agregaron 30 minutos.')));
  }

  void _finishParking() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 0;
      _step = _ParkingStep.setup;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estacionamiento finalizado.')));
  }

  String _money(double value) => '\$${value.toStringAsFixed(2)}';
}
