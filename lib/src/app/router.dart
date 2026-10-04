import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/marketplace/presentation/marketplace_screen.dart';
import '../features/incidents/presentation/incidents_screen.dart';
import '../features/maps/presentation/map_screen.dart';
import '../features/events/presentation/events_agenda_screen.dart';
import '../features/my_events/presentation/my_events_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/orders/presentation/order_confirmed_screen.dart';
import '../features/schedules/presentation/schedule_screen.dart';
import '../features/settings/presentation/proximity_alert_screen.dart';
import '../features/payments/presentation/payments_screen.dart';
import '../features/parking/presentation/parking_screen.dart';
import '../features/about/presentation/about_screen.dart';
import '../features/tourism/presentation/tourism_screen.dart';
import '../features/tourism/presentation/tourism_guide_screen.dart';
import '../features/marketplace/presentation/business_detail_screen.dart';
import '../features/events/presentation/event_detail_screen.dart';
import 'adaptive_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = _createRouter();

final routerProvider = Provider<GoRouter>((ref) => appRouter);

GoRouter _createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      // ─── Shell route (adaptive bottom nav / rail / sidebar) ───
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AdaptiveShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/marketplace',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MarketplaceScreen(),
            ),
          ),
          GoRoute(
            path: '/incidents',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: IncidentsScreen(),
            ),
          ),
          GoRoute(
            path: '/maps',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MapScreen(),
            ),
          ),
          GoRoute(
            path: '/events',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EventsAgendaScreen(),
            ),
          ),
        ],
      ),

      // ─── Full-screen routes (no bottom nav) ──────────────────
      GoRoute(
        path: '/marketplace/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BusinessDetailScreen(
          businessId: state.pathParameters['id'] ?? 'panaderia',
        ),
      ),
      GoRoute(
        path: '/events/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => EventDetailScreen(
          eventId: state.pathParameters['id'] ?? 'festival',
        ),
      ),
      GoRoute(
        path: '/my-events',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MyEventsScreen(),
      ),
      GoRoute(
        path: '/cart',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-confirmed',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OrderConfirmedScreen(),
      ),
      GoRoute(
        path: '/schedules',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScheduleScreen(),
      ),
      GoRoute(
        path: '/alert-settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProximityAlertScreen(),
      ),
      GoRoute(
        path: '/parking',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ParkingScreen(),
      ),
      GoRoute(
        path: '/payments',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: '/about',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/tourism',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TourismScreen(),
      ),
      GoRoute(
        path: '/tourism/guide',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TourismGuideScreen(),
      ),
    ],
  );
}
