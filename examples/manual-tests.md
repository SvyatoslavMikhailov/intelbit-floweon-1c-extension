# Ручное тестирование HTTPСервисов Интелбит:Река

## Предварительные требования

- 1С 8.3.24 с установленным расширением `intelbit_river`
- Заполнены константы: `ИнтелбитРекаКлиентID`, `ИнтелбитРекаСекретWebhook`, `ИнтелбитРекаURL`
- Имя базы в URL: `your_1c_base`

## Переменные окружения

```bash
BASE="http://localhost/your_1c_base/hs/intelbit_river"
AUTH="admin:password"   # логин = ИнтелбитРекаКлиентID, пароль = ИнтелбитРекаСекретWebhook
```

---

## 1. GET /catalog/products

### Тест 1.1 — список с пагинацией

```bash
curl -s -u "$AUTH" "$BASE/catalog/products?\$top=5&\$skip=0" | python3 -m json.tool
```

Ожидаемый результат:
- HTTP 200
- Тело: `{"value": [...], "count": N}` где каждый элемент содержит `ref_key`, `name`, `sku`

### Тест 1.2 — фильтр по наименованию

```bash
curl -s -u "$AUTH" "$BASE/catalog/products?\$filter=Телефон" | python3 -m json.tool
```

### Тест 1.3 — фильтр по артикулу

```bash
curl -s -u "$AUTH" "$BASE/catalog/products?code=TW001" | python3 -m json.tool
```

### Тест 1.4 — без аутентификации (ожидаем 401)

```bash
curl -s -o /dev/null -w "%{http_code}" "$BASE/catalog/products"
# Ожидается: 401
```

---

## 2. GET /catalog/counterparties

### Тест 2.1 — список контрагентов

```bash
curl -s -u "$AUTH" "$BASE/catalog/counterparties?\$top=10" | python3 -m json.tool
```

### Тест 2.2 — поиск по ИНН

```bash
curl -s -u "$AUTH" "$BASE/catalog/counterparties?inn=7700000001" | python3 -m json.tool
```

---

## 3. GET /catalog/stocks

### Тест 3.1 — все остатки (первые 200)

```bash
curl -s -u "$AUTH" "$BASE/catalog/stocks" | python3 -m json.tool
```

### Тест 3.2 — остатки по конкретному складу

```bash
WAREHOUSE_KEY="<guid-склада-из-теста-1>"
curl -s -u "$AUTH" "$BASE/catalog/stocks?warehouse_key=$WAREHOUSE_KEY" | python3 -m json.tool
```

---

## 4. POST /orders/

### Тест 4.1 — создание заказа

```bash
curl -s -X POST \
  -u "$AUTH" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: $(uuidgen)" \
  -d '{
    "order_number": "ВИТ-2026-0001",
    "order_ref_key": "550e8400-e29b-41d4-a716-446655440001",
    "counterparty_ref_key": "<guid-контрагента>"
  }' \
  "$BASE/orders/" | python3 -m json.tool
```

Ожидаемый результат:
- HTTP 200
- Тело: `{"ref_key": "<guid>", "order_number": "ВИТ-2026-0001", "status": "НеСогласован", "created_at": "..."}`

### Тест 4.2 — заказ без обязательного поля (ожидаем 400)

```bash
curl -s -X POST \
  -u "$AUTH" \
  -H "Content-Type: application/json" \
  -d '{"counterparty_ref_key": "some-guid"}' \
  "$BASE/orders/"
# Ожидается: {"type":"about:blank","title":"ERR_VALIDATION",...}
```

### Тест 4.3 — повторный запрос с тем же Idempotency-Key

```bash
KEY="$(uuidgen)"
for i in 1 2; do
  curl -s -X POST -u "$AUTH" \
    -H "Content-Type: application/json" \
    -H "Idempotency-Key: $KEY" \
    -d '{"order_number": "ВИТ-2026-IDEM-01"}' \
    "$BASE/orders/" | python3 -m json.tool
done
# Оба запроса должны вернуть 200, второй — тот же документ
```

---

## 5. GET /orders/

### Тест 5.1 — список последних заказов

```bash
curl -s -u "$AUTH" "$BASE/orders/?\$top=5" | python3 -m json.tool
```

### Тест 5.2 — поиск по ref_key

```bash
REF_KEY="<ref_key из теста 4.1>"
curl -s -u "$AUTH" "$BASE/orders/?ref_key=$REF_KEY" | python3 -m json.tool
```

---

## 6. Webhook очередь

### Тест 6.1 — просмотр очереди в 1С

Открыть Главное меню → Инструменты → Управление → Регистр сведений  
Найти: `ИнтелбитРекаОчередьВебхуков`  
После теста 4.1 должна появиться запись с типом `order.status.changed`.

### Тест 6.2 — принудительный запуск регламентного задания

```
НСтр: Инструменты → Управление → Регламентные задания
Найти: ИнтелбитРекаОтправкаВебхуков → Выполнить сейчас
```

---

## Коды ошибок

| Код | Описание |
|-----|----------|
| `ERR_NO_AUTH_HEADER` | Отсутствует заголовок Authorization |
| `ERR_INVALID_TOKEN` | Bearer JWT недействителен или просрочен |
| `ERR_INVALID_CREDENTIALS` | Неверный логин или пароль (Basic Auth) |
| `ERR_VALIDATION` | Ошибка валидации входных данных |
| `ERR_NOT_FOUND` | Запись не найдена |
| `ERR_INTERNAL` | Внутренняя ошибка сервера |
