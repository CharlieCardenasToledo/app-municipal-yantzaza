import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_yantzaza/main.dart' as app;
import 'package:mi_yantzaza/src/app/router.dart';

Future<void> _openRoute(WidgetTester tester, String route) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const app.MiYantzazaApp());
  appRouter.go(route);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MiYantzazaApp());
    expect(find.text('Mi Yantzaza'), findsOneWidget);
  });

  testWidgets('Dashboard muestra noticias del GAD de Yantzaza', (tester) async {
    await _openRoute(tester, '/dashboard');
    expect(find.text('Descubre Yantzaza'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Más cámaras, más seguridad'), 400, scrollable: find.byType(Scrollable).first);
    expect(find.text('Más cámaras, más seguridad'), findsOneWidget);
  });

  testWidgets('Horarios muestran el calendario de recolección por tacho', (tester) async {
    await _openRoute(tester, '/schedules');
    expect(find.text('HOY TOCA'), findsOneWidget);
    expect(find.textContaining('Tacho verde'), findsWidgets);
    await tester.scrollUntilVisible(find.textContaining('Tacho azul'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('Tacho azul'), findsWidgets);
  });

  testWidgets('Turismo lista los 17 lugares de Yantzaza', (tester) async {
    await _openRoute(tester, '/tourism');
    expect(find.text('Turismo en Yantzaza'), findsOneWidget);
    expect(find.text('17 destinos para planificar tu salida'), findsOneWidget);
  });

  testWidgets('Detalle de evento de cantonización', (tester) async {
    await _openRoute(tester, '/events/festival');
    expect(find.text('Fiestas de cantonización · Lúcete en Febrero'), findsOneWidget);
    expect(find.text('Parque Central de Yantzaza'), findsOneWidget);
  });

  testWidgets('Pagos ofrece canales de cooperativas locales', (tester) async {
    await _openRoute(tester, '/payments');
    expect(find.textContaining('GAD Municipal de Yantzaza'), findsOneWidget);
  });
}
