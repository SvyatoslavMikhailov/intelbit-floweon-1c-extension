# HTTP-сервисы Интелбит:Река

Базовый URL: `http://<server>/<infobase>/hs/intelbit_river`

Аутентификация: `Authorization: Bearer <jwt>` (prod) или HTTP Basic (dev).

## Эндпоинты

| Метод | Путь | Описание |
|---|---|---|
| POST | `/orders/` | Создание заказа клиента |
| GET | `/orders/` | Получение заказов (по параметрам запроса) |
| GET | `/catalog/products` | Список номенклатуры с пагинацией |
| GET | `/catalog/counterparties` | Список контрагентов |
| GET | `/catalog/stocks` | Остатки по складам |

---

### POST /orders/

Создание заказа покупателя из веб-витрины.

**Тело запроса (JSON):**
```json
{
  "guid": "order-local-001",
  "number": "ВМ000001",
  "date": "2026-05-28",
  "counterparty_guid": "cp-guid-0001",
  "warehouse_guid": "wh-guid-0001",
  "lines": [
    {
      "line_number": 1,
      "nomenclature_guid": "nom-guid-0001",
      "quantity": "2",
      "price": "89990.00",
      "amount": "179980.00",
      "vat_amount": "29996.67"
    }
  ],
  "comment": "Заказ с сайта"
}
```

**Ответ 200:**
```json
{
  "Ref_Key": "order-guid-created-0001",
  "Number": "Ш000001",
  "Date": "2026-05-28T00:00:00",
  "СтатусЗаказа": "НеСогласован"
}
```

**Пример curl:**
```bash
curl -X POST \
  -u admin:password \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: $(uuidgen)" \
  -d @examples/order-create.json \
  http://localhost/your_base/hs/intelbit_river/orders/
```

---

### GET /catalog/products

Список номенклатуры с пагинацией и фильтрацией.

**Параметры запроса:**

| Параметр | Тип | Описание | По умолчанию |
|---|---|---|---|
| `$top` | int | Максимум записей | 100 |
| `$skip` | int | Пропустить N записей | 0 |
| `$filter` | string | Фильтр (OData-синтаксис) | — |

**Ответ 200:**
```json
{
  "value": [
    {
      "Ref_Key": "nom-guid-0001",
      "Code": "00001",
      "Description": "Ноутбук Dell XPS 13",
      "НаименованиеПолное": "Ноутбук Dell XPS 13 (2026), i7, 32GB, 1TB SSD",
      "ВидНоменклатуры": "Товар",
      "ЕдиницаИзмерения": "шт",
      "СтавкаНДС": "НДС20",
      "DeletionMark": false
    }
  ]
}
```

**Пример curl:**
```bash
curl -u admin:password \
  "http://localhost/your_base/hs/intelbit_river/catalog/products?\$top=10&\$skip=0"
```

---

### GET /catalog/counterparties

Список контрагентов.

**Параметры:** `$top`, `$skip`, `inn` (фильтр по ИНН).

**Пример curl:**
```bash
curl -u admin:password \
  "http://localhost/your_base/hs/intelbit_river/catalog/counterparties?inn=7701234567"
```

---

### GET /catalog/stocks

Остатки номенклатуры по складам.

**Параметры:** `warehouse_key`, `nomenclature_key`, `$top`, `$skip`.

**Ответ 200:**
```json
{
  "value": [
    {
      "НоменклатураRef_Key": "nom-guid-0001",
      "СкладRef_Key": "wh-guid-0001",
      "КоличествоОстаток": 15,
      "КоличествоРезерв": 2
    }
  ]
}
```

## Коды ошибок

| Код HTTP | КодОшибки | Описание |
|---|---|---|
| 400 | `ERR_VALIDATION` | Ошибка валидации запроса |
| 401 | `ERR_UNAUTHORIZED` | Не авторизован |
| 403 | `ERR_FORBIDDEN` | Недостаточно прав |
| 404 | `ERR_NOT_FOUND` | Объект не найден |
| 500 | `ERR_INTERNAL` | Внутренняя ошибка сервера |
| 501 | `ERR_NOT_IMPLEMENTED` | Метод не реализован (скелет v0.0.1) |

**Формат ошибки (RFC 7807):**
```json
{
  "error": {
    "code": "ERR_VALIDATION",
    "message": "Не заполнен обязательный параметр: counterparty_guid"
  }
}
```
