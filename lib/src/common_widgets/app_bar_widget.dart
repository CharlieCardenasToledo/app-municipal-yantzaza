import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import 'clay_icon.dart';

/// Reusable app bar with frosted glass effect.
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showNotification;

  const AppBarWidget({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showNotification = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: BackdropFilter(
          filter: _blurFilter,
          child: Row(
            children: [
              leading ?? const SizedBox(width: 40),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              ...?actions,
                if (showNotification)
                IconButton(
                   onPressed: () => context.push('/schedules'),
                  icon: const ClayIcon(asset: ClayAssets.alerts, size: 26),
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

final _blurFilter = ColorFilter.matrix(<double>[
  1, 0, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 0.8, 0,
]);
