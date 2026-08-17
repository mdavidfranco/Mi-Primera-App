import 'package:miprimerapp/core/json.dart';
import 'package:miprimerapp/features/intentos/domain/estado_intento.dart';

class Intento {
  const Intento({
    required this.id,
    required this.estudianteId,
    required this.simulacroId,
    required this.iniciadoEn,
    required this.estado,
  });

  factory Intento.fromJson(Map<String, dynamic> json) => Intento(
    id: leerTexto(json, 'id'),
    estudianteId: leerTexto(json, 'estudianteId'),
    simulacroId: leerTexto(json, 'simulacroId'),
    iniciadoEn: leerFecha(json, 'iniciadoEn'),
    estado: EstadoIntento.fromJson(leerMapa(json, 'estado')),
  );

  final String id;
  final String estudianteId;
  final String simulacroId;
  final DateTime iniciadoEn;
  final EstadoIntento estado;

  Map<String, dynamic> toJson() => {
    'id': id,
    'estudianteId': estudianteId,
    'simulacroId': simulacroId,
    'iniciadoEn': iniciadoEn.toUtc().toIso8601String(),
    'estado': estado.toJson(),
  };

  bool get sePuedeContinuar => estado.sePuedeContinuar;

  Duration antiguedad(DateTime ahora) => ahora.difference(iniciadoEn);

  bool estaEstancado(DateTime ahora) =>
      estado is EnProgreso && antiguedad(ahora) > const Duration(hours: 6);

  Intento copyWith({EstadoIntento? estado}) => Intento(
    id: id,
    estudianteId: estudianteId,
    simulacroId: simulacroId,
    iniciadoEn: iniciadoEn,
    estado: estado ?? this.estado,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Intento &&
          other.id == id &&
          other.estudianteId == estudianteId &&
          other.simulacroId == simulacroId &&
          other.iniciadoEn == iniciadoEn &&
          other.estado == estado;

  @override
  int get hashCode =>
      Object.hash(id, estudianteId, simulacroId, iniciadoEn, estado);

  @override
  String toString() => 'Intento($id, $estudianteId, ${estado.etiqueta})';
}
