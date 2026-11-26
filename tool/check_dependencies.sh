#!/usr/bin/env bash
# Compara las dependencias directas de pubspec.yaml con la lista aprobada.
# Requiere haber corrido `flutter pub get`.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

actual="$(dart pub deps --json |
  jq -r '.packages[] | select(.kind == "direct" or .kind == "dev") | .name' | sort -u)"
allowed="$(grep -vE '^\s*(#|$)' tool/allowed_dependencies.txt | sort -u)"

added="$(comm -23 <(echo "$actual") <(echo "$allowed"))"
removed="$(comm -13 <(echo "$actual") <(echo "$allowed"))"

if [[ -n "$added" || -n "$removed" ]]; then
  [[ -n "$added" ]] && echo "✗ Dependencias nuevas sin aprobar:" >&2 && sed 's/^/  + /' <<<"$added" >&2
  [[ -n "$removed" ]] && echo "✗ Dependencias quitadas de pubspec pero aún en la lista:" >&2 && sed 's/^/  - /' <<<"$removed" >&2
  echo "Actualiza tool/allowed_dependencies.txt en el mismo PR." >&2
  exit 1
fi
echo "✓ Dependencias directas aprobadas ($(wc -l <<<"$actual"))."
