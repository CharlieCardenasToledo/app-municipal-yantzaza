import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_border_radius.dart';
import '../core/theme/app_typography.dart';

/// Mi Yantzaza chip with optional glassmorphism effect.
class GlassChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const GlassChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (backgroundColor ?? AppColors.tertiaryContainer)
            .withValues(alpha: 0.3),
        borderRadius: AppBorderRadius.radiusFull,
      ),
      child: BackdropFilter(
        filter: _blurFilter,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: textColor ?? AppColors.onTertiaryContainer),
              const SizedBox(width: 4),
            ],
            Text(
              label.toUpperCase(),
              style: AppTypography.overline.copyWith(
                color: textColor ?? AppColors.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _blurFilter = ColorFilter.matrix(<double>[
  1, 0, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 0.7, 0,
]);
