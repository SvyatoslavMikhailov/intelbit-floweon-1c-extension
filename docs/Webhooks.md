# Webhook-события Интелбит:Река

Расширение отправляет события на Рекa-сервер через HTTP POST с HMAC-SHA256 подписью.

## Формат подписи

Заголовок: `X-Signature: t=<unix_timestamp>,v1=<hmac_hex>`

Алгоритм вычисления (совместимо с `OneCWebhookReceiver` в `intelbit-river-connector-onec`):

```
payload = f"{timestamp}.{body_bytes}"
signature = HMAC-SHA256(secret=ИнтелбитРекаСекретWebhook, message=payload)
header = f"t={timestamp},v1={signature.hex()}"
```

Окно replay: 300 секунд (5 минут). Запросы с `|now - t| > 300` отклоняются на стороне Реки.

## Поддерживаемые типы событий

### catalog.updated

Изменение номенклатуры (добавление, редактирование, архивирование).

```json
{
  "event_type": "catalog.updated",
  "event_id": "550e8400-e29b-41d4-a716-446655440001",
  "occurred_at": "2026-05-28T12:00:00Z",
  "data": {
    "items": [
      {
        "ref_key": "nom-guid-0001",
        "code": "00001",
        "description": "Ноутбук Dell XPS 13",
        "is_archived": false
      }
    ]
  }
}
```

### stock.updated

Изменение остатков номенклатуры на складах.

```json
{
  "event_type": "stock.updated",
  "event_id": "550e8400-e29b-41d4-a716-446655440002",
  "occurred_at": "2026-05-28T12:01:00Z",
  "data": {
    "warehouse_key": "wh-guid-0001",
    "items": [
      {
        "nomenclature_key": "nom-guid-0001",
        "quantity": 15,
        "reserved": 2
      }
    ]
  }
}
```

### price.updated

Изменение цен номенклатуры.

```json
{
  "event_type": "price.updated",
  "event_id": "550e8400-e29b-41d4-a716-446655440003",
  "occurred_at": "2026-05-28T12:02:00Z",
  "data": {
    "price_type": "Розничная",
    "items": [
      {
        "nomenclature_key": "nom-guid-0001",
        "price": "89990.00",
        "currency": "RUB"
      }
    ]
  }
}
```

### order.status.changed

Изменение статуса заказа покупателя.

```json
{
  "event_type": "order.status.changed",
  "event_id": "550e8400-e29b-41d4-a716-446655440004",
  "occurred_at": "2026-05-28T13:00:00Z",
  "data": {
    "order_ref_key": "order-guid-created-0001",
    "order_number": "Ш000001",
    "old_status": "НеСогласован",
    "new_status": "Согласован"
  }
}
```

## Retry-механизм

События хранятся в регистре сведений `ИнтелбитРекаОчередьВебхуков`. Регламентное задание (`каждые 60 сек`) отправляет накопленные события пакетами до 50 штук.

| Попытка | Пауза перед следующей |
|---|---|
| 1 | — |
| 2 | 60 сек |
| 3 | 5 мин |
| 4 | 30 мин |
| 5+ | удаление из очереди (логирование ошибки) |

## Дедупликация

Каждое событие имеет уникальный `event_id` (UUID4). Python-side выполняет дедупликацию через Redis SET NX (TTL 24ч) в `OneCWebhookReceiver.deduplicate()`.
