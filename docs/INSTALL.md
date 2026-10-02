# Установка расширения intelbit-floweon-1c-extension

## Требования

- Платформа 1С:Предприятие 8.3.24 или выше
- Конфигурация: УТ 11.5, КА 2.5 или ERP 2.5
- Права администратора конфигурации

## Вариант 1: установка из .cfe (рекомендуется для prod)

1. Скачайте `.cfe`-файл из [Releases](https://github.com/SvyatoslavMikhailov/intelbit-floweon-1c-extension/releases).
2. Откройте **Конфигуратор** вашей базы данных.
3. Меню: **Конфигурация → Расширения конфигурации**.
4. В открывшемся окне: **Добавить из файла** → выберите `intelbit_river.cfe`.
5. Нажмите **Обновить конфигурацию базы данных** (F7).
6. Перезапустите пользовательский режим.

## Вариант 2: сборка из исходников (для разработчиков)

```bash
# Клонировать репозиторий
git clone git@github.com:SvyatoslavMikhailov/intelbit-floweon-1c-extension.git
cd intelbit-floweon-1c-extension

# Загрузить в конфигуратор через скрипт
./scripts/load-from-files.sh /path/to/1cv8.exe /path/to/infobase
```

После загрузки — те же шаги 4-6 из варианта 1.

## Настройка констант

После установки настройте значения констант через **Все функции → Стандартные → Константы**:

| Константа | Значение | Пример |
|---|---|---|
| `ИнтелбитРекаURL` | URL Фловеон-сервера | `https://floweon.intelbit.studio/webhooks/1c/` |
| `ИнтелбитРекаСекретWebhook` | Секрет HMAC (≥32 символа) | `my-super-secret-key-32-chars-min` |
| `ИнтелбитРекаКлиентID` | OAuth Client ID (prod) | `intelbit-onec-prod` |

> **Важно:** значение `ИнтелбитРекаСекретWebhook` должно совпадать с параметром `webhook_secret` в конфигурационном файле `intelbit-floweon-connector-onec`.

## Публикация HTTPСервиса

Чтобы внешние системы могли обращаться к HTTPСервисам расширения:

1. Откройте **Администрирование → Публикация на веб-сервере**.
2. Перейдите на вкладку **HTTP-сервисы**.
3. Включите `intelbit_river`.
4. Нажмите **Опубликовать**.

Базовый URL сервиса будет: `http://<server>/<infobase>/hs/intelbit_river/`

## Проверка установки

```bash
curl -u admin:password \
  http://localhost/your_base/hs/intelbit_river/catalog/products
# Ожидается: {"error": {"code": "ERR_NOT_IMPLEMENTED", ...}} до реализации 4-17-12
```
