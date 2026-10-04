import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_border_radius.dart';
import '../core/theme/app_spacing.dart';

/// Editorial-style search bar with rounded corners and glass effect.
class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Buscar...',
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppBorderRadius.radiusLg,
      ),
      child: TextField(
        onChanged: onChanged,
        onSubmitted: (_) => onSubmitted?.call(),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.outline,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          hintStyle: TextStyle(
            fontFamily: 'Public Sans',
            color: AppColors.outline.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
