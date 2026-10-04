import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Todas las imágenes referenciadas en lib/ están empaquetadas', () async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final bundled = manifest.listAssets().toSet();
    final referenced = <String>{};
    final pattern = RegExp(r"assets/images/[\w\-/]+\.(?:jpg|png|webp)");

    for (final file in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      referenced.addAll(pattern.allMatches(file.readAsStringSync()).map((m) => m.group(0)!));
    }

    expect(referenced, isNotEmpty);
    final missing = referenced.difference(bundled);
    expect(missing, isEmpty, reason: 'Imágenes no declaradas en pubspec.yaml: $missing');
  });
}
