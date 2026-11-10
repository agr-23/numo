#!/usr/bin/env bash
# Valida que un mensaje de commit siga Conventional Commits:
#   tipo(alcance opcional)!: descripción
# Uso: tool/check_commit_msg.sh "mensaje"   o   tool/check_commit_msg.sh -f archivo
set -euo pipefail

if [[ "${1:-}" == "-f" ]]; then
  subject=$(grep -v '^#' "$2" | head -n1)
else
  subject=$(printf '%s' "${1:-}" | head -n1)
fi

types='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert'
pattern="^(${types})(\([a-z0-9-]+\))?!?: .{1,72}$"

# Commits automáticos de merge y revert de git se aceptan tal cual.
if [[ "$subject" =~ ^Merge\  ]] || [[ "$subject" =~ ^Revert\ \" ]]; then
  exit 0
fi

if [[ ! "$subject" =~ $pattern ]]; then
  echo "✖ Mensaje de commit inválido:" >&2
  echo "    $subject" >&2
  echo "" >&2
  echo "  Formato: tipo(alcance): descripción  (máx. 72 caracteres)" >&2
  echo "  Tipos:   ${types//|/, }" >&2
  echo "  Ejemplo: feat(ahorros): repartir un aporte entre bolsillos" >&2
  exit 1
fi
