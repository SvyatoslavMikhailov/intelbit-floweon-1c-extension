#!/bin/bash
# curl-requests.sh — примеры HTTP-вызовов к HTTPСервисам Интелбит:Река.
# Замените BASE_URL и CREDENTIALS на реальные значения вашего окружения.

BASE_URL="http://localhost/your_1c_base/hs/intelbit_river"
CREDENTIALS="admin:password"

echo "=== Проверка доступности (список номенклатуры) ==="
curl -s -u "$CREDENTIALS" \
  "$BASE_URL/catalog/products?\$top=5" | python3 -m json.tool

echo ""
echo "=== Список контрагентов ==="
curl -s -u "$CREDENTIALS" \
  "$BASE_URL/catalog/counterparties?\$top=5" | python3 -m json.tool

echo ""
echo "=== Остатки по складу ==="
curl -s -u "$CREDENTIALS" \
  "$BASE_URL/catalog/stocks?warehouse_key=wh-guid-0001&\$top=10" | python3 -m json.tool

echo ""
echo "=== Создание заказа (POST) ==="
curl -s -X POST \
  -u "$CREDENTIALS" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: $(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid)" \
  -d "$(cat "$(dirname "$0")/webhook-payload.json")" \
  "$BASE_URL/orders/" | python3 -m json.tool
