import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:miprimerapp/core/json.dart';
import 'package:miprimerapp/features/intentos/domain/intento.dart';
import 'package:miprimerapp/features/intentos/domain/intentos_repository.dart';

typedef LectorDeAssets = Future<String> Function(String ruta);

class IntentosLocales implements IntentosRepository {
  IntentosLocales({
    LectorDeAssets? lector,
    this.ruta = 'assets/data/intentos.json',
  }) : _lector = lector ?? rootBundle.loadString;

  final LectorDeAssets _lector;
  final String ruta;

  List<Intento>? _cache;

  @override
  Future<List<Intento>> obtenerTodos() async {
    final guardado = _cache;
    if (guardado != null) return guardado;

    final crudo = await _lector(ruta);
    final decodificado = jsonDecode(crudo);

    if (decodificado is! List) {
      throw const CampoInvalido(
        '(raíz)',
        'el archivo debe contener una lista',
        null,
      );
    }

    return _cache = decodificado
        .map((e) => Intento.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<Intento?> obtenerPorId(String id) async {
    for (final intento in await obtenerTodos()) {
      if (intento.id == id) return intento;
    }
    return null;
  }

  @override
  Future<List<Intento>> obtenerPorEstudiante(String estudianteId) async {
    final todos = await obtenerTodos();
    return todos
        .where((intento) => intento.estudianteId == estudianteId)
        .toList();
  }
}
