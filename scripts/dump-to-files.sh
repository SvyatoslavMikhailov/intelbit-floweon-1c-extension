#!/bin/bash
# dump-to-files.sh — экспорт конфигурации 1С в текстовые файлы для git-версионирования.
# Использует штатный инструмент 1С: 1cv8 DESIGNER /DumpConfigToFiles
#
# Использование:
#   ./scripts/dump-to-files.sh [путь_к_1cv8] [строка_подключения]
#
# Примеры:
#   ./scripts/dump-to-files.sh \
#     "/opt/1cv8/8.3.24.0/1cv8" \
#     "File=/path/to/base;Usr=admin;Pwd=password"

set -euo pipefail

ONEC_BIN="${1:-/opt/1cv8/bin/1cv8}"
CONNECT_STRING="${2:-}"
SRC_DIR="$(cd "$(dirname "$0")/.." && pwd)/src"

if [[ -z "$CONNECT_STRING" ]]; then
    echo "Ошибка: укажите строку подключения к базе 1С вторым аргументом." >&2
    echo "Пример: ./scripts/dump-to-files.sh /opt/1cv8/bin/1cv8 'File=/path/base'" >&2
    exit 1
fi

echo "Экспорт конфигурации в $SRC_DIR ..."
"$ONEC_BIN" DESIGNER \
    /IBConnectionString "$CONNECT_STRING" \
    /DumpConfigToFiles "$SRC_DIR" \
    /Extension "intelbit_river"

echo "Готово. Проверьте изменения командой: git diff src/"
