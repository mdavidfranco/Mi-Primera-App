# miprimerapp

Plataforma para que estudiantes hagan seguimiento a sus simulacros de preparación ICFES: en qué intento se quedaron y qué puntaje obtuvieron.

## Dominio

- `Intento` — entidad principal. Identidad: `id`.
- `Puntaje` — objeto de valor.
- `EstadoIntento` — sellada: EnProgreso · Pausado · Finalizado · Calificado · Abandonado.

Decisión: El modelo se escribió a mano, porque priorizo el manejo de errores, ya que de esta manera podemos saber que campo falló exactamente y por qué.

## Cómo correrlo

    flutter pub get
    flutter test
    flutter run

# Captura de Flutter Doctor

![Captura de Flutter Doctor](img/Captura%20de%20pantalla%202026-08-12%20173337.png)
