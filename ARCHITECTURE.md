## Структура проекта Blast / Necsoura (черновик)

### Папки верхнего уровня

- `blast-flutter` — основной клиент:
  - Flutter‑приложение (Web, Android, iOS, desktop).
  - Внутри `web/` лежит веб‑сборка приложения blast (сам плеер).
- `blast-backend` — **наследие на PHP** (старый backend и страницы).
  - Используется сейчас как источник логики, всё постепенно переносится на Node.js.
- `backend-node` — новый backend:
  - Node.js + TypeScript + Fastify.
  - Работает как API `https://bladt.keep-pixel.ru` (музыка, плейлисты, профили Kompot, рекомендации, устройства, стриминг).
  - Папка `public/` содержит статические Necsoura‑брендированные страницы (`index.html`, `download.html`, `about.html`, `changelog.html`), которые Fastify отдаёт как лендинг.
- `blast-frontend` — старый PHP‑фронтенд (о проекте, скачать, changelog).
  - После переноса статики в `backend-node/public` может быть удалён.
- `auth-service` — микросервис авторизации Necsoura:
  - Express + JWT + MySQL.
  - Отвечает по домену `auth.keep-pixel.ru` на маршруты `/api/auth/*`.
- `blast-database` — SQL‑файлы для PostgreSQL (только музыкальный сервис blast):
  - `init.sql` — главный скрипт инициализации.
  - `schema-blast-core.sql`, `data-blast-core.sql` — структура и данные музыкальных таблиц.

### Доменные имена

- `auth.keep-pixel.ru` — Necsoura Auth (логин, регистрация, 2FA, backup‑коды, refresh).
- `bladt.keep-pixel.ru` — Node.js backend (Fastify), основной API для blast.
- `blast.keep-pixel.ru` — Web‑клиент blast (Flutter Web) + статические страницы (через `backend-node/public` или отдельный хостинг).

### Потоки

1. **Авторизация**
   - Клиент (`blast-flutter`) обращается к `auth.keep-pixel.ru/api/auth/*`.
   - Auth‑сервис выдаёт `access token` + `refresh token` с полями `{ globalId, login, type }`.
   - Flutter сохраняет:
     - `token` → в `SharedPreferences("token")`,
     - `refreshToken` → `SharedPreferences("refresh_token")`,
     - `globalId`/`login` для Necsoura.
   - Node‑backend (`backend-node`) проверяет тот же JWT через `@fastify/jwt` и `JWT_SECRET`.

2. **Профиль Kompot**
   - Таблица `kompot_profiles` в PostgreSQL привязана по `global_id`.
   - Маршрут `/user/me` в Fastify:
     - берёт `globalId` из JWT,
     - читает профиль из `kompot_profiles`,
     - отдаёт JSON с именем, аватаром, описанием, соц. ссылками и т.п.

3. **Музыка / плейлисты / история**
   - Логика из `blast-backend/*.php` переносится в `backend-node/src/routes/modules/*`.
   - Таблицы `music`, `musartist`, `albummusic`, плейлисты и т.д. лежат в PostgreSQL (см. `blast-database`).
   - Клиент (`blast-flutter`) ходит на `https://bladt.keep-pixel.ru/...` вместо старых `*.php`.

4. **Статика и веб‑лендинг**
   - `backend-node/public/*.html` — Necsoura‑брендированный лендинг:
     - `/` — главная,
     - `/download` — скачать,
     - `/about` — о проекте,
     - `/changelog` — changelog.
   - Flutter Web‑версия blast живёт в `blast-flutter/web` и отдаётся по `https://blast.keep-pixel.ru` (через nginx/хостинг).


