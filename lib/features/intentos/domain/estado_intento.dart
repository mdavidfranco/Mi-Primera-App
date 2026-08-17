import 'package:miprimerapp/core/json.dart';
import 'package:miprimerapp/features/intentos/domain/puntajes.dart';

sealed class EstadoIntento {
  const EstadoIntento();

  factory EstadoIntento.fromJson(Map<String, dynamic> json) {
    final tipo = leerTexto(json, 'tipo');
    return switch (tipo) {
      'en_progreso' => EnProgreso(leerEntero(json, 'preguntaActual')),
      'pausado' => Pausado(leerFecha(json, 'pausadoEn')),
      'finalizado' => Finalizado(leerFecha(json, 'finalizadoEn')),
      'calificado' => Calificado(
        leerFecha(json, 'finalizadoEn'),
        Puntaje.fromJson(leerMapa(json, 'puntaje')),
        leerTexto(json, 'retroalimentacion'),
      ),
      'abandonado' => Abandonado(
        leerFecha(json, 'abandonadoEn'),
        leerTexto(json, 'motivo'),
      ),
      _ => throw CampoInvalido('estado.tipo', 'no es un estado conocido', tipo),
    };
  }

  Map<String, dynamic> toJson() => switch (this) {
    EnProgreso(:final preguntaActual) => {
      'tipo': 'en_progreso',
      'preguntaActual': preguntaActual,
    },
    Pausado(:final pausadoEn) => {
      'tipo': 'pausado',
      'pausadoEn': pausadoEn.toIso8601String(),
    },
    Finalizado(:final finalizadoEn) => {
      'tipo': 'finalizado',
      'finalizadoEn': finalizadoEn.toIso8601String(),
    },
    Calificado(:final finalizadoEn, :final puntaje, :final retroalimentacion) =>
      {
        'tipo': 'calificado',
        'finalizadoEn': finalizadoEn.toIso8601String(),
        'puntaje': puntaje.toJson(),
        'retroalimentacion': retroalimentacion,
      },
    Abandonado(:final abandonadoEn, :final motivo) => {
      'tipo': 'abandonado',
      'abandonadoEn': abandonadoEn.toIso8601String(),
      'motivo': motivo,
    },
  };

  bool get sePuedeContinuar => switch (this) {
    EnProgreso() || Pausado() => true,
    Finalizado() || Calificado() || Abandonado() => false,
  };

  String get etiqueta => switch (this) {
    EnProgreso(:final preguntaActual) =>
      'En progreso · pregunta $preguntaActual',
    Pausado() => 'Pausado',
    Finalizado() => 'Finalizado, pendiente de calificar',
    Calificado(:final puntaje) => 'Calificado · ${puntaje.puntos} pts',
    Abandonado(:final motivo) => 'Abandonado: $motivo',
  };
}

final class EnProgreso extends EstadoIntento {
  const EnProgreso(this.preguntaActual);

  final int preguntaActual;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnProgreso && other.preguntaActual == preguntaActual;

  @override
  int get hashCode => Object.hash(runtimeType, preguntaActual);

  @override
  String toString() => 'EnProgreso($preguntaActual)';
}

final class Pausado extends EstadoIntento {
  const Pausado(this.pausadoEn);

  final DateTime pausadoEn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pausado && other.pausadoEn == pausadoEn;

  @override
  int get hashCode => Object.hash(runtimeType, pausadoEn);

  @override
  String toString() => 'Pausado($pausadoEn)';
}

final class Finalizado extends EstadoIntento {
  const Finalizado(this.finalizadoEn);

  final DateTime finalizadoEn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Finalizado && other.finalizadoEn == finalizadoEn;

  @override
  int get hashCode => Object.hash(runtimeType, finalizadoEn);

  @override
  String toString() => 'Finalizado($finalizadoEn)';
}

final class Calificado extends EstadoIntento {
  const Calificado(this.finalizadoEn, this.puntaje, this.retroalimentacion);

  final DateTime finalizadoEn;
  final Puntaje puntaje;
  final String retroalimentacion;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Calificado &&
          other.finalizadoEn == finalizadoEn &&
          other.puntaje == puntaje &&
          other.retroalimentacion == retroalimentacion;

  @override
  int get hashCode =>
      Object.hash(runtimeType, finalizadoEn, puntaje, retroalimentacion);

  @override
  String toString() => 'Calificado($finalizadoEn, $puntaje)';
}

final class Abandonado extends EstadoIntento {
  const Abandonado(this.abandonadoEn, this.motivo)
    : assert(motivo != '', 'abandonar exige motivo');

  final DateTime abandonadoEn;
  final String motivo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Abandonado &&
          other.abandonadoEn == abandonadoEn &&
          other.motivo == motivo;

  @override
  int get hashCode => Object.hash(runtimeType, abandonadoEn, motivo);

  @override
  String toString() => 'Abandonado($motivo)';
}
