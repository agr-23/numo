# Marca de Numo

<img src="numo-icon.svg" width="120" alt="Ícono de Numo">

**Dirección «Punto».** Un anillo es la moneda y el punto verde dice que tu
saldo está al día. La marca casi desaparece: no tiene un color propio, y el
único color es el que en la app ya significa «a favor».

## Qué es marca y qué no

| Marca (este documento) | App (`NumoPalette`) |
|---|---|
| Ícono, pantalla de arranque, logo | Todas las pantallas |
| `NumoBrand` en `lib/core/theme/numo_brand.dart` | `context.palette` |

Elegir o ajustar la marca **no cambia** los colores ni las pantallas de la
app.

## Colores

| | Hex | Origen |
|---|---|---|
| Tinta (fondo) | `#111114` | `NumoPalette.light.ink` |
| Anillo | `#FFFFFF` | |
| Punto | `#3DD68C` | `NumoPalette.dark.income` |

Una prueba (`test/brand_test.dart`) verifica que estos valores coincidan en
Dart y en los recursos de Android.

## Archivos

| Archivo | Uso |
|---|---|
| `numo-icon.svg` | Ícono maestro (108 × 108, esquinas de 26) |
| `numo-icon-512.png` | Tiendas y redes |
| `android/.../drawable/ic_launcher_foreground.xml` | Ícono adaptativo, escalado al 75 % para la zona segura de 66 dp |
| `android/.../drawable/ic_launcher_monochrome.xml` | Íconos temáticos de Android 13+ |
| `android/.../mipmap-*/ic_launcher.png` | Android 7 (sin ícono adaptativo) |
| `lib/presentation/widgets/numo_mark.dart` | El símbolo dentro de la app |

Los PNG se generan desde el SVG:

```bash
rsvg-convert -w 512 -h 512 docs/brand/numo-icon.svg -o docs/brand/numo-icon-512.png
```

## Logo

`numo` en Inter Bold, minúsculas, con espaciado de −5 %, seguido del punto
verde. En fondo claro, el punto usa el verde de ingreso claro (`#0B7A50`).

## No hacer

- No cambiar el verde del punto por otro color: el verde significa «a favor».
- No agregar sombras, degradados ni contornos al ícono.
- No usar los colores de la marca de bancos o billeteras (morados, magentas o
  amarillos dominantes).
