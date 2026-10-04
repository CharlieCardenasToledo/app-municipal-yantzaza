import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_border_radius.dart';

/// Card that uses tonal layering (background shift) instead of borders.
/// Cards are the primary way to group content without using divider lines.
class TonalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;

  const TonalCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceContainerLowest,
        borderRadius: AppBorderRadius.radiusXl,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.04),
            blurRadius: 32,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppBorderRadius.radiusXl,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );

    return card;
  }
}
