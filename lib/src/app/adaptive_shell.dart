import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../common_widgets/clay_icon.dart';

/// Adaptive shell that switches between mobile bottom nav, tablet navigation
/// rail, and desktop sidebar based on screen width.
class AdaptiveShell extends StatelessWidget {
  final Widget child;

  const AdaptiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < 600) {
          return _MobileShell(child: child);
        } else if (width < 1024) {
          return _TabletShell(child: child);
        } else {
          return _DesktopShell(child: child);
        }
      },
    );
  }
}

class _ShellIcon extends StatelessWidget {
  final ShellTab tab;
  final double size;

  const _ShellIcon({required this.tab, required this.size});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tab.label,
      image: true,
      child: ClayIcon(asset: tab.asset, size: size),
    );
  }
}

// ─── Breakpoints ──────────────────────────────────────────────
enum ShellTab {
  dashboard('Inicio', Icons.dashboard_rounded, ClayAssets.hummingbird),
  marketplace('Comercio', Icons.storefront_rounded, ClayAssets.commerce),
  incidents('Reportar', Icons.campaign_rounded, ClayAssets.report),
  maps('Rutas', Icons.directions_bus_rounded, ClayAssets.routes),
  events('Eventos', Icons.calendar_today_rounded, ClayAssets.events);

  final String label;
  final IconData icon;
  final String asset;

  const ShellTab(this.label, this.icon, this.asset);

  String get path {
    return switch (this) {
      ShellTab.dashboard => '/dashboard',
      ShellTab.marketplace => '/marketplace',
      ShellTab.incidents => '/incidents',
      ShellTab.maps => '/maps',
      ShellTab.events => '/events',
    };
  }

  static ShellTab fromPath(String path) {
    return ShellTab.values.firstWhere(
      (tab) => tab.path == path,
      orElse: () => ShellTab.dashboard,
    );
  }
}

// ─── Shell helpers ────────────────────────────────────────────
ShellTab _currentTab(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();
  return ShellTab.fromPath(location);
}

void _onTabTap(BuildContext context, ShellTab tab) {
  context.go(tab.path);
}

// ═══════════════════════════════════════════════════════════════
// MOBILE SHELL  (< 600px) – BottomNavigationBar
// ═══════════════════════════════════════════════════════════════
class _MobileShell extends StatelessWidget {
  final Widget child;
  const _MobileShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final current = _currentTab(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ShellTab.values.map((tab) {
                final selected = tab == current;
                return Flexible(
                  child: GestureDetector(
                    onTap: () => _onTabTap(context, tab),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryFixed
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ShellIcon(tab: tab, size: 27),
                          const SizedBox(height: 4),
                          Text(
                            tab.label,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: AppTypography.labelSm.copyWith(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.outline,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TABLET SHELL  (600–1024px) – NavigationRail
// ═══════════════════════════════════════════════════════════════
class _TabletShell extends StatelessWidget {
  final Widget child;
  const _TabletShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final current = _currentTab(context);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: current.index,
            onDestinationSelected: (i) =>
                _onTabTap(context, ShellTab.values[i]),
            backgroundColor: AppColors.surfaceContainerLowest,
            labelType: NavigationRailLabelType.all,
            indicatorColor: AppColors.primaryFixed,
            destinations: ShellTab.values.map((tab) {
              return NavigationRailDestination(
                icon: _ShellIcon(tab: tab, size: 25),
                selectedIcon: _ShellIcon(tab: tab, size: 25),
                label: Text(
                  tab.label,
                  style: AppTypography.labelSm.copyWith(
                    color: tab == current
                        ? AppColors.primary
                        : AppColors.outline,
                  ),
                ),
              );
            }).toList(),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 0,
            color: Colors.transparent,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DESKTOP SHELL  (> 1024px) – Sidebar
// ═══════════════════════════════════════════════════════════════
class _DesktopShell extends StatelessWidget {
  final Widget child;
  const _DesktopShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final current = _currentTab(context);
    return Scaffold(
      body: Row(
        children: [
          // ─── Sidebar ──────────────────────────────────────────
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: Border(
                right: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ─── Logo ────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 32, 24, 48),
                    child: Row(
                      children: [
                        ClayIcon(asset: ClayAssets.hummingbird, size: 34),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mi Yantzaza',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              'VALLE DE LAS LUCIÉRNAGAS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.12,
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ─── Navigation Items ─────────────────────────
                  ...ShellTab.values.map((tab) {
                    final selected = tab == current;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Material(
                        color: selected
                            ? AppColors.primaryFixed.withValues(alpha: 0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _onTabTap(context, tab),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                _ShellIcon(tab: tab, size: 24),
                                const SizedBox(width: 16),
                                Text(
                                  tab.label,
                                  style: AppTypography.labelLg.copyWith(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  // ─── Bottom actions ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/incidents'),
                        icon: const ClayIcon(
                          asset: ClayAssets.report,
                          size: 24,
                        ),
                        label: const Text('Reportar al Municipio'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.go('/about'),
                    icon: const ClayIcon(asset: ClayAssets.avatar, size: 24),
                    label: const Text('Acerca de Mi Yantzaza'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // ─── Main Content ────────────────────────────────────
          Expanded(
            child: ColoredBox(color: AppColors.surface, child: child),
          ),
        ],
      ),
    );
  }
}
