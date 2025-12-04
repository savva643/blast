# Backend (Fastify + TypeScript)

## Быстрый старт

```bash
cd backend-node
npm install
npm run dev
```

## Переменные окружения

Файл `.env` необходимо создать вручную (пример ниже). Значение `JWT_SECRET` **обязательно должно совпадать** с тем, что использует ваш auth‑service (`auth.keep-pixel.ru`). Иначе токены Necsoura ID не пройдут проверку.

```ini
NODE_ENV=development
PORT=4000

PG_HOST=localhost
PG_PORT=5432
PG_USER=blast
PG_PASSWORD=blast
PG_DATABASE=blast

MONGO_URI=mongodb://localhost:27017/blast
REDIS_URL=redis://localhost:6379
ELASTIC_NODE=http://localhost:9200
ELASTIC_INDEX_TRACKS=blast_tracks

JWT_SECRET=***общее_значение_с_auth-service***

AUDIO_ROOT=/var/blast/audio
CDN_BASE_URL=https://cdn.example.com/blast
```

## Маршруты

- `/user/me` — профиль пользователя (PostgreSQL `kompot_profiles`)
- `/music/*`, `/playlists/*`, `/devices`, `/recognize`, `/stream/:id`, `/search/tracks`
- `/static/*` — статика (css, изображения), HTML-страницы лежат в `public/` и отдаются через `reply.sendFile(...)`.

## Скрипты npm

- `npm run dev` — nodemon + ts-node
- `npm run build` — компиляция в `dist/`
- `npm start` — запуск собранной версии

