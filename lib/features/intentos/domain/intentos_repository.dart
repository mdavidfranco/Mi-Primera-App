import 'package:miprimerapp/features/intentos/domain/intento.dart';

abstract interface class IntentosRepository {
  Future<List<Intento>> obtenerTodos();

  Future<Intento?> obtenerPorId(String id);

  Future<List<Intento>> obtenerPorEstudiante(String estudianteId);
}
