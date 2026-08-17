import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:miprimerapp/core/json.dart';
import 'package:miprimerapp/features/intentos/domain/estado_intento.dart';
import 'package:miprimerapp/features/intentos/domain/intento.dart';
import 'package:miprimerapp/features/intentos/domain/puntajes.dart';

Intento ejemplo({EstadoIntento? estado}) => Intento(
  id: 'intento-001',
  estudianteId: 'est-045',
  simulacroId: 'sim-matematicas-01',
  iniciadoEn: DateTime.utc(2026, 8, 10, 14, 0),
  estado: estado ?? const EnProgreso(1),
);

void main() {
  group('serialización', () {
    test('un intento sobrevive la ida y vuelta a JSON sin perder nada', () {
      final original = ejemplo(
        estado: Calificado(
          DateTime.utc(2026, 8, 10, 15, 30),
          const Puntaje(puntos: 320, percentil: 85),
          'Buen desempeño en álgebra.',
        ),
      );

      final texto = jsonEncode(original.toJson());
      final vuelta = Intento.fromJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );

      expect(vuelta, equals(original));
    });

    test('un intento sin id dice qué campo falló', () {
      final json = ejemplo().toJson()..remove('id');

      expect(
        () => Intento.fromJson(json),
        throwsA(isA<CampoInvalido>().having((e) => e.campo, 'campo', 'id')),
      );
    });

    test('una fecha que no es ISO 8601 se rechaza', () {
      final json = ejemplo().toJson()..['iniciadoEn'] = '10 de agosto';
      expect(() => Intento.fromJson(json), throwsA(isA<CampoInvalido>()));
    });

    test('la hora se conserva en UTC', () {
      final json = ejemplo().toJson();
      expect(json['iniciadoEn'], '2026-08-10T14:00:00.000Z');
    });

    test('un estado desconocido se rechaza', () {
      final json = ejemplo().toJson();
      json['estado'] = {'tipo': 'no_existe'};
      expect(() => Intento.fromJson(json), throwsA(isA<CampoInvalido>()));
    });
  });

  group('igualdad', () {
    test('dos intentos con los mismos datos son iguales', () {
      expect(ejemplo(), equals(ejemplo()));
    });

    test('dos intentos con los mismos datos comparten hashCode', () {
      expect(ejemplo().hashCode, equals(ejemplo().hashCode));
      expect({ejemplo(), ejemplo()}.length, 1);
    });

    test('dos intentos con estados distintos no son iguales', () {
      expect(
        ejemplo(estado: const EnProgreso(1)),
        isNot(equals(ejemplo(estado: const EnProgreso(2)))),
      );
    });

    test('copyWith cambia solo el estado', () {
      final original = ejemplo();
      final copia = original.copyWith(
        estado: Pausado(DateTime.utc(2026, 8, 10, 16, 0)),
      );
      expect(copia.id, original.id);
      expect(copia.estado, isA<Pausado>());
    });
  });

  group('reglas de negocio', () {
    test('un intento calificado no se puede continuar', () {
      final intento = ejemplo(
        estado: Calificado(
          DateTime.utc(2026, 8, 10, 15, 30),
          const Puntaje(puntos: 320, percentil: 85),
          'Bien',
        ),
      );
      expect(intento.sePuedeContinuar, isFalse);
    });

    test('un intento en progreso sí se puede continuar', () {
      expect(ejemplo(estado: const EnProgreso(1)).sePuedeContinuar, isTrue);
    });

    test('un intento en progreso de más de 6 horas está estancado', () {
      final ahora = DateTime.utc(2026, 8, 10, 21, 0);
      expect(ejemplo().estaEstancado(ahora), isTrue);
    });
  });
}
