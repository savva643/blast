### blast!

## Музыкальный стриминговый сервис (часть экосистемы Necsoura)

Репозиторий содержит несколько частей проекта:

- `blast-flutter` — основной клиент blast (Flutter, Web + мобильные/десктоп).
- `backend-node` — новый backend на Node.js + TypeScript + Fastify (API для музыки, плейлистов, устройств и профиля Kompot).
- `blast-backend` — старый PHP‑backend, откуда переносится логика (будет постепенно отключаться).
- `blast-frontend` — старый PHP‑фронтенд (страницы «о проекте», «скачать», changelog).
- `auth-service` — микросервис авторизации Necsoura (`auth.keep-pixel.ru/api/auth/*`).
- `blast-database` — SQL‑файлы для PostgreSQL (init.sql и схема музыкальных таблиц).

Более подробное описание структуры и потоков см. в `ARCHITECTURE.md`.
