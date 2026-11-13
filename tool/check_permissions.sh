#!/usr/bin/env bash
# Verifica los permisos que declara un APK compilado.
# Uso: tool/check_permissions.sh build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
set -euo pipefail

apk="${1:?Uso: $0 ruta/al.apk}"
root="$(cd "$(dirname "$0")/.." && pwd)"
allowed_file="$root/tool/allowed_permissions.txt"
forbidden=(android.permission.INTERNET android.permission.ACCESS_NETWORK_STATE)

sdk="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}}"
aapt2="$(ls "$sdk"/build-tools/*/aapt2 2>/dev/null | sort -V | tail -1 || true)"
if [[ -z "$aapt2" ]]; then
  echo "No se encontró aapt2 en $sdk/build-tools." >&2
  exit 2
fi

mapfile -t declared < <("$aapt2" dump permissions "$apk" |
  sed -n "s/^uses-permission: name='\([^']*\)'.*/\1/p" | sort -u)
mapfile -t allowed < <(grep -vE '^\s*(#|$)' "$allowed_file" | sort -u)

status=0
for p in "${declared[@]}"; do
  for f in "${forbidden[@]}"; do
    if [[ "$p" == "$f" ]]; then
      echo "✗ PROHIBIDO: $p. Numo no debe tener acceso a la red." >&2
      status=1
      continue 2
    fi
  done
  if ! printf '%s\n' "${allowed[@]}" | grep -qxF "$p"; then
    echo "✗ Permiso no aprobado: $p (agrégalo a tool/allowed_permissions.txt y explica por qué)." >&2
    status=1
  fi
done

if [[ $status -eq 0 ]]; then
  echo "✓ Permisos del APK aprobados:"
  printf '  %s\n' "${declared[@]}"
fi
exit $status
