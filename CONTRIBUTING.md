# Contributing

Этот репозиторий поставляется под Apache License 2.0. Все контрибуции принимаются на этих же условиях.

## DCO sign-off обязателен

Все коммиты должны быть подписаны:

```bash
git commit -s -m "your commit message"
```

Это добавит `Signed-off-by: Your Name <your.email@example.com>` в commit message — подтверждение,
что вы имеете право вносить эту работу под условиями репозитория.

CI на PR проверяет наличие sign-off через `.github/workflows/dco.yml`.

## Workflow

1. Fork репозиторий.
2. Создать ветку `feature/<short-name>` от `main`.
3. Сделать изменения с DCO sign-off (`-s` флаг каждого commit).
4. Для BSL-кода: экспортировать конфигурацию в `src/` через `scripts/dump-to-files.sh`.
5. Открыть PR в `main`.

## Code style

- BSL: на русском (согласно конвенциям 1С).
- Public API HTTPСервисов — с docstrings.
- XML-файлы расширения — отформатированы по 4 пробела отступ.
- Сообщения коммитов и комментарии в коде — на русском.

## Контакты

vceo@intelbit.ru
