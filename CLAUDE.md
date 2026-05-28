# CLAUDE.md — intelbit-river-1c-extension

## Контекст

Публичное расширение конфигурации 1С для **Интелбит:Река**. Целевые конфигурации: УТ 11.5, КА 2.5, ERP 2.5. Паспорт проекта в Obsidian: `4-17 Паспорт проекта — Интелбит Река.md`.

## Связь с Python-клиентом

Python-side: `intelbit-river-connector-onec` (в `~/Developer/`) — клиент, который ходит сюда через HTTPСервисы и принимает webhook'и отсюда. Сигнатуры методов в BSL должны быть совместимы с клиентом.

## Язык

Общение и комментарии в BSL-коде — на русском (по правилу `~/.claude/CLAUDE.md` и по конвенциям 1С-разработки). Идентификаторы BSL — на русском (принято в 1С-экосистеме). Имена XML-объектов и HTTP-путей — на английском (технические артефакты).

## Workflow

Промпт-файлы — в Obsidian `4-17 Интелбит Река/04 Промпты для Claude Code/`. После работы — статус в `Статус разработки.md`.

Не пушить автоматически — жду команды «push» от Свята.

---

## LLM Coding Guidelines (Karpathy)

Behavioral guidelines to reduce common LLM coding mistakes.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

*Source: https://github.com/forrestchang/andrej-karpathy-skills/blob/main/CLAUDE.md*
