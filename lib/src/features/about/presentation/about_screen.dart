import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widgets/clay_icon.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

final class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static final _websiteUri = Uri.parse('http://nekateklabs.com/');

  Future<void> _openWebsite(BuildContext context) async {
    final opened = await launchUrl(
      _websiteUri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el sitio web.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.primary,
                    tooltip: 'Volver',
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: AppBorderRadius.radiusXl,
                          ),
                          child: const ClayIcon(asset: ClayAssets.hummingbird, size: 84),
                        ),
                        const SizedBox(height: 20),
                        Text('Mi Yantzaza', style: AppTypography.displaySm),
                        const SizedBox(height: 6),
                        Text(
                          'Valle de las Luciérnagas',
                          style: AppTypography.labelLg.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: AppBorderRadius.radiusXl,
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Una propuesta para conectar con Yantzaza', style: AppTypography.headlineSm),
                        const SizedBox(height: 10),
                        Text(
                          'Mi Yantzaza reúne servicios municipales, participación ciudadana, comercio local, rutas y actividades en una experiencia sencilla para la comunidad.',
                          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 18),
                        Text('Desarrollo y propuesta', style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
                        const SizedBox(height: 6),
                        Text('Nekatek Lab', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 6),
                        Text(
                          'Empresa detrás del desarrollo y la propuesta de esta aplicación.',
                          style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _openWebsite(context),
                            icon: const Icon(Icons.open_in_new_rounded, size: 18),
                            label: const Text('Conocer Nekatek Lab'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'nekateklabs.com',
                            style: AppTypography.labelSm.copyWith(color: AppColors.outline),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Servicios, naturaleza y comunidad en un mismo lugar.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySm.copyWith(color: AppColors.outline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
