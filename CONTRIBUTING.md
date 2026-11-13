# Cómo contribuir

¡Gracias por ayudar a mejorar Numo! Esta guía resume cómo trabajamos.

## Preparar el entorno

1. Instala Flutter 3.47 (canal estable) y Java 17.
2. `flutter pub get`
3. Activa el hook de commits: `git config core.hooksPath tool/hooks`

## Flujo de trabajo

1. Crea una rama desde `main`: `tipo/descripcion-corta`
   (ej. `feat/exportar-pdf`, `fix/simbolo-moneda`).
2. Haz commits pequeños y con un solo propósito.
3. Antes de abrir el pull request, verifica:

   ```bash
   dart format .
   flutter analyze --fatal-infos
   flutter test
   ```

4. Abre el pull request contra `main` y completa la plantilla. La CI debe
   pasar antes de integrar.

## Mensajes de commit

Usamos [Conventional Commits](https://www.conventionalcommits.org/es/):

```
tipo(alcance): descripción en minúscula, en presente, máx. 72 caracteres

Cuerpo opcional: qué cambia y por qué (no cómo).
```

| Tipo | Para |
|---|---|
| `feat` | una funcionalidad nueva |
| `fix` | corregir un error |
| `docs` | solo documentación |
| `style` | formato, sin cambiar comportamiento |
| `refactor` | reorganizar código sin cambiar comportamiento |
| `perf` | mejorar rendimiento |
| `test` | agregar o corregir pruebas |
| `build` | dependencias, Gradle, pubspec |
| `ci` | flujos de GitHub Actions |
| `chore` | mantenimiento que no entra en lo anterior |

Alcances habituales: `ahorros`, `cuentas`, `movimientos`, `presupuestos`,
`analiticas`, `ajustes`, `onboarding`, `ui`, `i18n`, `datos`.

Un cambio incompatible lleva `!`, por ejemplo `feat(datos)!: …`, y en el cuerpo
`BREAKING CHANGE: …`.

Ejemplos:

```
feat(ahorros): repartir un aporte entre bolsillos
fix(cuentas): mostrar el disponible descontando lo apartado
docs: explicar cómo firmar el APK
```

## Convenciones de código

- **Textos visibles**: nunca escritos en el código. Van en
  `lib/l10n/app_es.arb` y `app_en.arb` y se usan con `context.l10n.clave`.
- **Colores**: siempre desde `context.palette` (`NumoPalette`), que tiene
  versión clara y oscura. Nada de `Colors.white` ni hex sueltos en pantallas.
- **Montos**: `CurrencyFormatter` para mostrarlos y `AmountInput` o
  `AmountField` para escribirlos.
- **Lógica con cálculos** (fechas, montos, bolsillos): en funciones puras con
  pruebas en `test/`.
- **Modelos de Isar**: tras cambiarlos, `dart run build_runner build` y
  commitea los `.g.dart`. Los campos nuevos deben aceptar nulos o tener
  migración, para no perder datos de quien actualiza.
- Comentarios y documentación en español.

## Permisos y dependencias

Numo no tiene permiso de internet: es la garantía de que los datos no salen
del teléfono. La CI compila el APK y falla si:

- aparece `INTERNET` o `ACCESS_NETWORK_STATE` (prohibidos siempre);
- aparece un permiso que no esté en `tool/allowed_permissions.txt`;
- cambian las dependencias directas sin actualizar
  `tool/allowed_dependencies.txt`.

Agregar un permiso o una dependencia exige actualizar la lista en el mismo PR
y explicar por qué, para que quede a la vista en la revisión.
