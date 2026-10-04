import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/gradient_button.dart';
import '../../../common_widgets/glass_chip.dart';
import '../../../common_widgets/tonal_card.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

enum _PaymentView { obligations, receipt }

enum _PaymentStep { select, review, processing, success }

class _MunicipalObligation {
  final String title;
  final String category;
  final String reference;
  final String dueDate;
  final double amount;
  final double interest;
  final IconData icon;
  final Color accent;

  const _MunicipalObligation({
    required this.title,
    required this.category,
    required this.reference,
    required this.dueDate,
    required this.amount,
    required this.interest,
    required this.icon,
    required this.accent,
  });

  double get total => amount + interest;
}

const _obligations = [
  _MunicipalObligation(
    title: 'Impuesto predial urbano',
    category: 'Propiedad',
    reference: 'Predio urbano · Barrio Central',
    dueDate: '31 dic 2026',
    amount: 42.80,
    interest: 0,
    icon: Icons.home_work_outlined,
    accent: AppColors.primary,
  ),
  _MunicipalObligation(
    title: 'Patente municipal',
    category: 'Actividad económica',
    reference: 'Comercio local · RUC registrado',
    dueDate: '30 jun 2026',
    amount: 68.50,
    interest: 2.40,
    icon: Icons.storefront_outlined,
    accent: AppColors.secondary,
  ),
  _MunicipalObligation(
    title: 'Agua potable',
    category: 'Servicios',
    reference: 'Medidor domiciliario · Barrio Gran Colombia',
    dueDate: '15 oct 2026',
    amount: 18.00,
    interest: 0,
    icon: Icons.water_drop_outlined,
    accent: AppColors.tertiary,
  ),
];

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  _PaymentView _view = _PaymentView.obligations;
  _PaymentStep _step = _PaymentStep.select;
  _MunicipalObligation? _selected;
  _MunicipalObligation? _paidObligation;
  String _paymentMethod = 'Megonline';
  String _paidMethod = '';
  String _invoiceEmail = 'vecina@yantzaza.ec';
  String _paidEmail = '';
  String _lookupValue = '1900000000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: _view == _PaymentView.receipt
                  ? _buildReceiptView(context)
                  : _buildPaymentView(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        _buildServiceNotice(),
        const SizedBox(height: 24),
        _buildViewSwitcher(),
        const SizedBox(height: 24),
        if (_step == _PaymentStep.select) _buildLookupAndObligations(),
        if (_step == _PaymentStep.review || _step == _PaymentStep.processing)
          _buildPaymentReview(),
        if (_step == _PaymentStep.success) _buildSuccessCard(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SERVICIOS FINANCIEROS',
                style: AppTypography.labelSm.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text('Pagos municipales', style: AppTypography.displaySm),
              const SizedBox(height: 6),
              Text(
                'Consulta tus obligaciones con el GAD Municipal de Yantzaza y completa el pago en pocos pasos.',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Volver al inicio',
        ),
      ],
    );
  }

  Widget _buildServiceNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer.withValues(alpha: 0.38),
        borderRadius: AppBorderRadius.radiusLg,
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Consulta tus obligaciones, revisa el detalle y completa tu pago desde un solo lugar.',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.onSecondaryFixed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppBorderRadius.radiusFull,
      ),
      child: Row(
        children: [
          _buildSwitcherItem('Por pagar', _PaymentView.obligations),
          _buildSwitcherItem('Comprobantes', _PaymentView.receipt),
        ],
      ),
    );
  }

  Widget _buildSwitcherItem(String label, _PaymentView view) {
    final selected = _view == view;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (view == _PaymentView.receipt && _paidObligation == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Completa un pago para habilitar tus comprobantes.')),
            );
            return;
          }
          setState(() => _view = view);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceContainerLowest : Colors.transparent,
            borderRadius: AppBorderRadius.radiusFull,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelLg.copyWith(
              color: selected ? AppColors.primary : AppColors.outline,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLookupAndObligations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TonalCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Busca tus obligaciones', style: AppTypography.titleLg),
              const SizedBox(height: 4),
              Text(
                'Usa tu cédula, RUC o clave catastral para consultar.',
                style: AppTypography.bodySm.copyWith(color: AppColors.outline),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _lookupValue,
                      onChanged: (value) => _lookupValue = value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.badge_outlined),
                        labelText: 'Identificador',
                        hintText: 'Ej. 1900000000',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: AppBorderRadius.radiusMd,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _lookup,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(110, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.radiusMd,
                      ),
                    ),
                    child: const Text('Consultar'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Flexible(child: Text('Obligaciones encontradas', style: AppTypography.headlineSm)),
            const SizedBox(width: 8),
            GlassChip(
              label: '${_obligations.length}',
              backgroundColor: AppColors.primaryFixed,
              textColor: AppColors.primary,
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 800 ? 3 : constraints.maxWidth > 520 ? 2 : 1;
            final cardWidth = (constraints.maxWidth - 16 * (columns - 1)) / columns;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final obligation in _obligations)
                  SizedBox(width: cardWidth, child: _buildObligationCard(obligation)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildObligationCard(_MunicipalObligation obligation) {
    return TonalCard(
      padding: const EdgeInsets.all(20),
      onTap: () => setState(() {
        _selected = obligation;
        _step = _PaymentStep.review;
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: obligation.accent.withValues(alpha: 0.1),
                  borderRadius: AppBorderRadius.radiusMd,
                ),
                child: Icon(obligation.icon, color: obligation.accent),
              ),
              const Spacer(),
              const Icon(Icons.arrow_outward_rounded, color: AppColors.outline),
            ],
          ),
          const SizedBox(height: 18),
          Text(obligation.category, style: AppTypography.labelSm.copyWith(color: obligation.accent)),
          const SizedBox(height: 4),
          Text(obligation.title, style: AppTypography.titleLg),
          const SizedBox(height: 6),
          Text(
            obligation.reference,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const Divider(height: 28),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
                    const SizedBox(height: 2),
                    Text(_money(obligation.total), style: AppTypography.headlineSm),
                  ],
                ),
              ),
              Text('Vence ${obligation.dueDate}', style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentReview() {
    final obligation = _selected!;
    final isProcessing = _step == _PaymentStep.processing;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 760;
        final summary = TonalCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resumen de pago', style: AppTypography.headlineSm),
              const SizedBox(height: 20),
              _summaryRow('Concepto', obligation.title),
              _summaryRow('Referencia', obligation.reference),
              _summaryRow('Vencimiento', obligation.dueDate),
              const Divider(height: 28),
              _summaryRow('Valor principal', _money(obligation.amount)),
              _summaryRow('Intereses', _money(obligation.interest)),
              const Divider(height: 28),
              Row(
                children: [
                  Text('Total a pagar', style: AppTypography.titleMd),
                  const Spacer(),
                  Text(_money(obligation.total), style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
                ],
              ),
            ],
          ),
        );
        final method = TonalCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Medio de pago', style: AppTypography.headlineSm),
              const SizedBox(height: 6),
              Text('Selecciona el medio de pago que prefieras.', style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
              const SizedBox(height: 16),
              _paymentMethodOption(
                'Megonline',
                'Banca en línea de la Cooperativa Mego',
                Icons.link_rounded,
              ),
              const SizedBox(height: 10),
              _paymentMethodOption(
                'CACPEY Digital',
                'Banca en línea de la Cooperativa CACPEY',
                Icons.link_rounded,
              ),
              const SizedBox(height: 18),
              Text('Correo para la factura', style: AppTypography.labelLg),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: _invoiceEmail,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _invoiceEmail = value,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'tu-correo@ejemplo.com',
                ),
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: isProcessing ? 'Generando enlace…' : 'Continuar con $_paymentMethod',
                icon: isProcessing ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary)) : const Icon(Icons.open_in_new_rounded, size: 17),
                onPressed: isProcessing ? null : _simulatePayment,
              ),
              const SizedBox(height: 10),
              Text(
                'Se abrirá el enlace de pago y recibirás tu factura por correo.',
                textAlign: TextAlign.center,
                style: AppTypography.labelSm.copyWith(color: AppColors.outline),
              ),
            ],
          ),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: isProcessing ? null : () => setState(() => _step = _PaymentStep.select),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Cambiar obligación'),
            ),
            const SizedBox(height: 12),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: summary),
                  const SizedBox(width: 20),
                  Expanded(child: method),
                ],
              )
            else ...[
              summary,
              const SizedBox(height: 16),
              method,
            ],
          ],
        );
      },
    );
  }

  Widget _paymentMethodOption(String label, String subtitle, IconData icon) {
    final selected = _paymentMethod == label;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = label),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryFixed.withValues(alpha: 0.55) : AppColors.surfaceContainerLow,
          borderRadius: AppBorderRadius.radiusMd,
          border: Border.all(color: selected ? AppColors.primary : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.outline),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.titleSm),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
                ],
              ),
            ),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? AppColors.primary : AppColors.outline),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
          const SizedBox(width: 16),
          Expanded(child: Text(value, textAlign: TextAlign.end, style: AppTypography.labelLg)),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    final obligation = _paidObligation ?? _selected!;
    final paidMethod = _paidMethod.isEmpty ? _paymentMethod : _paidMethod;
    final paidEmail = _paidEmail.isEmpty ? _invoiceEmail : _paidEmail;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: TonalCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: AppColors.onSecondary, size: 40),
              ),
              const SizedBox(height: 20),
              Text('Pago aprobado', style: AppTypography.headlineMd),
              const SizedBox(height: 8),
              Text(
                'La operación se completó correctamente. La factura fue enviada a $paidEmail.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: AppBorderRadius.radiusLg,
                ),
                child: Column(
                  children: [
                    _summaryRow('Comprobante', 'ZM-2026-2048'),
                    _summaryRow('Concepto', obligation.title),
                    _summaryRow('Medio', paidMethod),
                    _summaryRow('Total', _money(obligation.total)),
                    _summaryRow('Factura', 'Enviada a $paidEmail'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comprobante listo para descargar.'))),
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Descargar'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => setState(() {
                        _step = _PaymentStep.select;
                        _selected = null;
                        _view = _PaymentView.obligations;
                      }),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Otro pago'),
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        _buildServiceNotice(),
        const SizedBox(height: 24),
        _buildViewSwitcher(),
        const SizedBox(height: 24),
        _buildSuccessCard(),
      ],
    );
  }

  void _lookup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Consulta realizada para $_lookupValue. Estas son tus obligaciones pendientes.')),
    );
  }

  Future<void> _simulatePayment() async {
    setState(() => _step = _PaymentStep.processing);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _paidObligation = _selected;
      _paidMethod = _paymentMethod;
      _paidEmail = _invoiceEmail;
      _step = _PaymentStep.success;
    });
  }

  String _money(double value) => '\$${value.toStringAsFixed(2)}';
}
