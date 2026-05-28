# intelbit-river-1c-extension

Расширение конфигурации 1С (УТ 11.5, КА 2.5, ERP 2.5) для **Интелбит:Река** — открытой интеграционной шины данных для торговых компаний.

Устанавливается как расширение конфигурации (не правит типовую), что сохраняет поддержку конфигурации клиента.

## Что умеет (v0.0.1 — скелет)

- ⏳ HTTPСервисы (orders / catalog/products / catalog/counterparties / catalog/stocks) — **в реализации** (Промпт 4-17-12)
- ⏳ Webhook publisher (catalog.updated / stock.updated / price.updated / order.status.changed) с HMAC-SHA256 — **в реализации**
- ⏳ EnterpriseData-обёртка для регламентных обменов — **в реализации**

## Что будет в v0.1.0 (MVP Реки)

- ✅ 5 HTTPСервисов для двусторонней интеграции (orders POST/GET, catalog ×3)
- ✅ Webhook publisher с retry через регистр сведений + регламентное задание (каждые 60 сек)
- ✅ HMAC-SHA256 подпись исходящих событий (`X-Signature: t=,v1=`)
- ✅ Аутентификация Bearer JWT (prod) + Basic (dev)
- ✅ Поддержка УТ 11.5, КА 2.5, ERP 2.5 через общий слой

## Установка

См. [docs/INSTALL.md](docs/INSTALL.md).

## Конфигурация

После установки расширения настройте три константы через «Все функции → Константы» или форму настройки:

| Константа | Описание |
|---|---|
| `ИнтелбитРекаURL` | URL Река-сервера для webhook-событий |
| `ИнтелбитРекаСекретWebhook` | Секрет HMAC-SHA256 (≥32 символа) |
| `ИнтелбитРекаКлиентID` | OAuth Client ID (prod) |

## Структура репозитория

```
src/                        # текстовый экспорт расширения (git-friendly)
├── Configuration.xml       # манифест расширения v8.3.24+
├── HTTPServices/           # REST API эндпоинты
├── CommonModules/          # общие модули (аутентификация, вебхуки, EnterpriseData)
├── ScheduledJobs/          # регламентное задание отправки вебхуков
├── InformationRegisters/   # очередь исходящих вебхуков с retry
└── Constants/              # URL, секрет, client_id
docs/                       # документация
scripts/                    # утилиты для версионирования через git
examples/                   # примеры curl и webhook payload
```

## Связанные проекты

- **intelbit-river-connector-onec** — Python-клиент, который вызывает эти HTTPСервисы и принимает вебхуки: [github.com/SvyatoslavMikhailov/intelbit-river-connector-onec](https://github.com/SvyatoslavMikhailov/intelbit-river-connector-onec)
- **Интелбит:Река** — главный продукт (monorepo): [github.com/SvyatoslavMikhailov/intelbit-river-monorepo](https://github.com/SvyatoslavMikhailov/intelbit-river-monorepo)

## Совместимость

| Конфигурация 1С | Версия | Статус |
|---|---|---|
| Управление торговлей | 11.5+ | ✅ Целевая |
| Комплексная автоматизация | 2.5+ | ✅ Целевая |
| ERP Управление предприятием | 2.5+ | ✅ Целевая |
| Платформа 1С | 8.3.24+ | Минимальная |

Подробности: [docs/COMPATIBILITY.md](docs/COMPATIBILITY.md).
