# Выбор уровня рассуждений в Claude Desktop

[![Claude Desktop](https://img.shields.io/badge/Claude%20Desktop-Compatible-orange?logo=anthropic)](https://claude.ai/download)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue)](#)
[![License](https://img.shields.io/badge/License-MIT-purple)](#)

Мод для приложения **Claude Desktop**, который добавляет в интерфейс удобный интерактивный ползунок выбора уровня рассуждений

---

## Что делает этот мод

- **Добавляет выбор глубины рассуждений**: прямо в меню модели появляется шкала уровней:
  - **Низкий** (Low) — быстрые ответы без долгих пауз;
  - **Средний** (Medium) — баланс скорости и глубины;
  - **Высокий** (High) — глубокие размышления над сложными задачами;
  - **Максимум** (Max) — максимальный анализ с визуальным звёздным эффектом и тёплым свечением в стиле Claude Code.
- **100% нативный дизайн**: сохраняет оригинальный серый вид интерфейса Claude Desktop без посторонних рамок и лишних элементов.
- **Установка и удаление в 1 клик**: без правок кода и сложных настроек.

---

## Установка

### Windows (в 1 клик)
1. Скачайте архив репозитория (кнопка **Code → Download ZIP**).
2. Запустите файл **`install.bat`** двойным кликом.
3. Перезапустите Claude Desktop.

### macOS / Linux

**Вариант 1: В 1 команду через терминал (быстрее всего)**
```bash
git clone https://github.com/santoxas-1/claude-desktop-reasoning-effort.git && cd claude-desktop-reasoning-effort && chmod +x install.sh && ./install.sh
```

**Вариант 2: Через скачивание архива (ZIP)**
1. Скачайте архив (кнопка **Code → Download ZIP**) и дважды кликните по нему для распаковки.
2. Откройте **Терминал**, перейдите в распакованную папку и выполните:
```bash
chmod +x install.sh && ./install.sh
```
3. Перезапустите Claude Desktop (или нажмите `Cmd + R`).

---

## Обновление

Если приложение Claude Desktop обновилось и затёрло файлы:
- **Windows**: Запустите **`update.bat`** — скрипт восстановит работу мода за 1 секунду.
- **macOS / Linux**: Выполните `./update.sh`.

---

## Удаление

- **Windows**: Запустите **`uninstall.bat`** — восстановит исходный интерфейс из резервной копии.
- **macOS / Linux**: Выполните `./uninstall.sh`.

---

## Лицензия
MIT License © 2026
