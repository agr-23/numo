# Publicar una versión

## 1. Preparar

1. Actualiza `version:` en `pubspec.yaml` (ej. `1.2.0+3`; el número tras `+`
   siempre sube) y `kAppVersion` en `lib/core/constants/app_info.dart`. Una
   prueba verifica que coincidan.
2. Mueve lo que haya en **[Sin publicar]** de `CHANGELOG.md` a la nueva
   versión.
3. Haz el commit: `chore: versión 1.2.0`.

## 2. Etiquetar

```bash
git tag -a v1.2.0 -m "Numo 1.2.0"
git push origin main v1.2.0
```

El flujo [`release.yml`](../.github/workflows/release.yml) corre las pruebas,
compila el APK y crea la versión en GitHub con el archivo adjunto. La etiqueta
debe coincidir con `pubspec.yaml`.

## Firma del APK

Android solo instala una actualización encima de la versión anterior si
ambas están firmadas con **la misma clave**. Sin keystore, el APK se firma con
la clave de depuración de la máquina que lo compila, así que un APK de la CI
no actualiza uno compilado en tu computador.

### Crear el keystore (una sola vez)

```bash
keytool -genkey -v -keystore ~/numo-release.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias numo
```

Guárdalo con copia de seguridad: **si se pierde, no se pueden publicar
actualizaciones** de la app firmada con él.

### Local

Crea `android/key.properties`, que está ignorado por git:

```properties
storeFile=/home/tu-usuario/numo-release.jks
storePassword=…
keyAlias=numo
keyPassword=…
```

### CI

En GitHub, en *Settings → Secrets and variables → Actions*, agrega:

| Secreto | Valor |
|---|---|
| `NUMO_KEYSTORE_BASE64` | `base64 -w0 ~/numo-release.jks` |
| `NUMO_KEYSTORE_PASSWORD` | contraseña del keystore |
| `NUMO_KEY_ALIAS` | `numo` |
| `NUMO_KEY_PASSWORD` | contraseña de la clave |

Si no están configurados, la versión se publica igual, firmada con la clave
de depuración y con un aviso en el log.
