import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app/router.dart';
import 'src/common_widgets/amazonian_backdrop.dart';
import 'src/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MiYantzazaApp(),
    ),
  );
}

class MiYantzazaApp extends StatelessWidget {
  const MiYantzazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mi Yantzaza',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      routerConfig: appRouter,
      builder: (context, child) => AmazonianBackdrop(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
