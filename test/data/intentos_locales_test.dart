import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:miprimerapp/core/json.dart';
import 'package:miprimerapp/features/intentos/data/intentos_locales.dart';

const _json = '''
[
  {
    "id": "intento-001",
    "estudianteId": "est-045",
    "simulacroId": "sim-matematicas-01",
    "iniciadoEn": "2026-08-10T14:00:00Z",
    "estado": { "tipo": "en_progreso", "preguntaActual": 1 }
  }
]
''';

void main() {
  test('lee la lista completa del archivo', () async {
    final repo = IntentosLocales(lector: (_) async => _json);
    expect((await repo.obtenerTodos()).length, 1);
  });

  test('busca por id y devuelve null cuando no está', () async {
    final repo = IntentosLocales(lector: (_) async => _json);
    expect((await repo.obtenerPorId('intento-001'))?.estudianteId, 'est-045');
    expect(await repo.obtenerPorId('no-existe'), isNull);
  });

  test('un archivo que no es una lista se rechaza', () async {
    final repo = IntentosLocales(lector: (_) async => '{"a": 1}');
    expect(repo.obtenerTodos(), throwsA(isA<CampoInvalido>()));
  });

  test(
    'el asset declarado en pubspec existe y el modelo lo entiende',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      final repo = IntentosLocales(lector: rootBundle.loadString);
      expect((await repo.obtenerTodos()).length, greaterThanOrEqualTo(3));
    },
  );
}
