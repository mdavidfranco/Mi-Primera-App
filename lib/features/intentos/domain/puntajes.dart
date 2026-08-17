import 'package:miprimerapp/core/json.dart';

class Puntaje {
  const Puntaje({required this.puntos, required this.percentil});

  factory Puntaje.fromJson(Map<String, dynamic> json) => Puntaje(
    puntos: leerEntero(json, 'puntos'),
    percentil: leerEntero(json, 'percentil'),
  );

  final int puntos;
  final int percentil;

  Map<String, dynamic> toJson() => {'puntos': puntos, 'percentil': percentil};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Puntaje &&
          other.puntos == puntos &&
          other.percentil == percentil;

  @override
  int get hashCode => Object.hash(puntos, percentil);

  @override
  String toString() => 'Puntaje($puntos pts, percentil $percentil)';
}
