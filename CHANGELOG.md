# Cambios

Todos los cambios relevantes de Numo. El formato sigue
[Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y el proyecto usa
[versionado semántico](https://semver.org/lang/es/).

## [Sin publicar]

## [1.1.0] - 2026-11-10

### Agregado
- Español e inglés: el idioma se elige en la bienvenida o en Ajustes, o se
  sigue el del teléfono.
- Rediseño "Nítido": nueva paleta clara y oscura, tipografía Inter incluida y
  nuevo Inicio con carrusel, accesos rápidos y opción de ocultar montos.
- Tarjetas de crédito con cupo, deuda, fecha de corte, fecha límite de pago y
  botón "Pagar tarjeta".
- Ahorros por grupos con bolsillos mensuales, anuales y metas, plantillas,
  aportes sugeridos, repartir un aporte y pagar gastos desde un bolsillo.
- Montos con separadores de miles mientras se escriben.

### Cambiado
- Las metas de ahorro existentes se convierten en grupos de un bolsillo sin
  perder lo ahorrado.
- "Dinero total" ya no suma dos veces el dinero apartado.

### Corregido
- Texto invisible en los campos con modo oscuro.
- Selectores de fecha que salían en inglés.
- Símbolo de moneda que aparecía al final ("3.136.000 $").
- Montos con decimales que se guardaban mal (12.50 → 1250).

## [1.0.0] - 2026-06-11

### Agregado
- Primera versión: movimientos, cuentas, presupuestos, metas, análisis, PIN y
  huella, exportación a CSV.

[Sin publicar]: https://github.com/agr-23/numo/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/agr-23/numo/releases/tag/v1.1.0
