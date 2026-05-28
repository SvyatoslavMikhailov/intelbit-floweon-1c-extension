#!/bin/bash
# load-from-files.sh — импорт исходников из git в конфигурацию 1С.
# Загружает файлы из src/ и обновляет конфигурацию базы данных.
#
# Использование:
#   ./scripts/load-from-files.sh [путь_к_1cv8] [строка_подключения]
#
# Примеры:
#   ./scripts/load-from-files.sh \
#     "/opt/1cv8/8.3.24.0/1cv8" \
#     "File=/path/to/base;Usr=admin;Pwd=password"

set -euo pipefail

ONEC_BIN="${1:-/opt/1cv8/bin/1cv8}"
CONNECT_STRING="${2:-}"
SRC_DIR="$(cd "$(dirname "$0")/.." && pwd)/src"

if [[ -z "$CONNECT_STRING" ]]; then
    echo "Ошибка: укажите строку подключения к базе 1С вторым аргументом." >&2
    echo "Пример: ./scripts/load-from-files.sh /opt/1cv8/bin/1cv8 'File=/path/base'" >&2
    exit 1
fi

echo "Загрузка конфигурации из $SRC_DIR ..."
"$ONEC_BIN" DESIGNER \
    /IBConnectionString "$CONNECT_STRING" \
    /LoadConfigFromFiles "$SRC_DIR" \
    /Extension "intelbit_river" \
    /UpdateDBCfg

echo "Готово. Расширение intelbit_river обновлено в базе данных."
